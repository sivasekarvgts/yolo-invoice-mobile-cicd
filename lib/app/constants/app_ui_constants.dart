import 'package:flutter/material.dart';

import '../styles/colors.dart';

sealed class AppUiConstants {
  static BorderRadius borderRadius8 = BorderRadius.circular(8);
  static BorderRadius borderRadius10 = BorderRadius.circular(10);
  static BorderRadius borderRadius12 = BorderRadius.circular(12);
  static BorderRadius borderRadius16 = BorderRadius.circular(16);
  static BorderRadius borderRadius25 = BorderRadius.circular(25);

  static BoxBorder boxBorder = Border.all(color: AppColors.dividerGreyColor);

  static BoxDecoration salesCardItemDecoration = BoxDecoration(
      borderRadius: borderRadius8,
      color: AppColors.white,
      boxShadow: [
        BoxShadow(
          color: AppColors.dividerGreyColor, // Shadow color
          spreadRadius: .2, // How much the shadow spreads
          blurRadius: .5, // How soft the shadow is
          offset: Offset(0, .1), // Horizontal and vertical offset
        ),
      ]);

  static BoxDecoration errorCardDecoration = BoxDecoration(
    color: AppColors.mediumBrownColor,
    borderRadius: BorderRadius.circular(12),
  );

  static BoxDecoration salesCardDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: boxBorder);

  static BoxDecoration visitedCardDecoration(Color color,
          [double radius = 4]) =>
      BoxDecoration(color: color, borderRadius: BorderRadius.circular(radius));

  static BoxDecoration checkBoxDecoration([Color color = Colors.white]) =>
      BoxDecoration(
          color: color,
          border: Border.all(color: AppColors.darkBlackColor, width: 1.5),
          borderRadius: BorderRadius.circular(4));

  static BoxDecoration cardDecoration = BoxDecoration(
      color: Colors.white,
      border: boxBorder,
      borderRadius: BorderRadius.circular(10));

  static BoxDecoration badgeCardDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: boxBorder);

  static BoxDecoration filterCardDecoration = BoxDecoration(
      border: Border.all(color: AppColors.charcoalBlackColor),
      color: Colors.white,
      borderRadius: borderRadius8);

  static BoxDecoration filterSelectCardDecoration = BoxDecoration(
      color: AppColors.aquaBlueColor,
      border: Border.all(color: AppColors.blueColor),
      borderRadius: borderRadius8);
}
