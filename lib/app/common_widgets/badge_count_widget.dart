import 'package:flutter/material.dart';
import 'package:yoloworks_invoice/app/styles/text_styles.dart';

import '../constants/app_ui_constants.dart';

class BadgeCountWidget extends StatelessWidget {
  const BadgeCountWidget({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
        decoration: AppUiConstants.badgeCardDecoration,
        child: Text('$count', style: AppTextStyle.darkBlackFS14FW500));
  }
}
