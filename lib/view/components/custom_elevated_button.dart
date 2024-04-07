import 'package:flutter/material.dart';
import 'package:littlebrazil/view/config/constants.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton(
      {super.key,
      required this.text,
      required this.function,
      this.fullWidth = true,
      this.isEnabled = true,
      this.isLoading = false,
      this.withTengeSign = false});

  final String text;
  final bool isLoading;
  final bool withTengeSign;

  final Function function;
  final bool fullWidth;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? MediaQuery.of(context).size.width : null,
      height: 48,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 0,
              overlayColor: Constants.secondPrimaryColor,
              backgroundColor: Constants.secondPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              disabledBackgroundColor:
                  Constants.secondPrimaryColor.withAlpha(65)),
          onPressed: isEnabled
              ? () {
                  function();
                }
              : null,
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : RichText(
                  text: TextSpan(
                      text: "${text.toUpperCase()} ",
                      style: Constants.headlineTextTheme.displaySmall!.copyWith(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(
                            text: withTengeSign ? "₸" : "",
                            style: Constants.tengeStyle.copyWith(
                              color: Colors.white,
                              fontSize:
                                  Constants.textTheme.headlineMedium!.fontSize,
                              fontWeight: FontWeight.w600,
                            )),
                      ]),
                )),
    );
  }
}
