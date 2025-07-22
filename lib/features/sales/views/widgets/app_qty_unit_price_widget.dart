import 'package:flutter/material.dart';

import '../../../../app/styles/text_styles.dart';

class QtyUnitPriceWidget extends StatelessWidget {
  const QtyUnitPriceWidget(
      {super.key, required this.title, required this.value, this.iconWidget});
  final String title;
  final String value;
  final Widget? iconWidget;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: AppTextStyle.greyFS12FW600),
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (iconWidget != null) iconWidget!,
            Text(value,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.darkBlackFS14FW500),
          ],
        )
      ],
    );
  }
}
