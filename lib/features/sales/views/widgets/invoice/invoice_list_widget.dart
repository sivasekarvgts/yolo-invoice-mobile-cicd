import 'package:flutter/material.dart';

import '../../../../../app/common_widgets/empty_widget/app_empty_widget.dart';
import '../../../../../app/common_widgets/shimmer_widget/list_item_loading_widget.dart';
import '../../../models/invoice/invoice_list_model.dart';
import '../orders/orders_list_widget.dart';

class InvoiceListWidget extends StatelessWidget {
  const InvoiceListWidget({
    super.key,
    this.onTap,
    required this.physics,
    required this.controller,
    required this.invoiceList,
    this.isLoading = false,
  });

  final bool isLoading;
  final ScrollPhysics physics;
  final ScrollController? controller;
  final void Function(int i)? onTap;
  final List<InvoiceList> invoiceList;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return ListItemLoadingWidget();
    }
    if (invoiceList.isEmpty) {
      return AppEmptyWidget(
        physics: physics,
        reducePercent: 10,
      );
    }

    return ListView.builder(
      controller: controller,
      physics: physics,
      itemCount: invoiceList.length,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      itemBuilder: (context, i) {
        final invoice = invoiceList[i];
        return OrdersItemWidget(
            onTap: () => onTap!(i),
            title: invoice.client ?? invoice.vendor,
            logo: invoice.logo,
            salesNumber: invoice.invoiceNumber,
            statusName: invoice.dueStatusName,
            statusColor: invoice.colorValue,
            amount: invoice.total,
            date: invoice.dateFormatted,
            dueAmount: invoice.balanceDue);
      },
    );
  }
}
