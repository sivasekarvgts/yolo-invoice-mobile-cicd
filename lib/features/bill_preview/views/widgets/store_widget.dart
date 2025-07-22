import 'package:flutter/material.dart';
import 'package:yoloworks_invoice/core/extension/string_extension.dart';

import '../../../../app/common_widgets/network_image_loader.dart';
import '../../../../app/styles/colors.dart';
import '../../../../app/styles/text_styles.dart';
import '../../../dashboard/client/client_list_view.dart';

class StoreListTitleWidget extends StatelessWidget {
  const StoreListTitleWidget(
      {super.key,
      this.onTap,
      this.url,
      this.minLeadingWidth = 5,
      this.contentPadding,
      this.isVisited = false,
      this.isLoading = false,
      this.isActive = false,
      required this.subTitle,
      required this.title,
      this.trailing});
  final Function()? onTap;
  final String title;
  final String subTitle;
  final String? url;
  final bool isVisited;
  final bool isActive;
  final bool isLoading;
  final double minLeadingWidth;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LoadingCardShimmerTile();
    }
    return ListTile(
        onTap: onTap ?? () {},
        minLeadingWidth: minLeadingWidth,
        contentPadding: contentPadding,
        trailing: trailing,
        leading: SizedBox(
          height: 50,
          width: 50,
          child: NetworkImageLoader(
            borderRadius: BorderRadius.circular(25),
            image: url ?? '',
            height: 45,
            width: 45,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(title,
            overflow: TextOverflow.ellipsis, style: AppTextStyle.darkBlackFS16FW500),
        subtitle: isActive
            ? Row(
                children: [
                  ItemUnitChipWidget(
                    onTap: () {},
                    isSelected: false,
                    name: 'Active',
                    margin: EdgeInsets.zero,
                    width: 80,
                    textStyle: AppTextStyle.blueFS14FW500,
                    borderColor: AppColors.blueColor,
                    padding: const EdgeInsets.symmetric(vertical: 2),
                  ),
                ],
              )
            : Text(subTitle,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.greyFS12FW500));
  }
}

class ItemUnitChipWidget extends StatelessWidget {
  const ItemUnitChipWidget(
      {super.key,
      this.height,
      this.width,
      this.textStyle,
      this.alignment,
      this.margin,
      this.borderColor = Colors.black,
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
  final Color borderColor;

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
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(40),
                color: isSelected
                    ? AppColors.dividerGreyColor
                    : Colors.transparent),
            child: Text(name.capitalizeFirst.toString(),
                style: textStyle ?? AppTextStyle.darkBlackFS14FW500),
          ),
        ));
  }
}
