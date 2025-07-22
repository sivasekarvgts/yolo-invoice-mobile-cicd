import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yoloworks_invoice/core/extension/color_extension.dart';
import '../styles/text_styles.dart';
import 'colors.dart';

sealed class LightTheme {
  static final ThemeData appTheme = ThemeData(
    primaryColor: AppColors.primary,
    primarySwatch: createMaterialColor(AppColors.primary),
    primaryColorDark: AppColors.primary,
    dividerColor: AppColors.greyColor,
    colorScheme: const ColorScheme.light(
        surface: AppColors.background, primary: AppColors.primary),
    fontFamily: AppTextStyle.fontFamily,
    scaffoldBackgroundColor: AppColors.background,
    useMaterial3: false,
    textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.black,
        selectionColor: AppColors.blueColor,
        selectionHandleColor: AppColors.blueColor),
    iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(iconColor: WidgetStateColor.transparent)),
    iconTheme: const IconThemeData(color: AppColors.darkBlackColor),
    dividerTheme: const DividerThemeData(
        thickness: 0.8, color: AppColors.dividerGreyColor),
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: false,
      color: AppColors.background,
      iconTheme: IconThemeData(color: AppColors.darkBlackColor, size: 20),
      titleTextStyle: AppTextStyle.darkBlackFS16FW500.copyWith( fontFamily: "Manrope"),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.white,
        elevation: 2.6,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(22)))),
  );

  static final List<BoxShadow> cardShadow = [
    BoxShadow(
        color: Colors.black.withOpacityValue(0.1),
        spreadRadius: 0,
        blurRadius: 12,
        offset: const Offset(0, 3))
  ];

  static const Widget customDivider =
      Divider(color: AppColors.dividerGreyColor, thickness: 1, height: 0);
  static const Widget customDividerStyle2 =
      Divider(color: AppColors.dividerGreyColor, thickness: 1, height: 0);
  static const Widget customVerticalDivider =
      VerticalDivider(color: AppColors.dividerGreyColor, thickness: 1, width: 0);
  static const Widget customLoading =
      Center(child: CupertinoActivityIndicator(color: AppColors.primary));
  static const Widget customLoading2 = Center(
      child: CupertinoActivityIndicator(
    color: AppColors.darkBlackColor,
    radius: 12,
  ));

  static Decoration cardDecoration = BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.circular(10));

  static final List<BoxShadow> mildCardShadow = [
    BoxShadow(
        color: Colors.black.withOpacityValue(0.1),
        spreadRadius: 0.5,
        blurRadius: 1)
  ];

  static List<Shadow> textShadow = <Shadow>[
    const Shadow(
        offset: Offset(2.0, 2.0), blurRadius: 3.0, color: Colors.black12),
    const Shadow(
        offset: Offset(2.0, 2.0), blurRadius: 8.0, color: Colors.black12)
  ];
}

class ColorSeed {}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
