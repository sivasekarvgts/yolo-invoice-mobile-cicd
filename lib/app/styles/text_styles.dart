import 'package:flutter/material.dart';

import '../styles/colors.dart';
import '../styles/font_size.dart';

//TODOS
//variables names must be camelcase
//FontWeight
const fontWeight400 = FontWeight.w400;
const fontWeight500 = FontWeight.w500;
const fontWeight600 = FontWeight.w600;
const fontWeight700 = FontWeight.w700;

class AppTextStyle {
  static String fontFamily = "Manrope";

  static TextStyle displayLarge = TextStyle(
    fontSize: 64,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: fontWeight500,
    height: 1.125,
    letterSpacing: 0,
  );

  static TextStyle displayMedium = TextStyle(
    fontSize: 56,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: fontWeight500,
    height: 1.14,
  );

  static TextStyle displaySmall = TextStyle(
    fontSize: 40,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: fontWeight500,
    height: 1.20,
    letterSpacing: 0,
  );

  static TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: fontWeight500,
    height: 1.25,
    letterSpacing: 0,
  );

  static TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: fontWeight500,
    height: 1.13,
    letterSpacing: 0,
  );

  static TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: fontWeight500,
    height: 1.33,
    letterSpacing: 0,
  );

  static TextStyle titleLarge = TextStyle(
    fontSize: 20,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: fontWeight500,
    height: 1.30,
    letterSpacing: 0,
  );

  static TextStyle titleMedium = TextStyle(
    fontSize: AppFontSize.dp16,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: fontWeight500,
    height: 1.50,
    letterSpacing: 0.15,
  );

  static TextStyle titleSmall = TextStyle(
    fontSize: AppFontSize.dp14,
    decoration: TextDecoration.none,
    fontWeight: fontWeight500,
    height: 1.43,
    letterSpacing: 0.10,
  );

  static TextStyle labelMedium = TextStyle(
    fontSize: AppFontSize.dp14,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    color: AppColors.greyColor,
    fontWeight: fontWeight400,
    height: 1.43,
    letterSpacing: 0.10,
  );

  static TextStyle labelSmall = TextStyle(
    fontSize: AppFontSize.dp12,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: fontWeight400,
    height: 1.33,
    letterSpacing: 0.50,
  );

  static TextStyle labelExtraSmall = TextStyle(
    fontSize: AppFontSize.dp10,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: fontWeight600,
    height: 1.33,
    letterSpacing: 0.50,
  );

  static TextStyle button = TextStyle(
    fontSize: AppFontSize.dp14,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: fontWeight500,
    height: 1.43,
    letterSpacing: 0.25,
    color: AppColors.blueColor,
  );

  static TextStyle buttonExtraLarge = TextStyle(
    fontSize: AppFontSize.dp16,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: fontWeight500,
    height: 1.50,
    letterSpacing: 0.25,
  );

  static TextStyle bodyExtraLarge = TextStyle(
    fontSize: AppFontSize.dp18,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: fontWeight400,
    height: 1.44,
    letterSpacing: 0.50,
  );

  static TextStyle bodyLarge = TextStyle(
    fontSize: AppFontSize.dp16,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: fontWeight400,
    height: 1.50,
    letterSpacing: 0.50,
  );

  static TextStyle bodyMedium = TextStyle(
    fontSize: AppFontSize.dp14,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: fontWeight400,
    height: 1.43,
    letterSpacing: 0.25,
  );

  static TextStyle bodySmall = TextStyle(
    fontSize: AppFontSize.dp12,
    fontWeight: fontWeight600,
    height: 1.50,
    letterSpacing: 0.50,
  );

  static TextStyle darkBlackFS10FW500 = TextStyle(
      color: AppColors.darkBlackColor,
      fontSize: AppFontSize.dp10,
      fontWeight: fontWeight500,
      height: 1.4);

  static TextStyle darkBlackFS10FW600 = TextStyle(
      color: AppColors.darkBlackColor,
      fontSize: AppFontSize.dp10,
      fontWeight: fontWeight600,
      height: 1.4);

  static TextStyle darkBlackFS10FW700 = TextStyle(
      color: AppColors.darkBlackColor,
      fontSize: AppFontSize.dp10,
      fontWeight: fontWeight700,
      height: 1.4);

  static TextStyle darkBlackFS11FW400 = TextStyle(
    color: AppColors.darkBlackColor,
    fontSize: AppFontSize.dp11,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: fontWeight400,
  );

  static TextStyle darkBlackFS11FW500 = TextStyle(
    color: AppColors.darkBlackColor,
    fontSize: AppFontSize.dp11,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: fontWeight500,
  );

  static TextStyle darkBlackFS12FW400 = TextStyle(
    fontSize: AppFontSize.dp12,
    color: AppColors.darkBlackColor,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: fontWeight400,
  );

  static TextStyle darkBlackFS12FW500 = TextStyle(
    color: AppColors.darkBlackColor,
    fontSize: AppFontSize.dp12,
    fontWeight: fontWeight500,
    height: 1.32,
  );

  static TextStyle darkBlackFS12FW600 = TextStyle(
    color: AppColors.darkBlackColor,
    fontSize: AppFontSize.dp12,
    fontWeight: fontWeight600,
    height: 1.32,
  );

  static TextStyle darkBlackFS12H16FW500 = TextStyle(
    color: AppColors.darkBlackColor,
    fontSize: AppFontSize.dp12,
    fontWeight: fontWeight500,
    letterSpacing: 0.5,
    height: 16 / 12,
  );

  static TextStyle darkBlackFS13FW500 = TextStyle(
    color: AppColors.darkBlackColor,
    fontSize: AppFontSize.dp13,
    fontWeight: fontWeight500,
    height: 1.32,
  );

  static TextStyle darkBlackFS14FW400 = TextStyle(
    color: AppColors.darkBlackColor,
    fontSize: AppFontSize.dp14,
    fontWeight: fontWeight400,
    height: 1.42,
  );

  static TextStyle darkBlackFS14FW500 = TextStyle(
    color: AppColors.darkBlackColor,
    fontSize: AppFontSize.dp14,
    fontWeight: fontWeight500,
    height: 1.42,
  );

  static TextStyle darkBlackFS14FW600 = TextStyle(
    color: AppColors.darkBlackColor,
    fontSize: AppFontSize.dp14,
    fontWeight: fontWeight600,
    height: 1.42,
  );

  static TextStyle darkBlackFS16FW700 = TextStyle(
    color: AppColors.darkBlackColor,
    fontSize: AppFontSize.dp16,
    fontWeight: fontWeight700,
    height: 1.5,
  );

  static TextStyle darkBlackFS16FW600 = TextStyle(
    color: AppColors.darkBlackColor,
    fontSize: AppFontSize.dp16,
    fontWeight: fontWeight600,
    height: 1.5,
  );

  static TextStyle darkBlackFS15FW600 = TextStyle(
    color: AppColors.darkBlackColor,
    fontSize: AppFontSize.dp15,
    fontWeight: fontWeight600,
    height: 1.5,
  );

  static TextStyle darkBlackFS16FW500 = TextStyle(
    color: AppColors.darkBlackColor,
    fontSize: AppFontSize.dp16,
    fontWeight: fontWeight500,
    height: 1.5,
  );

  static TextStyle blackFS16FW500 = TextStyle(
    color: Colors.black,
    fontSize: AppFontSize.dp16,
    fontWeight: fontWeight500,
    height: 1.5,
  );

  static TextStyle blackFS14FW500 = TextStyle(
    color: Colors.black,
    fontSize: AppFontSize.dp14,
    fontWeight: fontWeight500,
    height: 1.42,
  );

  static TextStyle blackFS14FW600 = TextStyle(
    color: Colors.black,
    fontSize: AppFontSize.dp14,
    fontWeight: fontWeight600,
    height: 1.42,
  );

  static TextStyle blackFS16FW600 = TextStyle(
    color: Colors.black,
    fontSize: AppFontSize.dp16,
    fontWeight: fontWeight600,
    height: 1.3,
  );

  static TextStyle blackFS20FW600 = TextStyle(
    color: Colors.black,
    fontSize: AppFontSize.dp20,
    fontWeight: fontWeight600,
    height: 1.5,
  );

  static TextStyle greyFS10FW600 = TextStyle(
    color: AppColors.greyColor,
    fontSize: AppFontSize.dp10,
    fontWeight: fontWeight600,
    height: 1.4,
  );

  static TextStyle greyFS10FW500 = TextStyle(
    color: AppColors.greyColor,
    fontSize: AppFontSize.dp10,
    fontWeight: fontWeight500,
    height: 1.4,
  );

  static TextStyle greyFS12FW500 = TextStyle(
    color: AppColors.greyColor,
    fontSize: AppFontSize.dp12,
    fontWeight: fontWeight500,
    height: 1.33,
  );

  static TextStyle greyFS12FW600 = TextStyle(
    color: AppColors.greyColor,
    fontSize: AppFontSize.dp12,
    fontWeight: fontWeight600,
    height: 1.5,
  );

  static TextStyle greyFS14FW500 = TextStyle(
    color: AppColors.greyColor,
    fontSize: AppFontSize.dp14,
    fontWeight: fontWeight500,
    height: 1.33,
  );

  static TextStyle greyFS14FW600 = TextStyle(
    color: AppColors.greyColor,
    fontSize: AppFontSize.dp14,
    fontWeight: fontWeight600,
    height: 1.42,
  );

  static TextStyle greyFS16FW500 = TextStyle(
    color: AppColors.greyColor,
    fontSize: AppFontSize.dp16,
    fontWeight: fontWeight600,
    height: 1.5,
  );

  static TextStyle fuscousGreyFS14FW400 = TextStyle(
    color: AppColors.fuscousGreyColor,
    fontSize: AppFontSize.dp14,
    fontWeight: fontWeight400,
    height: 4.28,
  );

  static TextStyle fuscousGreyFS14FW500 = TextStyle(
    color: AppColors.fuscousGreyColor,
    fontSize: AppFontSize.dp14,
    fontWeight: fontWeight400,
    height: 1.42,
  );

  static TextStyle vampireGreyFS11FW600 = TextStyle(
      fontSize: AppFontSize.dp11,
      height: 14 / 11,
      fontWeight: FontWeight.w600,
      color: AppColors.vampireGreyColor);

  static TextStyle vampireGreyFS12FW600 = TextStyle(
      fontSize: AppFontSize.dp12,
      height: 14 / 12,
      fontWeight: FontWeight.w600,
      color: AppColors.vampireGreyColor);

  static TextStyle blueFS10FW700 = TextStyle(
    height: 1.42,
    fontSize: AppFontSize.dp10,
    fontWeight: fontWeight700,
    color: AppColors.blueColor,
  );

  static TextStyle blueFS11FW600 = TextStyle(
    height: 1.42,
    fontSize: AppFontSize.dp11,
    fontWeight: fontWeight600,
    color: AppColors.blueColor,
  );

  static TextStyle blueFS12FW500 = TextStyle(
    height: 1.42,
    fontSize: AppFontSize.dp12,
    fontWeight: fontWeight500,
    color: AppColors.blueColor,
  );

  static TextStyle blueFS13FW400 = TextStyle(
    height: 1.42,
    fontSize: AppFontSize.dp13,
    fontWeight: fontWeight400,
    color: AppColors.blueColor,
  );

  static TextStyle blueFS14FW500 = TextStyle(
    height: 1.42,
    fontSize: AppFontSize.dp14,
    fontWeight: fontWeight500,
    color: AppColors.blueColor,
  );

  static TextStyle lincolnGreenF10W600 = TextStyle(
    fontSize: AppFontSize.dp10,
    fontWeight: fontWeight600,
    height: 14 / 10,
    color: AppColors.lincolnGreenColor,
  );

  // TODO
  static TextStyle darkGrassGreenF11W600 = TextStyle(
      fontSize: AppFontSize.dp10,
      fontWeight: FontWeight.w600,
      height: 14 / 11,
      color: AppColors.greenColor);

  static TextStyle darkGrassGreenF12W600 = TextStyle(
      fontSize: AppFontSize.dp12,
      fontWeight: FontWeight.w600,
      height: 14 / 12,
      color: AppColors.greenColor);

  static TextStyle whiteFS13FW500 = TextStyle(
    color: AppColors.white,
    fontSize: AppFontSize.dp13,
    fontWeight: fontWeight500,
    height: 1.33,
  );

  static TextStyle whiteFS14FW500 = TextStyle(
    color: AppColors.white,
    fontSize: AppFontSize.dp14,
    fontWeight: fontWeight500,
    height: 1.33,
  );

  static TextStyle redFS10FW400 = TextStyle(
    height: 1.42,
    fontSize: AppFontSize.dp10,
    fontWeight: fontWeight400,
    color: AppColors.redColor,
  );

  static TextStyle redFS12FW400 = TextStyle(
    height: 1.42,
    fontSize: AppFontSize.dp12,
    fontWeight: fontWeight400,
    color: AppColors.redColor,
  );

  static TextStyle redFS12FW500 = TextStyle(
    height: 1.42,
    fontSize: AppFontSize.dp12,
    fontWeight: fontWeight500,
    color: AppColors.redColor,
  );
}
