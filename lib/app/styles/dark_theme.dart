import 'package:flutter/material.dart';
import 'package:yoloworks_invoice/core/extension/color_extension.dart';
import '../styles/text_styles.dart';
import 'colors.dart';

sealed class DarkTheme {
  static final ThemeData appTheme = ThemeData(
    primaryColor: AppColors.primary,
    primarySwatch: createMaterialColor(AppColors.primary),
    primaryColorDark: AppColors.primary,
    dividerColor: AppColors.dividerGreyColor,
    colorScheme: const ColorScheme.light(surface: AppColors.background),
    fontFamily: AppTextStyle.fontFamily,
    scaffoldBackgroundColor: AppColors.background,
    useMaterial3: false,
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
  );

  static final List<BoxShadow> cardShadow = [
    BoxShadow(
        color: Colors.black.withOpacityValue(0.1),
        spreadRadius: 0,
        blurRadius: 12,
        offset: const Offset(0, 3))
  ];

  static const Widget customDivider = SizedBox(
      height: 1, child: Divider(color: Color(0xffEFEFEF), thickness: 1));

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
