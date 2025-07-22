import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoloworks_invoice/app/constants/app_sizes.dart';
import 'package:yoloworks_invoice/app/constants/images.dart';
import 'package:yoloworks_invoice/core/extension/currency_extension.dart';
import 'package:yoloworks_invoice/features/bill_preview/views/widgets/sales_payment_list_tab.dart';
import 'package:yoloworks_invoice/router.dart';

import '../../../../../app/common_widgets/app_refresh_widget.dart';
import '../../../../../app/common_widgets/empty_widget/app_empty_widget.dart';
import '../../../../../app/common_widgets/shimmer_widget/list_item_loading_widget.dart';
import '../../../../../core/enums/icon_type.dart';
import '../client_info_controller.dart';

class ClientTransactionListTab extends ConsumerWidget {
  const ClientTransactionListTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(clientInfoControllerProvider.notifier);
    final state = ref.watch(clientInfoControllerProvider);
    final transactionList = controller.transactionData?.transactionDetail;
    return AppRefreshWidget(
      onRefresh: () async {
        if (state.isLoading) return;
        return await controller.fetchData(refresh: true);
      },
      childBuilder: (context, physics) {
        if (state.isLoading) {
          return ListItemLoadingWidget(
            noIcon: false,
          );
        }
        if (transactionList?.isEmpty == true) {
          return AppEmptyWidget(
            physics: physics,
            reducePercent: 25,
          );
        }
        return ListView.separated(
            padding: EdgeInsets.zero,
            physics: physics,
            itemCount: transactionList?.length ?? 0,
            itemBuilder: (context, index) {
              final transaction = transactionList?[index];

              if (transaction?.name?.contains("Opening") == true)
                return TransactionCardWidget(
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  title: transaction?.name,
                  subTitle: transaction?.issuedOn,
                  trailingAmount:
                      transaction?.balance?.toCurrencyFormatString(),
                  amountType: AmountType.credit,
                  icon: transaction?.icon ?? "",
                  iconType: transaction?.iconType??IconType.payOut,
                  subTrailing:
                      "Balance: ${transaction?.balance.toCurrencyFormatString()}",
                );
              return TransactionCardWidget(
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                title: transaction?.transactionNo?.number,
                subTitle: transaction?.issuedOn,
                trailingAmount: transaction?.amount?.toCurrencyFormatString(),
                amountType: transaction?.amountType ?? AmountType.none,
                isInOutIcon: true,
                // icon: transaction?.icon ?? "",
                icon: Svgs.transaction,
                // icon: transaction?.amountType==AmountType.credit?Svgs.receipt:Svgs.paymentSent,
                // iconType: transaction!.iconType,
                // iconType: transaction?.amountType==AmountType.credit?IconType.invoice:IconType.sales,
                iconType:IconType.non,
                subTrailing:
                    "Balance: ${transaction?.balance.toCurrencyFormatString()}",
                // onTap: (){
                //  if( transaction.iconType==IconType.invoice)controller.navigateToBillPreview(transaction?.)
                // },
              );
            },
            separatorBuilder: (context, index) => gapH5);
      },
    );
  }
}
