import 'package:flutter/material.dart';

import 'app_tag_widget.dart';

class AppBillStatusWidget extends StatelessWidget {
  const AppBillStatusWidget(
      {super.key, required this.status, required this.color, this.textStyle});
  final String status;
  final Color color;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: AppTagWidget(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        title: status,
        color: color,
        textStyle: textStyle,
      ),
    );
  }
}
