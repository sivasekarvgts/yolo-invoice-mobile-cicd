import 'package:flutter/material.dart';
import 'package:yoloworks_invoice/app/constants/app_sizes.dart';
import 'package:yoloworks_invoice/app/styles/text_styles.dart';

import '../styles/colors.dart';

class TextFieldSuffixWidget extends StatelessWidget {
  const TextFieldSuffixWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const VerticalDivider(
              thickness: 1.2,
              color: AppColors.outlineGreyColor,
              indent: 12,
              endIndent: 12),
          Text(
            title,
            style: AppTextStyle.blackFS14FW500,
          ),
          Icon(
            Icons.keyboard_arrow_down,
            size: 18,
          ),
          gapW2
        ],
      ),
    );
  }
}

class TextFieldPrefixWidget extends StatelessWidget {
  const TextFieldPrefixWidget(
      {super.key, required this.onTap, required this.text});

  final Function onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: InkWell(
        onTap: () => onTap(),
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(text, style: AppTextStyle.titleSmall),
              const SizedBox(width: 6),
              const Icon(Icons.keyboard_arrow_down, size: 18),
              const SizedBox(width: 6),
              const VerticalDivider(
                  thickness: 1.2,
                  color: AppColors.outlineGreyColor,
                  indent: 12,
                  endIndent: 12),
              const SizedBox(width: 6),
            ],
          ),
        ),
      ),
    );
  }
}
