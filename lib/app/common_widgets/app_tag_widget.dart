import 'package:flutter/material.dart';

import '../styles/text_styles.dart';

class AppTagWidget extends StatelessWidget {
  const AppTagWidget(
      {super.key,
      required this.color,
      required this.title,
      this.margin,
      this.padding,
      this.textStyle});

  final Color color;
  final String title;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
      child: Text(title.toUpperCase(),
          style: textStyle ?? AppTextStyle.lincolnGreenF10W600),
    );
  }
}
