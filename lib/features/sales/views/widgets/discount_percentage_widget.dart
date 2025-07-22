import 'package:flutter/material.dart';

import '../../../../app/styles/colors.dart';


class DiscountPercentageWidget extends StatelessWidget {
  const DiscountPercentageWidget({
    super.key,
    this.isPercentage = true,
    required this.onTap,
  });

  final bool isPercentage;
  final void Function(bool isPercent) onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 4),
        Material(
          child: InkWell(
            onTap: () {
              onTap(isPercentage);
            },
            child: Container(
              width: 22,
              height: 22,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  color: AppColors.lightBlueColor,
                  borderRadius: BorderRadius.circular(6)),
              child: Icon(
                isPercentage ? Icons.percent : Icons.currency_rupee_rounded,
                size: 15,
                color: AppColors.blueColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
