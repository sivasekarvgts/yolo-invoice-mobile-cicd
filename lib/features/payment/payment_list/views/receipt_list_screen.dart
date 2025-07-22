import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yoloworks_invoice/app/styles/colors.dart';

import '../../../../app/common_widgets/app_bar_widget.dart';
import '../../../../app/common_widgets/app_filter_widget.dart';
import '../../../../app/common_widgets/app_refresh_widget.dart';
import '../../../../app/common_widgets/floating_button.dart';
import '../../../../app/common_widgets/search_widget.dart';
import '../../../../app/constants/app_sizes.dart';
import 'payment_list_ctrl.dart';
import 'widgets/payment_list_widget.dart';

class ReceiptListScreen extends ConsumerStatefulWidget {
  const ReceiptListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ReceiptListScreenState();
}

class _ReceiptListScreenState extends ConsumerState<ReceiptListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = ref.read(paymentListControllerProvider.notifier);
      await controller.onInit(isReceipt: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(paymentListControllerProvider.notifier);
    final state = ref.watch(paymentListControllerProvider);
    final isLoading = state.isLoading;
    return Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        key: const Key('receiptListScreen'),
        appBar: AppBarWidget.empty(
          title: 'Receipt List',
          onChanged: controller.onSearch,
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
                  iconSize: 20,
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
        floatingActionButton: SafeArea(
          child: FloatingButton(
            key: const Key('receiptListFloatingButton'),
            label: "New Receipt",
            onTap: controller.navigateToPaymentCreate,
            visibilityOfFloating: controller.visibilityOfFloating,
          ),
        ),
        body: AppRefreshWidget(
          onRefresh: () async {
            if (isLoading) return;
            return await controller.fetchData(refresh: true);
          },
          onLoad: () async {
            if (isLoading) return;
            return await controller.fetchData();
          },
          childBuilder: (context, physics) => PaymentListWidget(
            onTap: controller.navigateToPaymentDetails,
            physics: physics,
            isLoading: isLoading,
            paymentList: controller.paymentList,
            scrollController: controller.hideButtonController,

          ),
        ));
  }
}
