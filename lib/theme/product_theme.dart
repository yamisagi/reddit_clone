import 'package:flutter/material.dart';

class ColorPallete {
  static const blackColor = Color.fromRGBO(1, 1, 1, 1); // Pure Black
  static const greyColor = Color.fromRGBO(26, 39, 45, 1);
  static const drawerColor = Color.fromRGBO(18, 18, 18, 1);
  static const whiteColor = Colors.white;
  static var redColor = Colors.red.shade500;
  static var blueColor = Colors.blue.shade300;

  static var darkModeAppTheme = ThemeData.dark(useMaterial3: true) //
      .copyWith(
          scaffoldBackgroundColor: blackColor,
          cardColor: greyColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: drawerColor,
            iconTheme: IconThemeData(
              color: whiteColor,
            ),
          ),
          drawerTheme: const DrawerThemeData(
            backgroundColor: drawerColor,
          ),
          primaryColor: redColor,
          backgroundColor: drawerColor,
          cardTheme: const CardTheme(elevation: 4));

  static var lightModeAppTheme = ThemeData.light(useMaterial3: true) //
      .copyWith(
          scaffoldBackgroundColor: whiteColor,
          cardColor: greyColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: whiteColor,
            elevation: 0,
            iconTheme: IconThemeData(
              color: blackColor,
            ),
          ),
          drawerTheme: const DrawerThemeData(
            backgroundColor: whiteColor,
          ),
          primaryColor: redColor,
          backgroundColor: whiteColor,
          cardTheme: const CardTheme(elevation: 4));
}
