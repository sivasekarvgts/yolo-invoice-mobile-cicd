import 'package:flutter/material.dart';

import '../../../../app/styles/text_styles.dart';

class DiscountDetailsSheet extends StatelessWidget {
  const DiscountDetailsSheet({super.key, required this.discountText});
  final String discountText;
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 12),
              child:
                  Text(discountText, style: AppTextStyle.darkBlackFS16FW500)),
        ]);
  }
}
