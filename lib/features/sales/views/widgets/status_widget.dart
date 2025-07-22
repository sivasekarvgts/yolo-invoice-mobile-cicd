import 'package:flutter/material.dart';
import 'package:yoloworks_invoice/core/extension/color_extension.dart';

import '../../../../app/common_widgets/app_tag_widget.dart';

class StatusWidget extends StatelessWidget {
  const StatusWidget(
      {super.key,
      required this.status,
      required this.color,
      this.textStyle,
      this.margin,
      this.padding});

  final String status;
  final Color color;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: AppTagWidget(
        margin: margin,
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        title: status,
        color: color.lighten(.08),
        textStyle: textStyle?.copyWith(
          color: color.darken(.35),
        ),
      ),
    );
  }
}
