import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoloworks_invoice/app/common_widgets/app_refresh_widget.dart';
import 'package:yoloworks_invoice/app/styles/colors.dart';
import 'package:yoloworks_invoice/core/extension/currency_extension.dart';

import '../../../../../app/common_widgets/empty_widget/app_empty_widget.dart';
import '../../../../../app/common_widgets/shimmer_widget/list_item_loading_widget.dart';
import '../../../../../app/constants/app_sizes.dart';
import '../../../../../app/constants/images.dart';
import '../../../../../core/enums/icon_type.dart';
import '../../../../bill_preview/views/widgets/sales_payment_list_tab.dart';
import '../client_info_controller.dart';

class ClientPaymentTab extends ConsumerWidget {
  const ClientPaymentTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(clientInfoControllerProvider.notifier);
    final state = ref.watch(clientInfoControllerProvider);
    final paymentList = controller.paymentList;
    return AppRefreshWidget(onRefresh: () async {
      if (state.isLoading) return;
      return await controller.fetchPaymentList(refresh: true);
    }, onLoad: () async {
      if (state.isLoading) return;
      return await controller.fetchPaymentList();
    }, childBuilder: (context, physics) {
      if (paymentList.isEmpty) if (state.isLoading) {
        return ListItemLoadingWidget(noIcon: false);
      }
      if (paymentList.isEmpty) {
        return AppEmptyWidget(
          physics: physics,
          reducePercent: 25,
        );
      }
      return ListView.separated(
          padding: EdgeInsets.zero,
          physics: physics,
          itemCount: paymentList.length,
          itemBuilder: (context, index) {
            final payment = paymentList[index];
            return TransactionCardWidget(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              title: payment.paymentNumber,
              subTitle: payment.dateFormatted,
              status: payment.paymentMode,
              statusColor: AppColors.peachOrangeColor,
              trailingAmount: payment.total?.toCurrencyFormatString(),
              subTrailing:
                  "EXCESS: ${payment.excessAmount.toCurrencyFormatString()}",
              icon: Svgs.receipt,
              iconType: IconType.payIn,
              onTap: () async {
                await controller.navigateToPayment(payment.id);
              },
            );
          },
          separatorBuilder: (context, index) => gapH5);
    });
  }
}
