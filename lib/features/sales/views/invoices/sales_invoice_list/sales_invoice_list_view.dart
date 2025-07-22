import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yoloworks_invoice/app/styles/colors.dart';

import '../../../../../app/common_widgets/app_bar_widget.dart';
import '../../../../../app/common_widgets/app_filter_widget.dart';
import '../../../../../app/common_widgets/app_refresh_widget.dart';
import '../../../../../app/common_widgets/floating_button.dart';
import '../../../../../app/common_widgets/search_widget.dart';
import '../../../../../app/constants/app_sizes.dart';
import '../../widgets/bill_due_summary_card.dart';
import '../../widgets/invoice/invoice_list_widget.dart';
import 'sales_invoice_list_controller.dart';

class SalesInvoiceListView extends ConsumerStatefulWidget {
  const SalesInvoiceListView({super.key});

  @override
  ConsumerState<SalesInvoiceListView> createState() =>
      _SalesInvoiceListViewState();
}

class _SalesInvoiceListViewState extends ConsumerState<SalesInvoiceListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = ref.read(salesInvoiceListControllerProvider.notifier);
      await controller.onInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(salesInvoiceListControllerProvider.notifier);
    final state = ref.watch(salesInvoiceListControllerProvider);
    final isLoading = state.isLoading;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBarWidget.empty(
        title: 'Sales Invoice',
        onChanged: controller.onSearchInvoice,
        textCtrl: controller.searchTextCtrl,
        isSearchBar: controller.showSearchBar,
        onClear: () async {
          controller.showSearchBar = false;
          if( controller.searchTextCtrl.text.isNotEmpty){
            controller.searchTextCtrl.clear();
            await controller.fetchData(refresh: true);
          }else {
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
            child:  Divider(
              height: 1,
            ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SafeArea(
        child: FloatingButton(
            onTap: controller.navigateSalesInvoice,
            visibilityOfFloating: controller.visibilityOfFloating),
      ),
      body: Column(
        children: [
          BillDueSummaryWidget(
              totalBillAmount:
                  controller.salesInvoiceData?.totalValues?.totalBillAmount ??
                      0.0,
              totalDueAmount:
                  controller.salesInvoiceData?.totalValues?.totalDueAmount ??
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
                invoiceList: controller.salesInvoiceList,
                onTap: (i) => controller.openBillPreview(i),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
