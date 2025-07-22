import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yoloworks_invoice/core/enums/order_type.dart';
import 'package:yoloworks_invoice/core/extension/currency_extension.dart';
import 'package:yoloworks_invoice/features/purchase/view/purchase_order_list/purchase_order_list_controller.dart';

import '../../../../app/common_widgets/app_bar_widget.dart';
import '../../../../app/common_widgets/app_filter_widget.dart';
import '../../../../app/common_widgets/app_refresh_widget.dart';
import '../../../../app/common_widgets/floating_button.dart';
import '../../../../app/common_widgets/search_widget.dart';
import '../../../../app/constants/app_sizes.dart';
import '../../../../app/constants/images.dart';
import '../../../../app/styles/colors.dart';
import '../../../../core/enums/icon_type.dart';
import '../../../../locator.dart';
import '../../../../router.dart';
import '../../../sales/models/sales_params_request_model/sales_params_request_model.dart';
import '../../../sales/views/widgets/bill_due_summary_card.dart';
import '../../../sales/views/widgets/orders/orders_list_widget.dart';

class PurchaseOrderListView extends ConsumerStatefulWidget {
  const PurchaseOrderListView({super.key});

  @override
  ConsumerState createState() => _PurchaseOrderListViewState();
}

class _PurchaseOrderListViewState extends ConsumerState<PurchaseOrderListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = ref.read(purchaseOrderListControllerProvider.notifier);
      await controller.onInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(purchaseOrderListControllerProvider.notifier);
    final state = ref.watch(purchaseOrderListControllerProvider);
    final isLoading = state.isLoading;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBarWidget.empty(
        title: 'Purchase Orders',
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
            child:const Divider(height: 1,)
        ),
      ),
      floatingActionButton: SafeArea(
        child: FloatingButton(
            label: "New Purchase Order",
            onTap: () async {
              final res = await navigationService.pushNamed(Routes.vendor,
                  arguments: true);
              if (res == null) return;
              navigationService.pushNamed(Routes.purchaseOrder, arguments: SalesParamsRequestModel(

                  billType: BillType.purchaseOrder,
                  clientId: res,
                isVendor: true
              ));
            },
            visibilityOfFloating: controller.visibilityOfFloating),
      ),
      body: Column(
        children: [
          BillDueSummaryCard(
            flex: 0,
            icon: Svgs.invoice,
            title: 'Total Bill',
            totalAmount: controller
                    .purchaseOrderData?.totalValues?.totalBillAmount
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
                ordersList: controller.purchaseOrderList,
                onTap: (i) => controller.openBillPreview(i),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
