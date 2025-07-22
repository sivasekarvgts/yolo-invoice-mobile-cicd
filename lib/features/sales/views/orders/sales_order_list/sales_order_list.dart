import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yoloworks_invoice/app/constants/images.dart';
import 'package:yoloworks_invoice/core/enums/icon_type.dart';
import 'package:yoloworks_invoice/core/extension/currency_extension.dart';

import '../../../../../app/common_widgets/app_bar_widget.dart';
import '../../../../../app/common_widgets/app_filter_widget.dart';
import '../../../../../app/common_widgets/app_refresh_widget.dart';
import '../../../../../app/common_widgets/floating_button.dart';
import '../../../../../app/common_widgets/search_widget.dart';
import '../../../../../app/constants/app_sizes.dart';
import '../../../../../app/styles/colors.dart';
import '../../widgets/bill_due_summary_card.dart';
import '../../widgets/orders/orders_list_widget.dart';
import 'sales_order_list_controller.dart';

class SalesOrderList extends ConsumerStatefulWidget {
  const SalesOrderList({super.key});

  @override
  ConsumerState<SalesOrderList> createState() => _SalesOrderListState();
}

class _SalesOrderListState extends ConsumerState<SalesOrderList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = ref.read(salesOrderListControllerProvider.notifier);
      await controller.onInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(salesOrderListControllerProvider.notifier);
    final state = ref.watch(salesOrderListControllerProvider);
    final isLoading = state.isLoading;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBarWidget.empty(
        title: 'Sales Orders',
        onChanged: controller.onSearchOrder,
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
            child:const Divider(
              height: 1,
            ),
            // Column(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     // if (controller.showSearchBar)
            //     //   SearchWidget(
            //     //     key: const Key("searchCustomer"),
            //     //     hintText: "Search by Bill No / Name",
            //     //     textCtrl: controller.searchTextCtrl,
            //     //     onCancel: () async {
            //     //       controller.searchTextCtrl.clear();
            //     //       controller.showSearchBar = false;
            //     //       controller.setState;
            //     //       await controller.fetchData(refresh: true);
            //     //     },
            //     //     onClear: () async {
            //     //       controller.searchTextCtrl.clear();
            //     //       await controller.fetchData(refresh: true);
            //     //     },
            //     //     onChanged: controller.onSearchOrder,
            //     //   ),
            //     // const Divider(
            //     //   height: 1,
            //     // ),
            //   ],
            // )
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SafeArea(
        child: FloatingButton(
            label: "New Sales Order",
            onTap: controller.createSalesOrder,
            visibilityOfFloating: controller.visibilityOfFloating),
      ),
      body: Column(
        children: [
          BillDueSummaryCard(
            flex: 0,
            icon: Svgs.invoice,
            title: 'Total Bill',
            totalAmount: controller.salesOrderData?.totalValues?.totalBillAmount
                    ?.toCurrencyFormat() ??
                "",
            iconType: IconType.invoice,
          ),
          Expanded(
            flex: 1,
            child: AppRefreshWidget(
              onRefresh: () async {
                if (isLoading) return;
                return await controller.fetchData(refresh: true);
              },
              onLoad: () async {
                if (isLoading) return;
                return await controller.fetchData();
              },
              childBuilder: (context, physics) => OrderListWidget(
                physics: physics,
                controller: controller.hideButtonController,
                isLoading: isLoading,
                ordersList: controller.salesOrderList,
                onTap: (i) => controller.openBillPreview(i),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
