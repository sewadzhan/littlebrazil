import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:littlebrazil/view/components/custom_elevated_button.dart';
import 'package:littlebrazil/view/components/custom_outlined_button.dart';
import 'package:littlebrazil/view/config/theme.dart';

class Constants {
  static const Color backgroundColor = Colors.white;
  static const Color secondBackgroundColor = Color(0xFFF5F5F5);

  static const Color primaryColor = Color(0xFF0F5729);
  static const Color secondPrimaryColor = Color(0xFFE16E33);
  static const Color thirdPrimaryColor = Color(0xFFBFD730);
  static const Color blackColor = Color.fromARGB(255, 20, 20, 20);
  static const Color darkGrayColor = Color(0xFF464646);
  static const Color middleGrayColor = Color(0xFFB9B9B9);
  static const Color lightGrayColor = Color(0xFFEAEAEA);

  static const Color textInputColor = Color(0xFFD8D8D8);
  static const Color lightGreenColor = Color(0xFFDAEE8C);
  static const Color purpleColor = Color(0xFF961163);
  static const Color lightPurpleColor = Color(0xFFE0BBE7);

  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFF44336);

  static double defaultPadding = 16.0;

  static TextTheme headlineTextTheme = CustomTheme.headlineTextTheme;
  static TextTheme textTheme = CustomTheme.textTheme;

  static SnackBar errorSnackBar(BuildContext context, String text,
      {duration = const Duration(milliseconds: 500),
      behavior = SnackBarBehavior.fixed}) {
    return SnackBar(
      behavior: behavior,
      backgroundColor: Constants.errorColor,
      duration: duration,
      content: Text(
        text,
        style: Constants.textTheme.headlineSmall!.copyWith(color: Colors.white),
      ),
    );
  }

  static SnackBar successSnackBar(BuildContext context, String text,
      {duration = const Duration(milliseconds: 300),
      behavior = SnackBarBehavior.fixed}) {
    return SnackBar(
      behavior: behavior,
      backgroundColor: Constants.successColor,
      duration: duration,
      content: Text(
        text,
        style: Constants.textTheme.headlineSmall!.copyWith(color: Colors.white),
      ),
    );
  }

  static void showBottomSheetAlert(
      {required BuildContext context,
      required String title,
      required String submit,
      String cancel = "ОТМЕНА",
      required Function function}) {
    showModalBottomSheet(
        backgroundColor: Constants.backgroundColor,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        context: context,
        builder: (context) => Container(
            height: 160,
            padding: EdgeInsets.only(
                left: Constants.defaultPadding,
                right: Constants.defaultPadding,
                bottom: Constants.defaultPadding,
                top: Constants.defaultPadding * 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: Constants.defaultPadding),
                  child: Text(
                    title,
                    style: Constants.textTheme.headlineSmall,
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 125,
                        margin: EdgeInsets.only(
                            right: Constants.defaultPadding * 0.5),
                        child: CustomOutlinedButton(
                            text: cancel,
                            function: () {
                              Navigator.pop(context);
                            }),
                      ),
                      Expanded(
                          child: CustomElevatedButton(
                              text: submit, function: function)),
                    ])
              ],
            )));
  }

  static SnackBar noWifiSnackBar(BuildContext context) {
    return SnackBar(
      dismissDirection: DismissDirection.none,
      backgroundColor: Constants.errorColor,
      duration: const Duration(days: 7),
      content: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: Constants.defaultPadding * 0.3),
        child: Row(
          children: [
            SizedBox(
              width: 21,
              height: 21,
              child: SvgPicture.asset('assets/icons/no-wifi.svg',
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
            ),
            const SizedBox(width: 10),
            Text(
              "Нет подключения к интернету",
              style: Constants.textTheme.headlineSmall!
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
