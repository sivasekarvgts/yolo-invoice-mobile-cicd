import 'package:flutter/material.dart';

import '../constants/app_ui_constants.dart';
import '../styles/text_styles.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({super.key, required this.msg, this.vertical = 8});
  final double vertical;
  final String msg;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppUiConstants.errorCardDecoration,
      padding: const EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: vertical),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.report_outlined, size: 21),
              const SizedBox(width: 6),
              Text('Warning', style: AppTextStyle.darkBlackFS16FW600)
            ],
          ),
          const SizedBox(height: 5),
          Text(msg, style: AppTextStyle.darkBlackFS14FW500)
        ],
      ),
    );
  }
}
