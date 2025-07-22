import 'package:flutter/material.dart';

class TextClass {
  final String text;
  final TextStyle textStyle;
  TextAlign? textAlign;
  TextOverflow? textOverflow;
  int? maxLines;

  TextClass(
      {required this.text,
      required this.textStyle,
      this.textAlign,
      this.textOverflow,
      this.maxLines});
}
