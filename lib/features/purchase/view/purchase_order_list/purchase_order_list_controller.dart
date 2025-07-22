import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yoloworks_invoice/app/common_widgets/hide_floating.dart';
import 'package:yoloworks_invoice/core/extension/datetime_extension.dart';
import 'package:yoloworks_invoice/features/bill_preview/views/bill_preview.dart';
import 'package:yoloworks_invoice/locator.dart';

import '../../../../app/common_widgets/app_filter_widget.dart';
import '../../../../app/common_widgets/button.dart';
import '../../../../core/models/client_vendor_request_model.dart';
import '../../../../router.dart';
import '../../../../services/dialog_service/alert_response.dart';
import '../../../../services/event_bus_service.dart';
import '../../../../utils/debounce.dart';
import '../../../sales/models/sales_order/sales_order_list_model.dart';
import '../../data/purchase_order_repository.dart';

part 'purchase_order_list_controller.g.dart';

@riverpod
class PurchaseOrderListController extends _$PurchaseOrderListController
    with HideFloating {
  @override
  AsyncValue<void> build() {
    return AsyncValue.loading();
  }

  AsyncValue<void> get setState => state = AsyncValue.data(null);

  AsyncValue<void> get setLoading => state = AsyncValue.loading();

  OrderListModel? purchaseOrderData;
  List<OrderListItem> purchaseOrderList = [];
  final searchTextCtrl = TextEditingController();

  bool showSearchBar = false;
  DateTimeRange? selectedDateRange = AppDateConstant().currentMonthRange;

  Future<void> onInit() async {
    hideButtonController = ScrollController();
    // onPurchaseOrderRefreshEvent();
    await fetchData(refresh: true);
    onRefreshEvent();
  }

  void onRefreshEvent() async {
    eventBusService.eventBus.on<PageRefreshEvent>().listen((event) async {
      if (event.pageNames.contains(Routes.purchaseOrderList))
        await fetchData(refresh: event.isRefresh);
    });
  }

  // void onPurchaseOrderRefreshEvent() async {
  //   eventBusService.eventBus
  //       .on<SalesOrderRefreshEvent>()
  //       .listen((event) async {
  //     await fetchData(refresh: event.isRefresh == true);
  //   });
  // }

  void showFilter() async {
    DateTimeRange? range = selectedDateRange;
    final res = await dialogService.showBottomSheet(
        title: 'Filters',
        showCloseIcon: false,
        iconWidget: AppButton("Apply",
            padding: EdgeInsets.zero,
            width: 70.w,
            height: 28.h,
            fullSize: false,
            key: Key("apply"), onPressed: () async {
          dialogService.dialogComplete(AlertResponse(status: true));
          selectedDateRange = range;
          await fetchData(
            refresh: true,
          );
        }),
        child: showFilterWidget(
          selectedDateRange: range,
          onDateRangePicked: (v) {
            range = v;
          },
        ));
    print('res $res');
  }

  Future onSearchOrder(String query) async {
    Debounce.debounce('order-bill-search', () async {
      await fetchData(refresh: true);
    });
  }

  Future fetchData({bool refresh = false, bool isDateFilter = false}) async {
    if (refresh) {
      purchaseOrderData = null;
      purchaseOrderList.clear();
      setLoading;
    }

    int numPages = (purchaseOrderData?.numPages ?? 1);
    int currentPage = (purchaseOrderData?.currentPage ?? 0);
    if (currentPage >= numPages) {
      setState;
      return IndicatorResult.none;
    }

    try {
      purchaseOrderData = await ref
          .read(purchaseOrderRepositoryProvider)
          .getPurchaseOrderList(
              input: ClientVendorRequestModel(
            page: currentPage + 1,
            search: searchTextCtrl.text,
            startDate:
                selectedDateRange?.start.toFormattedYearMonthDate() ?? '',
            endDate: selectedDateRange?.end.toFormattedYearMonthDate() ?? '',
          ));
      purchaseOrderList.addAll(purchaseOrderData?.orderList ?? []);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    setState;
  }

  void onOpenSearch() {
    showSearchBar = true;
    setState;
  }

  void openBillPreview(int i) {
    final purchase = purchaseOrderList[i];
    navigationService.pushNamed(Routes.billPreview,
        arguments: BillPreviewArgs(orderId: purchase.id,isPurchaseOrder: true));
  }
}
