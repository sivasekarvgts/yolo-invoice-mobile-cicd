import 'package:flutter/material.dart';
import 'package:yoloworks_invoice/core/enums/icon_type.dart';

import '../../app/styles/colors.dart';

extension ColorExtension on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }

  Color withOpacityValue(double opacity) {
    return withAlpha((opacity * 255).toInt());
  }
}

extension ColorCodeExtension on String? {
  Color toGetColor() {
    final color = this;
    if (color == null) return AppColors.peachOrangeColor;
    return Color(int.parse(color.replaceFirst('#', '0xFF')));
  }
}

extension IconColorExtension on IconType? {
  Color get color1 => switch (this) {
        IconType.customer => AppColors.purpleJamColor,
        IconType.sales => AppColors.rustRedColor,
        IconType.invoice => AppColors.greenColor,
        IconType.payIn => AppColors.waterBlueColor,
        IconType.payOut => AppColors.graphYellow,
        IconType.bill => AppColors.pinkColor,
    IconType.item => AppColors.darkBrownColor,
        _ => AppColors.greyColor,
      };

  Color get color2 => switch (this) {
        IconType.customer => AppColors.purpleDawnColor,
        IconType.sales => AppColors.palePinkColor,
        IconType.invoice => AppColors.berlyGreenColor,
        IconType.payIn => AppColors.paleSkyBlueColor,
        IconType.payOut => AppColors.shadowYellowColor,
        IconType.bill => AppColors.shadowPinkColor,
    IconType.item => AppColors.softBrownColor,
        _ => AppColors.greyColor100,
      };
}
