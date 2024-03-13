import 'package:flutter/material.dart';
import 'package:littlebrazil/view/config/constants.dart';

class CustomTheme {
  static TextTheme headlineTextTheme = const TextTheme(
    displayLarge: TextStyle(
        color: Constants.darkGrayColor,
        fontWeight: FontWeight.bold,
        fontSize: 36,
        fontFamily: 'Opinion'),
    displayMedium: TextStyle(
        color: Constants.darkGrayColor,
        fontWeight: FontWeight.bold,
        fontSize: 32,
        fontFamily: 'Opinion'),
    displaySmall: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.bold,
      fontSize: 18,
      fontFamily: 'Opinion',
    ),
    headlineMedium: TextStyle(
        color: Constants.darkGrayColor,
        fontWeight: FontWeight.bold,
        fontSize: 16,
        fontFamily: 'Opinion'),
    headlineSmall: TextStyle(
        color: Constants.darkGrayColor,
        fontWeight: FontWeight.bold,
        fontSize: 14,
        fontFamily: 'Opinion'),
    titleLarge: TextStyle(
        color: Constants.darkGrayColor,
        fontWeight: FontWeight.bold,
        fontSize: 12,
        fontFamily: 'Opinion'),
    bodyLarge: TextStyle(
        color: Constants.darkGrayColor,
        fontWeight: FontWeight.bold,
        fontSize: 14,
        fontFamily: 'Opinion'),
    bodyMedium: TextStyle(
        color: Constants.darkGrayColor,
        fontWeight: FontWeight.bold,
        fontSize: 12,
        fontFamily: 'Opinion'),
  );

  static TextTheme textTheme = const TextTheme(
    displayLarge: TextStyle(
        color: Constants.darkGrayColor,
        fontWeight: FontWeight.w500,
        fontSize: 36,
        letterSpacing: 0,
        fontFamily: 'Gotham'),
    displayMedium: TextStyle(
        color: Constants.darkGrayColor,
        fontWeight: FontWeight.w500,
        fontSize: 22,
        letterSpacing: 0,
        fontFamily: 'Gotham'),
    displaySmall: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.w500,
      fontSize: 18,
      letterSpacing: 0,
      fontFamily: 'Gotham',
    ),
    headlineMedium: TextStyle(
        color: Constants.darkGrayColor,
        fontWeight: FontWeight.w500,
        fontSize: 16,
        letterSpacing: 0,
        fontFamily: 'Gotham'),
    headlineSmall: TextStyle(
        color: Constants.darkGrayColor,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        letterSpacing: 0,
        fontFamily: 'Gotham'),
    titleLarge: TextStyle(
        color: Constants.darkGrayColor,
        fontWeight: FontWeight.w500,
        fontSize: 12,
        letterSpacing: 0,
        fontFamily: 'Gotham'),
    bodyLarge: TextStyle(
        color: Constants.darkGrayColor,
        fontWeight: FontWeight.normal,
        fontSize: 14,
        letterSpacing: 0,
        fontFamily: 'Gotham'),
    bodyMedium: TextStyle(
        color: Constants.darkGrayColor,
        fontWeight: FontWeight.normal,
        fontSize: 12,
        letterSpacing: 0,
        fontFamily: 'Gotham'),
    bodySmall: TextStyle(
        color: Constants.darkGrayColor,
        fontWeight: FontWeight.normal,
        fontSize: 11,
        letterSpacing: 0,
        fontFamily: 'Gotham'),
  );

  static ThemeData get theme => ThemeData(
      scaffoldBackgroundColor: Constants.backgroundColor,
      primaryColor: Constants.primaryColor,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Constants.primaryColor,
        secondary: Constants.secondPrimaryColor,
      ),
      fontFamily: 'Gotham');
}
