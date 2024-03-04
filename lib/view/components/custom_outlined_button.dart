import 'package:flutter/material.dart';
import 'package:littlebrazil/view/config/constants.dart';

class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton(
      {Key? key,
      required this.text,
      required this.function,
      this.fullWidth = true,
      this.isEnabled = true,
      this.isLoading = false})
      : super(key: key);

  final String text;
  final bool isLoading;

  final Function function;
  final bool fullWidth;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? MediaQuery.of(context).size.width : null,
      height: 48,
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              backgroundColor: Constants.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              side: const BorderSide(
                  width: 1, color: Constants.secondPrimaryColor)),
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
                    color: Constants.primaryColor,
                  ),
                )
              : Text(
                  text,
                  style: Constants.headlineTextTheme.displaySmall!.copyWith(
                      color: Constants.secondPrimaryColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                )),
    );
  }
}
