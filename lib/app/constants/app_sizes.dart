import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Constant sizes to be used in the app (paddings, gaps, rounded corners etc.)
class Sizes {
  static const p2 = 2.0;
  static const p3 = 3.0;
  static const p4 = 4.0;
  static const p5 = 5.0;
  static const p6 = 6.0;
  static const p7 = 7.0;
  static const p8 = 8.0;
  static const p10 = 10.0;
  static const p12 = 12.0;
  static const p15 = 15.0;
  static const p16 = 16.0;
  static const p20 = 20.0;
  static const p24 = 24.0;
  static const p25 = 25.0;
  static const p30 = 30.0;
  static const p32 = 32.0;
  static const p35 = 35.0;
  static const p40 = 40.0;
  static const p45 = 45.0;
  static const p48 = 48.0;
  static const p64 = 64.0;
}

/// Constant gap widths
final gapW2 = SizedBox(width: Sizes.p2.w);
final gapW3 = SizedBox(width: Sizes.p3.w);
final gapW4 = SizedBox(width: Sizes.p4.w);
final gapW5 = SizedBox(width: Sizes.p5.w);
final gapW6 = SizedBox(width: Sizes.p6.w);
final gapW8 = SizedBox(width: Sizes.p8.w);
final gapW10 = SizedBox(width: Sizes.p10.w);
final gapW12 = SizedBox(width: Sizes.p12.w);
final gapW15 = SizedBox(width: Sizes.p15.w);
final gapW16 = SizedBox(width: Sizes.p16.w);
final gapW20 = SizedBox(width: Sizes.p20.w);
final gapW24 = SizedBox(width: Sizes.p24.w);
final gapW25 = SizedBox(width: Sizes.p25.w);
final gapW30 = SizedBox(width: Sizes.p30.w);
final gapW32 = SizedBox(width: Sizes.p32.w);
final gapW35 = SizedBox(width: Sizes.p35.w);
final gapW40 = SizedBox(width: Sizes.p40.w);
final gapW45 = SizedBox(width: Sizes.p45.w);
final gapW48 = SizedBox(width: Sizes.p48.w);
final gapW64 = SizedBox(width: Sizes.p64.w);
SizedBox gapWcustom(double size) => SizedBox(width: size.w);

/// Constant gap heights
final gapH2 = SizedBox(height: Sizes.p2.h);
final gapH3 = SizedBox(height: Sizes.p3.h);
final gapH4 = SizedBox(height: Sizes.p4.h);
final gapH5 = SizedBox(height: Sizes.p5.h);
final gapH6 = SizedBox(height: Sizes.p6.h);
final gapH8 = SizedBox(height: Sizes.p8.h);
final gapH10 = SizedBox(height: Sizes.p10.h);
final gapH12 = SizedBox(height: Sizes.p12.h);
final gapH15 = SizedBox(height: Sizes.p15.h);
final gapH16 = SizedBox(height: Sizes.p16.h);
final gapH20 = SizedBox(height: Sizes.p20.h);
final gapH24 = SizedBox(height: Sizes.p24.h);
final gapH25 = SizedBox(height: Sizes.p25.h);
final gapH30 = SizedBox(height: Sizes.p30.h);
final gapH32 = SizedBox(height: Sizes.p32.h);
final gapH35 = SizedBox(height: Sizes.p35.h);
final gapH40 = SizedBox(height: Sizes.p40.h);
final gapH45 = SizedBox(height: Sizes.p45.h);
final gapH48 = SizedBox(height: Sizes.p48.h);
final gapH64 = SizedBox(height: Sizes.p64.h);
SizedBox gapHcustom(double size) => SizedBox(height: size.h);
