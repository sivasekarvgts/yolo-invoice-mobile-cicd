import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoloworks_invoice/app/styles/text_styles.dart';
import 'package:yoloworks_invoice/core/extension/color_extension.dart';
import 'package:yoloworks_invoice/core/extension/currency_extension.dart';

import '../../../../app/common_widgets/sales_icon_card_widget.dart';
import '../../../../app/constants/app_sizes.dart';
import '../../../../app/constants/app_ui_constants.dart';
import '../../../../app/constants/images.dart';
import '../../../../core/enums/icon_type.dart';

class BillDueSummaryWidget extends StatelessWidget {
  const BillDueSummaryWidget({
    super.key,
    required this.totalBillAmount,
    this.icon1,
    this.icon2,
    this.iconType1,
    this.iconType2,
    this.padding,
    required this.totalDueAmount,
  });

  final double totalBillAmount;
  final double totalDueAmount;
  final IconType? iconType2;
  final String? icon2;
  final IconType? iconType1;
  final String? icon1;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
      child: Row(
        children: [
          BillDueSummaryCard(
            icon: icon1 ?? Svgs.invoice,
            title: "Total Bill",
            iconType: iconType1 ?? IconType.invoice,
            totalAmount: totalBillAmount.toCurrencyFormat(),
          ),
          gapW10,
          BillDueSummaryCard(
            icon: icon2 ?? Svgs.receipt,
            title: "Total Due",
            iconType: iconType2 ?? IconType.payIn,
            totalAmount: totalDueAmount.toCurrencyFormat(),
          )
        ],
      ),
    );
  }
}

class BillDueSummaryCard extends StatelessWidget {
  const BillDueSummaryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.iconType,
    required this.totalAmount,
    this.flex,
  });

  final String totalAmount;
  final String title;
  final IconType iconType;
  final String icon;
  final int? flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: flex ?? 1,
        child: Container(
          margin: flex == 0
              ? EdgeInsets.symmetric(horizontal: 12, vertical: 5)
              : null,
          // width: flex == 0 ? MediaQuery.of(context).size.width * .5 : null,
          padding: EdgeInsets.all(8),
          decoration: AppUiConstants.salesCardItemDecoration,
          child: Row(
            children: [
              Expanded(
                flex: 0,
                child: SalesIconCardWidget(
                  icon: icon,
                  size: 32.h,
                  radius: 6.r,
                  padding: EdgeInsets.all(8.h),
                  color1: iconType.color1,
                  color2: iconType.color2,
                ),
              ),
              gapW8,
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyle.greyFS12FW500,
                    ),
                    Text(
                      "$totalAmount",
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                      style: AppTextStyle.darkBlackFS14FW600,
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
