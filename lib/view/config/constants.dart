import 'package:flutter/material.dart';
import 'package:littlebrazil/view/config/theme.dart';

class Constants {
  static const Color backgroundColor = Colors.white;
  static const Color secondBackgroundColor = Color(0xFFF5F5F5);

  static const Color primaryColor = Color(0xFF0F5729);
  static const Color secondPrimaryColor = Color(0xFFE16E33);
  static const Color thirdPrimaryColor = Color(0xFFBFD730);
  static const Color blackColor = Color.fromARGB(255, 20, 20, 20);
  static const Color darkGrayColor = Color(0xFF464646);
  static const Color lightGrayColor = Color(0xFFEAEAEA);

  static const Color textInputColor = Color(0xFFD8D8D8);
  static const Color lightGreenColor = Color(0xFFDAEE8C);
  static const Color purpleColor = Color(0xFF961163);

  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFF44336);

  static double defaultPadding = 16.0;

  static TextTheme headlineTextTheme = CustomTheme.headlineTextTheme;
  static TextTheme textTheme = CustomTheme.textTheme;

  static SnackBar errorSnackBar(BuildContext context, String text,
      {duration = const Duration(milliseconds: 500)}) {
    return SnackBar(
      behavior: SnackBarBehavior.fixed,
      backgroundColor: Constants.errorColor,
      duration: duration,
      content: Text(
        text,
        style: Constants.textTheme.headlineSmall!.copyWith(color: Colors.white),
      ),
    );
  }

  static SnackBar successSnackBar(BuildContext context, String text,
      {duration = const Duration(milliseconds: 300)}) {
    return SnackBar(
      behavior: SnackBarBehavior.fixed,
      backgroundColor: Constants.successColor,
      duration: duration,
      content: Text(
        text,
        style: Constants.textTheme.headlineSmall!.copyWith(color: Colors.white),
      ),
    );
  }
}
