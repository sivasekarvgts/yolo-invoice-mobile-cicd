import 'package:flutter/material.dart';
import 'package:yoloworks_invoice/app/styles/colors.dart';
import 'package:yoloworks_invoice/app/styles/text_styles.dart';

class ItemUnitChipWidget extends StatelessWidget {
  const ItemUnitChipWidget(
      {super.key,
      this.height,
      this.width,
      this.textStyle,
      this.alignment,
      this.margin,
      this.padding = const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      required this.isSelected,
      required this.name,
      required this.onTap});
  final String name;
  final double? width;
  final double? height;
  final bool isSelected;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final TextStyle? textStyle;
  final AlignmentGeometry? alignment;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: margin ?? const EdgeInsets.symmetric(horizontal: 4),
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: height,
            width: width,
            padding: padding,
            alignment: alignment ?? Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(40),
                color: isSelected ? AppColors.greyColor : Colors.transparent),
            child: Text(name, style: AppTextStyle.labelExtraSmall),
          ),
        ));
  }
}
