import 'package:flutter/material.dart';
import 'package:reddit_clone/theme/product_theme.dart';

class Constants {
  static const String logoPath = 'assets/images/logo.png';
  static const String backgroundPath = 'assets/images/background.png';
  static const String splashPath = 'assets/images/splashscreen.png';

  // ----------------RADIUS&&STYLE----------------

  static final OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: ColorPallete.redColor,
      width: 2.0,
    ),
    borderRadius: BorderRadius.circular(30.0),
  );

  static final cardRadius = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30.0),
  );

  // ----------------PADDING && MARGIN----------------

  static const textFieldPadding = EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0);
}
