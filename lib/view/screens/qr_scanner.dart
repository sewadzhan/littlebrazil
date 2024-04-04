import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/view/components/custom_outlined_button.dart';
import 'package:littlebrazil/view/components/sliver_body.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
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
    return Scaffold();
    // return SliverBody(
    //   title: "Оплата QR-кодом",
    //   backButtonType: BackButtonType.cross,
    //   bottomBar: BlocConsumer<TorchCubit, TorchState>(
    //     listener: (context, torchState) {
    //       if (torchState is TorchError) {
    //         ScaffoldMessenger.of(context).showSnackBar(Constants.errorSnackBar(
    //             context, torchState.message,
    //             duration: const Duration(milliseconds: 500)));
    //       }
    //     },
    //     builder: (context, torchState) {
    //       if (torchState is TorchActive) {
    //         return SafeArea(
    //           child: Container(
    //               decoration: const BoxDecoration(
    //                   color: Constants.backgroundColor,
    //                   border: Border(
    //                       top: BorderSide(
    //                           color: Constants.lightGrayColor, width: 1))),
    //               padding: EdgeInsets.all(Constants.defaultPadding),
    //               child: CustomOutlinedButton(
    //                   text: torchState.isEnabled
    //                       ? "ВЫКЛЮЧИТЬ ФОНАРИК"
    //                       : "ВКЛЮЧИТЬ ФОНАРИК",
    //                   function: () {
    //                     context.read<TorchCubit>().toggleTorch();
    //                   })),
    //         );
    //       }
    //       return const SizedBox.shrink();
    //     },
    //   ),
    //   child: Padding(
    //       padding: EdgeInsets.symmetric(
    //         horizontal: Constants.defaultPadding,
    //       ),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Padding(
    //             padding: EdgeInsets.only(bottom: Constants.defaultPadding * 2),
    //             child: Text(
    //               "Наведите камерой на QR-код для дальнейшей оплаты заказа",
    //               style: Constants.textTheme.bodyLarge,
    //             ),
    //           ),
    //           // SizedBox(
    //           //   width: MediaQuery.of(context).size.width,
    //           //   height: 750,
    //           //   child: Column(
    //           //     children: <Widget>[
    //           //       QRView(
    //           //         key: qrKey,
    //           //         onQRViewCreated: _onQRViewCreated,
    //           //       ),
    //           //     ],
    //           //   ),
    //           // ),
    //         ],
    //       )),
    // );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
