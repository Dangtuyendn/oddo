import 'package:flutter/material.dart';

class Styles {
  /// ****** AppBar ****** ///
  static const appBarHeight = 55.0;

  /// ****** Colors ****** ///
  static const backGroundColor = Color.fromARGB(255, 237, 247, 247);
  static const primaryColor = Color.fromARGB(255, 0, 186, 216);
  static const transparentColor = Color.fromARGB(0, 255, 255, 255);
  static const hintTextColor = Color.fromARGB(255, 155, 155, 155);
  static const lightTextColor = Color.fromARGB(255, 245, 245, 245);
  static const darkTextColor = Color.fromARGB(255, 119, 119, 119);
  static const underlineInputBorderColor = Color.fromARGB(255, 211, 211, 211);
  static const infoColor = Color.fromARGB(255, 35, 187, 113);
  static const errorColor = Color.fromARGB(255, 255, 80, 80);
  static const warningColor = Color.fromARGB(255, 255, 171, 64);
  static const gradient = LinearGradient(
      colors: [
        Color.fromARGB(255, 0, 36, 36),
        Color.fromARGB(255, 0, 186, 216)
      ],
      begin: FractionalOffset(0.0, 1.0),
      end: FractionalOffset(0.0, 0.0),
      stops: [0.0, 1.0],
      tileMode: TileMode.clamp);

  /// ****** Fonts ****** ///
  static const f8 = 8.0;
  static const f9 = 9.0;
  static const f10 = 10.0;
  static const f11 = 11.0;
  static const f12 = 12.0;
  static const f14 = 14.0;
  static const f16 = 16.0;
  static const f18 = 18.0;
  static const f20 = 20.0;
  static const f22 = 22.0;
  static const f24 = 24.0;
  static const f26 = 26.0;
  static const f28 = 28.0;
  static const f36 = 36.0;
  static const f48 = 48.0;
  static const f72 = 72.0;
  static const lightFontWeight = FontWeight.w300;
  static const mediumFontWeight = FontWeight.w600;

  static const h1 = 34.0;
  static const h2 = 28.0;
  static const h3 = 18.0;
  static const h4 = 16.0;
  static const h5 = 14.0;
  static const h6 = 12.0;

  /// ****** Margin-Padding ****** ///
  static const double small = 4;
  static const double medium = 8;
  static const double normal = 12;
  static const double large = 16;
  static const double xlarge = 24;
  static const double xxlarge = 32;

  /// *** Style Notification ***///
  static const titleStyleNotification =
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
  static const textStyleNotification =
      TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.w600);
  static const textSubStyleNotification =
      TextStyle(color: Colors.black, fontWeight: FontWeight.w600);
}
