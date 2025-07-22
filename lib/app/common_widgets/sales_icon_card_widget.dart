import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_ui_constants.dart';

class SalesIconCardWidget extends StatelessWidget {
  const SalesIconCardWidget(
      {super.key,
      required this.color2,
      required this.icon,
      required this.color1,
      this.size,
      this.padding,
      this.radius = 4});

  final Color color2;
  final String icon;
  final Color color1;
  final double? size;
  final EdgeInsets? padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: padding ?? EdgeInsets.all(10.h),
      decoration: AppUiConstants.visitedCardDecoration(color2, radius.r),
      child: SvgPicture.asset(icon, width: 20, height: 20, color: color1),
    );
  }
}
