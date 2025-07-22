import 'package:flutter/material.dart';
import 'package:yoloworks_invoice/core/extension/currency_extension.dart';

import '../../../../../app/common_widgets/app_bill_status_widget.dart';
import '../../../../../app/common_widgets/empty_widget/app_empty_widget.dart';
import '../../../../../app/common_widgets/shimmer_widget/list_item_loading_widget.dart';
import '../../../../../app/constants/app_sizes.dart';
import '../../../../../app/constants/app_ui_constants.dart';
import '../../../../../app/styles/colors.dart';
import '../../../../../app/styles/text_styles.dart';
import '../../models/payment_list_model.dart';

class PaymentListWidget extends StatelessWidget {
  const PaymentListWidget({
    super.key,
    this.onTap,
    required this.physics,
    required this.paymentList,
    this.scrollController,
    this.isLoading = false,
  });

  final bool isLoading;
  final ScrollPhysics physics;
  final ScrollController? scrollController;
  final void Function(int i)? onTap;
  final List<PaymentDatum> paymentList;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return ListItemLoadingWidget();
    }
    if (paymentList.isEmpty) {
      return  AppEmptyWidget(
        physics: physics,reducePercent: 10,
      );
    }

    return ListView.builder(
      physics: physics,
      controller: scrollController,
      itemCount: paymentList.length,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      itemBuilder: (context, i) {
        final payment = paymentList[i];
        return PaymentItemWidget(payment: payment, onTap: () => onTap!(i));
      },
    );
  }
}

class PaymentItemWidget extends StatelessWidget {
  const PaymentItemWidget(
      {super.key, this.isLoading = false, this.onTap, this.payment});

  final bool isLoading;
  final void Function()? onTap;
  final PaymentDatum? payment;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppUiConstants.salesCardItemDecoration,
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text('#${payment?.paymentNumber ?? '-'}',
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.greyFS12FW500),
                ),
                AppBillStatusWidget(
                  status: payment?.paymentMode ?? '-',
                  color: AppColors.mediumBrownColor,
                  textStyle: AppTextStyle.darkBlackFS10FW600,
                )
              ],
            ),
            // gapH4,
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(payment?.displayName ?? '-',
                    style: AppTextStyle.blackFS14FW600),
                Text(payment?.dateFormatted ?? '-',
                    style: AppTextStyle.darkBlackFS12FW500),
              ],
            ),
            gapH4,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Received Amount',
                          style: AppTextStyle.greyFS12FW500),
                      Text(
                          payment?.receivedAmount?.toCurrencyFormatString() ??
                              '0',
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.darkBlackFS12FW500),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Excess Amount', style: AppTextStyle.greyFS12FW500),
                      Text(
                          payment?.excessAmount?.toCurrencyFormatString() ??
                              '0',
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.darkBlackFS12FW500),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
