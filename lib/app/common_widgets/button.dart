import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoloworks_invoice/app/common_widgets/shimmer_widget/shimmer_effect.dart';
import '../styles/colors.dart';
import '../styles/text_styles.dart';

TextStyle _buttonTextStyle = AppTextStyle.button.copyWith(color: Colors.white);
TextStyle _outlineTextStyle =
    AppTextStyle.button.copyWith(color: AppColors.primary);
TextStyle _disabledTextStyle =
    AppTextStyle.button.copyWith(color: AppColors.vampireGreyColor);

// ignore: must_be_immutable
class AppButton extends StatelessWidget {
  final Key key;
  final String text;
  final String? price;
  final int? items;
  TextStyle? textStyle;
  final EdgeInsets? padding;
  final double? width;
  final double height;
  final VoidCallback onPressed;
  final Color color;
  final Color borderColor;
  final BorderRadius? borderRadius;
  final bool disabled;
  final bool isPriceItems;
  Widget? icon;
  Widget? suffixIcon;
  Alignment? iconAlignment;
  bool isLoading = false;
  bool shimmerEffect = false;
  Color? loadingIndicatorColor;
  bool fullSize = true;
  bool isOutline = false;

  AppButton(this.text,
      {required this.key,
      this.textStyle,
      this.width = 105,
      this.height = 44,
      this.items,
      this.price,
      required this.onPressed,
      this.color = AppColors.primary,
      this.borderColor = AppColors.primary,
      this.borderRadius,
      this.fullSize = true,
      this.disabled = false,
      this.isLoading = false,
      this.isPriceItems = false,
      this.loadingIndicatorColor,
      this.icon,
      this.suffixIcon,
      this.padding,
      this.iconAlignment});

  AppButton.outline(this.text,
      {required this.key,
      this.textStyle,
      this.width = 105,
      this.height = 44,
      required this.onPressed,
      this.color = AppColors.background,
      this.borderColor = AppColors.primary,
      this.borderRadius,
      this.disabled = false,
      this.isPriceItems = false,
      this.fullSize = true,
      this.items,
      this.price,
      this.icon,
      this.suffixIcon,
      this.isLoading = false,
      this.shimmerEffect = false,
      this.loadingIndicatorColor,
      this.padding,
      this.iconAlignment}) {
    isOutline = true;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      width: fullSize ? double.infinity : width,
      child: MaterialButton(
        key: key,
        height: height.h,
        minWidth: 0,
        onPressed: () {
          if (disabled == true||isLoading) {
            return;
          }
          onPressed();
        },
        materialTapTargetSize: MaterialTapTargetSize.padded,
        color: disabled ? AppColors.secondary : color,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
        elevation: 0.0,
        hoverElevation: 0,
        focusElevation: 0,
        disabledElevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor, width: 1.0),
          borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(8.r)),
        ),
        child: isLoading
            ?shimmerEffect?
            ShimmerWidget.heading(height: height,child: Text(text,style: AppTextStyle.blueFS14FW500,),):
        SizedBox(
                width: 15,
                height: 15,
                child: CupertinoActivityIndicator(
                    color: loadingIndicatorColor ?? Colors.white))
            : isPriceItems
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ItemPriceWidget(
                        items: items!,
                        price: price!,
                      ),
                      Text(text, style: textStyle),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    textDirection: iconAlignment == Alignment.centerRight
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    children: [
                      if (icon != null) icon!,
                      SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          text,
                          style: textStyle ??
                              (disabled
                                  ? _disabledTextStyle
                                  : isOutline
                                      ? _outlineTextStyle
                                      : _buttonTextStyle),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 5),
                      if (suffixIcon != null) suffixIcon!,
                    ],
                  ),
      ),
    );
  }
}

class ItemPriceWidget extends StatelessWidget {
  const ItemPriceWidget(
      {super.key,
      required this.items,
      required this.price,
      this.color = Colors.white,
      this.textStyle});
  final int items;
  final Color color;
  final String price;
  final TextStyle? textStyle;
  @override
  Widget build(BuildContext context) {
    final txtStyle = textStyle ?? AppTextStyle.whiteFS13FW500;
    return Row(
      children: [
        Icon(Icons.receipt_long_outlined, size: 16, color: color),
        const SizedBox(width: 4),
        Text('$items ${items > 1 ? 'items' : 'item'}  │', style: txtStyle),
        if (price.isNotEmpty) Text('  $price', style: txtStyle),
      ],
    );
  }
}
