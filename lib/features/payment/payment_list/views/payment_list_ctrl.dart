import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yoloworks_invoice/app/common_widgets/hide_floating.dart';
import 'package:yoloworks_invoice/core/enums/order_type.dart';
import 'package:yoloworks_invoice/core/extension/datetime_extension.dart';

import '../../../../app/common_widgets/app_filter_widget.dart';
import '../../../../app/common_widgets/button.dart';
import '../../../../core/models/client_vendor_request_model.dart';
import '../../../../locator.dart';
import '../../../../router.dart';
import '../../../../services/dialog_service/alert_response.dart';
import '../../../../services/event_bus_service.dart';
import '../../../../utils/debounce.dart';
import '../../payment_create/models/payment_params_request_model.dart';
import '../data/payment_list_repository.dart';
import '../models/payment_list_model.dart';

part 'payment_list_ctrl.g.dart';

@riverpod
class PaymentListController extends _$PaymentListController with HideFloating {
  @override
  AsyncValue<void> build() {
    return AsyncValue.loading();
  }

  AsyncValue<void> get setState => state = AsyncValue.data(null);

  AsyncValue<void> get setLoading => state = AsyncValue.loading();

  final searchTextCtrl = TextEditingController();

  bool showSearchBar = false;
  DateTimeRange? selectedDateRange = AppDateConstant().currentMonthRange;

  bool isPurchase = false;

  PaymentListModel? paymentListData;
  List<PaymentDatum> paymentList = [];

  Future<void> onInit({bool isReceipt = false}) async {
    isPurchase = !isReceipt;
    hideButtonController = ScrollController();
    await fetchData(refresh: true);
    onRefreshEvent();
  }

  void onRefreshEvent() async {
    eventBusService.eventBus.on<PageRefreshEvent>().listen((event) async {
      if (event.pageNames.contains(Routes.paymentList) ||
          event.pageNames.contains(Routes.receiptList))
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

  void onOpenSearch() {
    showSearchBar = true;
    setState;
  }

  Future onSearch(String query) async {
    Debounce.debounce('payment-bill-search', () async {
      await fetchData(refresh: true);
    });
  }

  Future fetchData({bool refresh = false, bool isDateFilter = false}) async {
    if (refresh) {
      paymentListData = null;
      paymentList.clear();
      setLoading;
    }

    int numPages = (paymentListData?.numPages ?? 1);
    int currentPage = (paymentListData?.currentPage ?? 0);
    if (currentPage >= numPages) {
      IndicatorResult.none;
      setState;
      return;
    }

    try {
      paymentListData = await ref
          .read(paymentListRepoProvider)
          .getPaymentList(ClientVendorRequestModel(
            page: currentPage + 1,
            search: searchTextCtrl.text,
            addVendor: isPurchase,
            addClient: !isPurchase,
            startDate:
                selectedDateRange?.start.toFormattedYearMonthDate() ?? '',
            endDate: selectedDateRange?.end.toFormattedYearMonthDate() ?? '',
          ));
      paymentList.addAll(paymentListData?.data ?? []);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    setState;
  }

  Future navigateToPaymentCreate() async {
    final res =
        await navigationService.pushNamed(isPurchase?Routes.vendor:Routes.customer, arguments: true);
    if (res == null) return;
    navigationService.pushNamed(
        isPurchase ? Routes.vendorPaymentCreate : Routes.paymentCreate,
        arguments: PaymentParamsRequestModel(
            clientId: res,
            isVendor: isPurchase,
            billType:
                isPurchase ? BillType.paymentMade : BillType.paymentReceived));
  }

  Future navigateToPaymentDetails(int i) async {
    navigationService.pushNamed(Routes.paymentDetail,
        arguments: {'id': paymentList[i].id, 'is_purchase': isPurchase});

  }
}
