import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yoloworks_invoice/core/enums/order_type.dart';
import 'package:yoloworks_invoice/core/extension/datetime_extension.dart';

import '../../../../../app/common_widgets/hide_floating.dart';
import '../../../../../core/models/client_vendor_request_model.dart';
import '../../../../../locator.dart';
import '../../../../../router.dart';
import '../../../../../utils/debounce.dart';
import '../../../../app/common_widgets/app_filter_widget.dart';
import '../../../../app/common_widgets/button.dart';
import '../../../../services/dialog_service/alert_response.dart';
import '../../../../services/event_bus_service.dart';
import '../../../bill_preview/views/bill_preview.dart';
import '../../../sales/models/invoice/invoice_list_model.dart';
import '../../../sales/models/sales_params_request_model/sales_params_request_model.dart';
import '../../data/purchase_invoice_repository.dart';

part 'purchase_invoice_list_controller.g.dart';

@riverpod
class PurchaseInvoiceListController extends _$PurchaseInvoiceListController
    with HideFloating {
  @override
  AsyncValue<void> build() {
    return AsyncValue.loading();
  }

  AsyncValue<void> get setState => state = AsyncValue.data(null);

  AsyncValue<void> get setLoading => state = AsyncValue.loading();

  InvoiceListModel? purchaseInvoiceData;

  List<InvoiceList> purchaseInvoiceList = [];
  final searchTextCtrl = TextEditingController();

  bool showSearchBar = false;
  DateTimeRange? selectedDateRange = AppDateConstant().currentMonthRange;

  Future<void> onInit() async {
    hideButtonController = ScrollController();
    // onInvoiceOrderRefreshEvent();
    await fetchData(refresh: true);
    onRefreshEvent();

  }

  void onRefreshEvent() async {
    eventBusService.eventBus.on<PageRefreshEvent>().listen((event) async {
      if (event.pageNames.contains(Routes.purchaseInvoiceList))
        await fetchData(refresh: event.isRefresh);
    });
  }


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

  Future onSearchInvoice(String query) async {
    Debounce.debounce('invoice-bill-search', () async {
      await fetchData(refresh: true);
    });
  }

  void onClearDateFilter() async {
    navigationService.pop();
    selectedDateRange = null;
    purchaseInvoiceData = null;
    await fetchData();
  }

  Future fetchData({bool refresh = false, bool isDateFilter = false}) async {
    if (refresh) {
      purchaseInvoiceData = null;
      purchaseInvoiceList.clear();
      setLoading;
    }

    int numPages = (purchaseInvoiceData?.numPages ?? 1);
    int currentPage = (purchaseInvoiceData?.currentPage ?? 0);
    if (currentPage >= numPages) {
      setState;
      return IndicatorResult.none;
    }

    try {
      purchaseInvoiceData = await ref
          .read(purchaseInvoiceRepositoryProvider)
          .getPurchaseInvoiceList(ClientVendorRequestModel(
            page: currentPage + 1,
            search: searchTextCtrl.text,
            startDate:
                selectedDateRange?.start.toFormattedYearMonthDate() ?? '',
            endDate: selectedDateRange?.end.toFormattedYearMonthDate() ?? '',
            // isDateFilter: isDateFilter
          ));
      purchaseInvoiceList.addAll(purchaseInvoiceData?.data ?? []);
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
    final purchase = purchaseInvoiceList[i];
    navigationService.pushNamed(Routes.billPreview,
        arguments: BillPreviewArgs(
          invoiceId: purchase.id,
          isPurchaseInvoice: true,
        ));
  }

  void navigatePurchaseInvoice() async {
    final res =
        await navigationService.pushNamed(Routes.vendor, arguments: true);
    if (res == null) return;
    navigationService.pushNamed(Routes.purchaseInvoice,
        arguments: SalesParamsRequestModel(
            isVendor: true,
            clientId: res,
            billType: BillType.purchaseInvoice));
  }
}
