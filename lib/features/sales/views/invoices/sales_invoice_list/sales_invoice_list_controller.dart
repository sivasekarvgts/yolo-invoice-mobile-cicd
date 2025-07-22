import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yoloworks_invoice/core/enums/order_type.dart';
import 'package:yoloworks_invoice/core/extension/datetime_extension.dart';

import '../../../../../app/common_widgets/app_filter_widget.dart';
import '../../../../../app/common_widgets/button.dart';
import '../../../../../app/common_widgets/hide_floating.dart';
import '../../../../../core/models/client_vendor_request_model.dart';
import '../../../../../locator.dart';
import '../../../../../router.dart';
import '../../../../../services/dialog_service/alert_response.dart';
import '../../../../../services/event_bus_service.dart';
import '../../../../../utils/debounce.dart';
import '../../../../bill_preview/views/bill_preview.dart';
import '../../../data/sales_invoice_repository.dart';
import '../../../models/invoice/invoice_list_model.dart';
import '../../../models/sales_params_request_model/sales_params_request_model.dart';

part 'sales_invoice_list_controller.g.dart';

@riverpod
class SalesInvoiceListController extends _$SalesInvoiceListController
    with HideFloating {
  @override
  AsyncValue<void> build() {
    return AsyncValue.loading();
  }

  AsyncValue<void> get setState => state = AsyncValue.data(null);

  AsyncValue<void> get setLoading => state = AsyncValue.loading();

  InvoiceListModel? salesInvoiceData;

  List<InvoiceList> salesInvoiceList = [];
  final searchTextCtrl = TextEditingController();

  bool showSearchBar = false;
  DateTimeRange? selectedDateRange = AppDateConstant().currentMonthRange;

  Future<void> onInit() async {
    hideButtonController = ScrollController();
    await fetchData(refresh: true);
   onRefreshEvent();
  }
  void onRefreshEvent() async {
    eventBusService.eventBus.on<PageRefreshEvent>().listen((event) async {
      if (event.pageNames.contains(Routes.salesInvoiceList))
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
    salesInvoiceData = null;
    await fetchData();
  }

  Future fetchData({
    bool refresh = false,
  }) async {
    if (refresh) {
      salesInvoiceData = null;
      salesInvoiceList.clear();
      setLoading;
    }

    int numPages = (salesInvoiceData?.numPages ?? 1);
    int currentPage = (salesInvoiceData?.currentPage ?? 0);
    if (currentPage >= numPages) {
      setState;
      return IndicatorResult.none;
    }

    try {
      salesInvoiceData = await ref
          .read(salesInvoiceRepositoryProvider)
          .getSalesInvoiceList(ClientVendorRequestModel(
            page: currentPage + 1,
            search: searchTextCtrl.text,
            startDate:
                selectedDateRange?.start.toFormattedYearMonthDate() ?? '',
            endDate: selectedDateRange?.end.toFormattedYearMonthDate() ?? '',
            // isDateFilter: isDateFilter
          ));
      salesInvoiceList.addAll(salesInvoiceData?.data ?? []);
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
    final sales = salesInvoiceList[i];
    navigationService.pushNamed(Routes.billPreview,
        arguments: BillPreviewArgs(invoiceId: sales.id,isSalesInvoice: true));
  }

  void navigateSalesInvoice() async {
    final res =
        await navigationService.pushNamed(Routes.customer, arguments: true);
    if (res == null) return;
    navigationService.pushNamed(Routes.salesInvoice,
        arguments: SalesParamsRequestModel(
            clientId: res, billType: BillType.salesInvoice));
  }
}
