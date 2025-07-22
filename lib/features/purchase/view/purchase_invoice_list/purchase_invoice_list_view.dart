import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/common_widgets/app_bar_widget.dart';
import '../../../../app/common_widgets/app_filter_widget.dart';
import '../../../../app/common_widgets/app_refresh_widget.dart';
import '../../../../app/common_widgets/floating_button.dart';
import '../../../../app/common_widgets/search_widget.dart';
import '../../../../app/constants/app_sizes.dart';
import '../../../../app/styles/colors.dart';
import '../../../sales/views/widgets/bill_due_summary_card.dart';
import '../../../sales/views/widgets/invoice/invoice_list_widget.dart';
import 'purchase_invoice_list_controller.dart';

class PurchaseInvoiceListView extends ConsumerStatefulWidget {
  const PurchaseInvoiceListView({super.key});

  @override
  ConsumerState createState() => _PurchaseInvoiceListViewState();
}

class _PurchaseInvoiceListViewState
    extends ConsumerState<PurchaseInvoiceListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller =
          ref.read(purchaseInvoiceListControllerProvider.notifier);
      await controller.onInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller =
        ref.watch(purchaseInvoiceListControllerProvider.notifier);
    final state = ref.watch(purchaseInvoiceListControllerProvider);
    final isLoading = state.isLoading;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBarWidget.empty(
        title: 'Purchase Invoice',
        onChanged: controller.onSearchInvoice,
        textCtrl: controller.searchTextCtrl,
        isSearchBar: controller.showSearchBar,
        onClear: () async {
          controller.showSearchBar = false;
          if( controller.searchTextCtrl.text.isNotEmpty){
            controller.searchTextCtrl.clear();
            await controller.fetchData(refresh: true);
          } else {
            controller.setState;
          }
        },
        actions: [
          if (!controller.showSearchBar)
            IconButton(
                onPressed: controller.onOpenSearch,
                icon: const Icon(CupertinoIcons.search)),
          if (!controller.showSearchBar)
            Center(
              child: AppFilterWidget(
                onTap: controller.showFilter,
                count: controller.selectedDateRange != null ? 1 : null,
              ),
            ),
          gapW12,
        ],
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: const Divider(height: 1,)),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SafeArea(
        child: FloatingButton(
          label: "New Purchase Invoice",
          onTap: controller.navigatePurchaseInvoice,
          visibilityOfFloating: controller.visibilityOfFloating,
        ),
      ),
      body: Column(
        children: [
          BillDueSummaryWidget(
              totalBillAmount: controller
                      .purchaseInvoiceData?.totalValues?.totalBillAmount ??
                  0.0,
              totalDueAmount:
                  controller.purchaseInvoiceData?.totalValues?.totalDueAmount ??
                      0.0),
          Expanded(
            child: AppRefreshWidget(
              onRefresh: () async {
                if (isLoading) return;
                return await controller.fetchData(refresh: true);
              },
              onLoad: () async {
                if (isLoading) return;
                return await controller.fetchData();
              },
              childBuilder: (context, physics) => InvoiceListWidget(
                physics: physics,
                controller: controller.hideButtonController,
                isLoading: isLoading,
                invoiceList: controller.purchaseInvoiceList,
                onTap: (i) => controller.openBillPreview(i),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
