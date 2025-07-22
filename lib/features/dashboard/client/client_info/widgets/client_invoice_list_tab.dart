import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoloworks_invoice/app/common_widgets/app_refresh_widget.dart';
import 'package:yoloworks_invoice/app/constants/images.dart';
import 'package:yoloworks_invoice/core/enums/icon_type.dart';
import 'package:yoloworks_invoice/core/extension/currency_extension.dart';

import '../../../../../app/common_widgets/empty_widget/app_empty_widget.dart';
import '../../../../../app/common_widgets/shimmer_widget/list_item_loading_widget.dart';
import '../../../../../app/constants/app_sizes.dart';
import '../../../../bill_preview/views/widgets/sales_payment_list_tab.dart';
import '../client_info_controller.dart';

class ClientInvoiceListTab extends ConsumerWidget {
  const ClientInvoiceListTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(clientInfoControllerProvider.notifier);
    final state = ref.watch(clientInfoControllerProvider);
    final invoiceList = controller.invoiceList;
    return AppRefreshWidget(
      onRefresh: () async {
        if (state.isLoading) return;
        return await controller.fetchInvoiceList(refresh: true);
      },
      onLoad: () async {
        if (state.isLoading) return;
        return await controller.fetchInvoiceList();
      },
      childBuilder: (context, physics) {
        if (state.isLoading) {
          return ListItemLoadingWidget(noIcon: false);
        }
        if (invoiceList.isEmpty) {
          return AppEmptyWidget(
            physics: physics,
            reducePercent: 25,
          );
        }
        return ListView.separated(
            padding: EdgeInsets.zero,
            physics: physics,
            itemCount: invoiceList.length,
            itemBuilder: (context, index) {
              final invoice = invoiceList[index];

              return TransactionCardWidget(
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                title: invoice.invoiceNumber,
                subTitle: invoice.dateFormatted,
                status: invoice.dueStatusName,
                statusColor: invoice.colorValue,
                trailingAmount: invoice.total.toCurrencyFormatString(),
                subTrailing:
                    "DUE: ${invoice.balanceDue.toCurrencyFormatString()}",
                icon: Svgs.invoice,
                iconType: IconType.invoice,
                onTap: () {
                  controller.navigateToBillPreview(invoice.id);
                },
              );
            },
            separatorBuilder: (context, index) => gapH5);
      },
    );
  }
}
