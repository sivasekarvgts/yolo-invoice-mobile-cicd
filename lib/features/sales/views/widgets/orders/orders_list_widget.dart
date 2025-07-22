import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoloworks_invoice/core/extension/currency_extension.dart';

import '../../../../../app/common_widgets/empty_widget/app_empty_widget.dart';
import '../../../../../app/common_widgets/shimmer_widget/list_item_loading_widget.dart';
import '../../../../../app/common_widgets/shimmer_widget/shimmer_effect.dart';
import '../../../../../app/constants/app_sizes.dart';
import '../../../../../app/constants/app_ui_constants.dart';
import '../../../../../app/styles/colors.dart';
import '../../../../../app/styles/text_styles.dart';
import '../../../models/sales_order/sales_order_list_model.dart';
import '../status_widget.dart';

class OrderListWidget extends StatelessWidget {
  const OrderListWidget({
    super.key,
    this.onTap,
    required this.physics,
    required this.controller,
    required this.ordersList,
    this.isLoading = false,
  });

  final bool isLoading;
  final ScrollPhysics physics;
  final ScrollController? controller;
  final void Function(int i)? onTap;
  final List<OrderListItem> ordersList;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return ListItemLoadingWidget();
    }
    if (ordersList.isEmpty) {
      return AppEmptyWidget(
        physics: physics,
        reducePercent: 10,
      );
    }
    return ListView.builder(
      physics: physics,
      controller: controller,
      itemCount: ordersList.length,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      itemBuilder: (context, i) {
        final salesOrder = ordersList[i];
        return OrdersItemWidget(
          onTap: () => onTap!(i),
          title: salesOrder.client ?? salesOrder.vendor,
          logo: salesOrder.logo,
          salesPerson: salesOrder.salesPerson,
          salesNumber: salesOrder.orderNumber,
          statusName: salesOrder.orderStatusName,
          statusColor: salesOrder.colorValue,
          amount: salesOrder.total,
          date: salesOrder.dateFormatted,
        );
      },
    );
  }
}

class OrdersItemWidget extends StatelessWidget {
  const OrdersItemWidget({
    super.key,
    this.isLoading = false,
    this.onTap,
    this.statusColor,
    this.statusName,
    this.logo,
    this.title,
    this.salesPerson,
    this.salesNumber,
    this.dueAmount,
    this.amount,
    this.date,
  });

  final bool isLoading;
  final String? logo;
  final String? title;
  final String? salesNumber;
  final double? amount;
  final double? dueAmount;
  final String? salesPerson;
  final String? date;
  final String? statusName;
  final Color? statusColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppUiConstants.salesCardItemDecoration,
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(10),
      child: isLoading
          ? _OrderItemLoadingWidget()
          : InkWell(
              onTap: onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text('#${salesNumber ?? '-'}',
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.greyFS12FW500),
                      ),
                      StatusWidget(
                        status: statusName ?? '-',
                        color: statusColor ?? AppColors.lightBrownColor,
                        textStyle: AppTextStyle.darkBlackFS10FW600
                            .copyWith(fontSize: 9.sp),
                      )
                    ],
                  ),
                  gapH4,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title ?? "-", style: AppTextStyle.blackFS14FW600),
                      Text(amount?.toCurrencyFormatString() ?? '0',
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.blackFS14FW600),
                    ],
                  ),
                  gapH4,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(date ?? '-', style: AppTextStyle.greyFS12FW500),
                      Text(salesPerson ?? '',
                          style: AppTextStyle.greyFS12FW500),
                      if (dueAmount != null)
                        Text(
                            "Due : " +
                                (dueAmount?.toCurrencyFormatString() ?? '0'),
                            style: AppTextStyle.greyFS12FW500.copyWith()),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

class _OrderItemLoadingWidget extends StatelessWidget {
  const _OrderItemLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gapH8,
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ShimmerWidget.circular(height: 35, width: 35),
                gapW8,
                ShimmerWidget.text(height: 20, width: 100),
              ],
            ),
            ShimmerWidget.text(height: 20, width: 100),
          ],
        ),
        gapH8,
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerWidget.text(height: 15, width: 100),
            ShimmerWidget.text(height: 15, width: 100),
          ],
        ),
        gapH8,
        ShimmerWidget.text(height: 15, width: 70),
      ],
    );
  }
}
