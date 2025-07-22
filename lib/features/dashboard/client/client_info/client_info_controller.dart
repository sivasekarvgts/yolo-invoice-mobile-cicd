import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yoloworks_invoice/app/common_widgets/app_filter_widget.dart';
import 'package:yoloworks_invoice/app/common_widgets/button.dart';
import 'package:yoloworks_invoice/app/constants/images.dart';
import 'package:yoloworks_invoice/core/enums/order_type.dart';
import 'package:yoloworks_invoice/core/extension/datetime_extension.dart';
import 'package:yoloworks_invoice/features/dashboard/client/client_info/widgets/analytics_tab.dart';
import 'package:yoloworks_invoice/features/dashboard/client/client_info/widgets/client_invoice_list_tab.dart';
import 'package:yoloworks_invoice/features/dashboard/client/client_info/widgets/client_payment_tab.dart';
import 'package:yoloworks_invoice/features/dashboard/client/client_info/widgets/client_transaction_list_tab.dart';
import 'package:yoloworks_invoice/features/dashboard/client/client_info/widgets/statement_tab.dart';
import 'package:yoloworks_invoice/features/dashboard/models/transaction_statement_list_model.dart';
import 'package:yoloworks_invoice/features/purchase/data/purchase_invoice_repository.dart';
import 'package:yoloworks_invoice/features/sales/data/sales_invoice_repository.dart';

import '../../../../app/common_widgets/floating_bottom_nav_fab.dart';
import '../../../../app/common_widgets/tab_bar_widget.dart';
import '../../../../app/constants/app_sizes.dart';
import '../../../../app/styles/colors.dart';
import '../../../../app/styles/text_styles.dart';
import '../../../../core/enums/user_type.dart';
import '../../../../core/models/client_vendor_request_model.dart';
import '../../../../locator.dart';
import '../../../../router.dart';
import '../../../../services/dialog_service/alert_response.dart';
import '../../../../services/event_bus_service.dart';
import '../../../bill_preview/views/bill_preview.dart';
import '../../../payment/payment_list/data/payment_list_repository.dart';
import '../../../payment/payment_list/models/payment_list_model.dart';
import '../../../sales/models/invoice/invoice_list_model.dart';
import '../../../sales/models/sales_params_request_model/sales_params_request_model.dart';
import '../../data/transaction_repository.dart';

part 'client_info_controller.g.dart';

part 'package:yoloworks_invoice/features/dashboard/customer/customer_info/customer_info_controller.dart';

part 'package:yoloworks_invoice/features/dashboard/vendor/vendor_info/vendor_info_controller.dart';

@riverpod
class ClientInfoController extends _$ClientInfoController {
  @override
  AsyncValue<void> build() {
    return AsyncValue.loading();
  }

  AsyncValue<void> get setState => state = AsyncValue.data(null);

  AsyncValue<void> get setLoading => state = AsyncValue.loading();

  TransactionStatementListModel? transactionData;
  InvoiceListModel? invoiceData;
  List<InvoiceList> invoiceList = [];
  PaymentListModel? paymentData;
  List<PaymentDatum> paymentList = [];

  int clientId = 0;
  UsersType? usersType;

  DateTimeRange? selectedDateRange = AppDateConstant().currentMonthRange;

  ScrollController scrollController = ScrollController();

  bool showTitle = false;
  TickerProvider? vsync;

  // USE ON CONTROLLERS
  int index = 0;

  List<TabItems> tabs = [
    TabItems(tab: AnalyticsTab(), title: "Analytics", svg: Svgs.analytics),
    TabItems(tab: StatementTab(), title: "Statement", svg: Svgs.transaction),
  ];

  List<TabItems> analyticsTabs = [
    TabItems(
      tab: ClientTransactionListTab(),
      title: "Transaction",
    ),
    TabItems(
      tab: ClientInvoiceListTab(),
      title: "Invoice",
    ),
    TabItems(
      tab: ClientPaymentTab(),
      title: "Payment",
    ),
  ];

  Future<void> onInit(
    UsersType _usersType,
    int _customerId,
  ) async {
    usersType = _usersType;
    clientId = _customerId;

    await refreshCalls(refresh: true);
    onRefreshEvent();
  }

  void onRefreshEvent() async {
    eventBusService.eventBus.on<PageRefreshEvent>().listen((event) async {
      if (event.pageNames.contains(Routes.vendorDetail)||event.pageNames.contains(Routes.customerDetail))
        await refreshCalls(refresh: event.isRefresh);
    });
  }

  Future refreshCalls({
    required bool refresh,
  }) async {
    await fetchData(refresh: refresh);
    await fetchInvoiceList(refresh: refresh);
    await fetchPaymentList(refresh: refresh);
  }

  Future fetchData({bool refresh = false}) async {
    if (usersType == UsersType.customer) {
      await fetchClientTransactionStatement(refresh: refresh);
      return;
    }
    await fetchVendorTransactionStatement(refresh: refresh);
  }

  Future fetchInvoiceList({bool refresh = false}) async {
    if (usersType == UsersType.customer) {
      await fetchSalesInvoiceList(refresh: refresh);
      return;
    }
    await fetchPurchaseInvoiceList(refresh: refresh);
  }

  Future fetchPaymentList({
    bool refresh = false,
  }) async {
    if (refresh) {
      paymentData = null;
      paymentList.clear();
      if (index == 2) setLoading;
    }
    int numPages = (paymentData?.numPages ?? 1);
    int currentPage = (paymentData?.currentPage ?? 0);
    if (currentPage >= numPages) {
      setState;
      return IndicatorResult.none;
    }

    try {
      paymentData = await ref
          .read(paymentListRepoProvider)
          .getPaymentList(ClientVendorRequestModel(
            page: currentPage + 1,
            id: clientId,
            addClient: usersType == UsersType.customer,
            addVendor: usersType == UsersType.vendor,
            // search: searchTextCtrl.text,
            startDate:
                selectedDateRange?.start.toFormattedYearMonthDate() ?? '',
            endDate: selectedDateRange?.end.toFormattedYearMonthDate() ?? '',

            // isDateFilter: isDateFilter
          ));
      paymentList.addAll(paymentData?.data ?? []);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    setState;
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
          await refreshCalls(
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

  Future detailView(int id) async {
    String route = Routes.customerDetail;
    if (usersType == UsersType.vendor) route = Routes.vendorDetail;
    final res = await navigationService.pushNamed(route, arguments: id);
    if (res == true) await fetchData(refresh: true);
  }


  void showDialog() {
    dialogService.showPositionedAlertDialog(
      right: 16,
      bottom: 100,
      width: 150.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoCreateItemWidget(
            icon: Svgs.invoice,
            onTap: () {
              final String route = usersType == UsersType.customer?Routes.salesInvoice:Routes.purchaseInvoice;

              navigationService
                  .pushNamed(route,
                  arguments: SalesParamsRequestModel(
                    clientId: clientId,
                    billType: usersType == UsersType.customer?BillType.salesInvoice:BillType.purchaseInvoice,
                  ))
              ;
            },
            title: "Invoice",
          ),
          gapH4,
          Divider(
            thickness: 1,
            color: AppColors.greyColor300,
          ),
          gapH4,
          CupertinoCreateItemWidget(
            onTap: () {
              final String route = usersType == UsersType.customer?Routes.salesOrder:Routes.purchaseOrder;
              navigationService
                  .pushNamed(route,
                  arguments:
                  SalesParamsRequestModel(
                      clientId: clientId,
                      billType: usersType == UsersType.customer?BillType.salesOrder:BillType.purchaseOrder,isVendor :usersType == UsersType.vendor ));
            },
            title: "Order",icon: Svgs.order,
          ),gapH4,
          Divider(
            thickness: 1,
            color: AppColors.greyColor300,
          ),
          gapH4,
          CupertinoCreateItemWidget(
            onTap: () {
              final String route = usersType == UsersType.customer?Routes.paymentCreate:Routes.paymentCreate;
              navigationService
                  .pushNamed(route,
                  arguments: {'client_id': clientId});

            },
            title: "Payment",
            icon: usersType == UsersType.customer?Svgs.paymentSent:Svgs.receipt ,
          ),
        ],
      ),
    );
  }

}
