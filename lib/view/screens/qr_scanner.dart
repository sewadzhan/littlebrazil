import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:littlebrazil/data/models/cart_item.dart';
import 'package:littlebrazil/data/models/checkout.dart';
import 'package:littlebrazil/data/models/order.dart';
import 'package:littlebrazil/data/models/product.dart';
import 'package:littlebrazil/logic/blocs/qr_scanner/qr_scanner_bloc.dart';
import 'package:littlebrazil/view/components/custom_outlined_button.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QRScannerBloc, QRScannerState>(
      listener: (context, state) {
        if (state is QRScannerError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(Constants.errorSnackBar(context, state.message));
        } else if (state is QRScannerSuccessScan) {
          Navigator.pushNamed(context, '/successQRscanned',
              arguments: state.order);
        }
      },
      child: Scaffold(
        backgroundColor: Constants.backgroundColor,
        appBar: AppBar(
          backgroundColor: Constants.backgroundColor,
          leading: TextButton(
            style: TextButton.styleFrom(
              shape: const CircleBorder(),
            ),
            child: SizedBox(
              width: 25,
              child: SvgPicture.asset('assets/icons/cross.svg',
                  colorFilter: const ColorFilter.mode(
                      Constants.darkGrayColor, BlendMode.srcIn)),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
              padding: EdgeInsets.all(Constants.defaultPadding),
              decoration: const BoxDecoration(
                  color: Constants.backgroundColor,
                  border: Border(
                      top: BorderSide(
                          color: Constants.lightGrayColor, width: 1))),
              child: CustomOutlinedButton(
                  text: "ВКЛЮЧИТЬ ФОНАРИК",
                  function: () async {
                    Navigator.pushNamed(context, '/successQRscanned',
                        arguments: Order(
                            phoneNumber: 'sdf',
                            fullAddress: 'г. Алматы, пр. Аль-Фараби, 140А',
                            deliveryCost: 0,
                            discount: 0,
                            subtotal: 0,
                            total: 66000,
                            paymentMethod: PaymentMethod.kaspi,
                            orderType: OrderType.delivery,
                            cartItems: const [
                              CartItemModel(
                                  product: Product(
                                      categoryID: "",
                                      title: "Рибай Стейк",
                                      categoryTitle: "Стейки",
                                      price: 3500,
                                      rmsID: '',
                                      description: '',
                                      imageUrls: ['']),
                                  count: 3)
                            ],
                            id: 1234,
                            dateTime: DateTime.now(),
                            cashbackUsed: 0,
                            comments: ''));
                    // try {
                    //   if (controller != null) {
                    //     await controller!.toggleFlash();
                    //   }
                    // } catch (e) {
                    //   if (context.mounted) {
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //         Constants.errorSnackBar(context,
                    //             "Это устройство не поддерживает фонарик"));
                    //   }
                    // }
                  })),
        ),
        body: Padding(
          padding: EdgeInsets.only(
              left: Constants.defaultPadding,
              right: Constants.defaultPadding,
              bottom: Constants.defaultPadding * 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: Constants.defaultPadding),
                child: Text(
                  "Оплата QR-кодом",
                  style: Constants.headlineTextTheme.displayLarge!
                      .copyWith(color: Constants.primaryColor),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: Constants.defaultPadding * 2),
                child: Text(
                  "Наведите камерой на QR-код для дальнейшей оплаты заказа",
                  style: Constants.textTheme.bodyLarge,
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: onQRViewCreated,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      context
          .read<QRScannerBloc>()
          .add(QRScannerDataScanned(scanData.code ?? ""));
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
