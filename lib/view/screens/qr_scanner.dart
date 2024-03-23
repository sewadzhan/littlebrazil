import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/logic/cubits/torch/torch_cubit.dart';
import 'package:littlebrazil/view/components/custom_outlined_button.dart';
import 'package:littlebrazil/view/components/sliver_body.dart';
import 'package:littlebrazil/view/config/constants.dart';

class QRScannerScreen extends StatelessWidget {
  const QRScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverBody(
      title: "Оплата QR-кодом",
      backButtonType: BackButtonType.cross,
      bottomBar: BlocConsumer<TorchCubit, TorchState>(
        listener: (context, torchState) {
          if (torchState is TorchError) {
            ScaffoldMessenger.of(context).showSnackBar(Constants.errorSnackBar(
                context, torchState.message,
                duration: const Duration(milliseconds: 500)));
          }
        },
        builder: (context, torchState) {
          if (torchState is TorchActive) {
            return SafeArea(
              child: Container(
                  decoration: const BoxDecoration(
                      color: Constants.backgroundColor,
                      border: Border(
                          top: BorderSide(
                              color: Constants.lightGrayColor, width: 1))),
                  padding: EdgeInsets.all(Constants.defaultPadding),
                  child: CustomOutlinedButton(
                      text: torchState.isEnabled
                          ? "ВЫКЛЮЧИТЬ ФОНАРИК"
                          : "ВКЛЮЧИТЬ ФОНАРИК",
                      function: () {
                        context.read<TorchCubit>().toggleTorch();
                      })),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Constants.defaultPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: Constants.defaultPadding * 2),
                child: Text(
                  "Наведите камерой на QR-код для дальнейшей оплаты заказа",
                  style: Constants.textTheme.bodyLarge,
                ),
              )
            ],
          )),
    );
  }
}
