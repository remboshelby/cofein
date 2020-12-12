import 'package:cofein/app/app.dart';
import 'package:cofein/layers/ui/style.dart';
import 'package:cofein/layers/ui/colors.dart';
import 'package:flutter/material.dart';

const TextStyle titleStyle = cofeinTextStyle;

ThemeData themeConfig() {
  return ThemeData(
    brightness: Brightness.light,
    accentColor: CofeinColors.azure1,
    fontFamily: 'TT-Chocolates',
    textTheme: TextTheme(
      title: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.black54,
    ),
    // canvasColor: Colors.transparent,
  );
}
