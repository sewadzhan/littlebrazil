import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:littlebrazil/logic/blocs/qr_scanner/qr_scanner_bloc.dart';
import 'package:littlebrazil/view/components/custom_outlined_button.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isTorchEnabled = false;

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
    final appLocalization = AppLocalizations.of(context)!;
    return BlocListener<QRScannerBloc, QRScannerState>(
      listener: (context, state) async {
        if (state is QRScannerError) {
          ScaffoldMessenger.of(context).showSnackBar(Constants.errorSnackBar(
              context, appLocalization.unexpectedError));
        } else if (state is QRScannerSuccessScan) {
          await Navigator.pushNamed(context, '/successQRscanned',
              arguments: state.order);
          if (controller != null) {
            controller!.resumeCamera();
          }
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
              child: SvgPicture.asset(
                'assets/icons/cross.svg',
              ),
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
                  text: isTorchEnabled
                      ? appLocalization.turnOffTheFlashlight
                      : appLocalization.turnOnTheFlashlight,
                  function: () async {
                    try {
                      if (controller != null) {
                        await controller!.toggleFlash();
                        setState(() {
                          isTorchEnabled = !isTorchEnabled;
                        });
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            Constants.errorSnackBar(context,
                                appLocalization.flashlightNotSupported));
                      }
                    }
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
                  appLocalization.qrCodePayment,
                  style: Constants.headlineTextTheme.displayLarge!
                      .copyWith(color: Constants.primaryColor),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: Constants.defaultPadding * 2),
                child: Text(
                  appLocalization
                      .pointYourCameraAtTheQrCodeToContinuePayingForTheOrder,
                  style: Constants.textTheme.bodyLarge,
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: Constants.secondBackgroundColor,
                    child: QRView(
                      key: qrKey,
                      onQRViewCreated: onQRViewCreated,
                      formatsAllowed: const [BarcodeFormat.qrcode],
                    ),
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
      controller.pauseCamera();
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
