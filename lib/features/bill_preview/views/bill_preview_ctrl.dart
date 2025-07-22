import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yoloworks_invoice/core/enums/order_type.dart';
import 'package:yoloworks_invoice/core/extension/currency_extension.dart';

import '../../../app/common_widgets/floating_bottom_nav_fab.dart';
import '../../../app/common_widgets/tab_bar_widget.dart';
import '../../../app/constants/app_sizes.dart';
import '../../../app/constants/images.dart';
import '../../../app/styles/colors.dart';
import '../../../locator.dart';
import '../../../router.dart';

import '../../../services/dialog_service/snackbar_service.dart';
import '../../../services/event_bus_service.dart';
import '../../payment/payment_create/models/payment_params_request_model.dart';
import '../../sales/models/sales_params_request_model/sales_params_request_model.dart';

import 'bill_preview.dart';
import '../data/bill_preview_repository.dart';

import '../models/bill_preview_model.dart';
import '../models/bill_transaction_credit_list_model.dart';
import '../models/bill_transaction_statement_list_model.dart';
import 'widgets/sales_bill_summary_tab.dart';
import 'widgets/sales_payment_list_tab.dart';
import 'widgets/sales_time_line_tab.dart';

part 'bill_preview_ctrl.g.dart';

@riverpod
class BillPreviewCtrl extends _$BillPreviewCtrl {
  @override
  AsyncValue<void> build() {
    return setLoading;
  }

  AsyncValue<void> get setState => state = AsyncValue.data(null);

  AsyncValue<void> get setLoading => state = AsyncValue.loading();

  bool isOpen = true;
  bool loading = false;
  bool tabLoading = true;
  bool isGstTaxHide = false;

  BillPreviewArgs? billPreviewArgs;

  BillPreviewModel? billPreviewModel;
  BillPreviewModel? billPreviewTemplate;
  List<BillTransactionStatementListModel>? timelineList;
  BillTransactionCreditListModel? transactionList;

  late ScrollController scrollController;
  TabController? tabController;
  List<TabItems> tabs = [];
  TickerProvider? vsync;

  List<TabItems> transactionTabs = [];

  List<String> refreshPages = [
    Routes.dashboard,
    Routes.customerDetail,
    Routes.vendorDetail,
    Routes.salesOrderList,
    Routes.salesInvoiceList,
    Routes.purchaseOrderList,
    Routes.purchaseInvoiceList
  ];

  get isAddPayment => ((isSalesInvoice || isPurchaseInvoice) &&
      billPreviewModel?.orderStatusId != 6);

  Future onInit(BillPreviewArgs? _input, TickerProvider _) async {
    billPreviewArgs = _input;
    vsync = _;
    scrollController = ScrollController();
    if (isSalesOrder || isPurchaseOrder) {
      await orderCalls();
    } else {
      await invoiceCall();
    }
    onRefreshEvent();
  }

  Future orderCalls() async {
    await getBillPreview();
    await getBillTemplate();
  }

  Future invoiceCall() async {
    await getBillPreview(isOrder: false);
    await getBillTemplate(isOrder: false);
    await getPayments();
    await getTimelines();
    setTabs();
  }

  void onRefreshEvent() async {
    eventBusService.eventBus.on<PageRefreshEvent>().listen((event) async {
      if (event.pageNames.contains(Routes.billPreview)) if (isSalesOrder ||
          isPurchaseOrder) {
        await orderCalls();
      } else {
        await invoiceCall();
      }
    });
  }

  void setTabs() {
    tabController?.dispose();
    tabs = [
      TabItems(
        tab: BillSummaryTab(),
        title: "Summary",
      ),
    ];

    if (transactionList?.payments?.isNotEmpty == true ||
        transactionList?.credits?.isNotEmpty == true) {
      setTransactionTabs();
      tabs.insert(
        1,
        TabItems(
          tab: SalesTransactionTab(
            noOfTabs: transactionTabs.length,
          ),
          title: "Transactions",
        ),
      );
    }

    if (timelineList?.isNotEmpty == true) {
      tabs.add(TabItems(
        tab: SalesTimeLineTab(),
        title: "Timeline",
      ));
    }

    tabController = TabController(length: tabs.length, vsync: vsync!);
    tabLoading = false;
    setState;
  }

  void setTransactionTabs() {
    transactionTabs.clear();
    if (transactionList?.payments?.isNotEmpty == true) {
      transactionTabs.insert(
        0,
        TabItems(
          tab: SalesPaymentListTab(),
          title: "Payments",
        ),
      );
    }

    if (transactionList?.credits?.isNotEmpty == true) {
      transactionTabs.add(
        TabItems(
          tab: SalesCreditsListTab(),
          title: "Credit Notes",
        ),
      );
    }
  }

  Future getBillPreview({bool isOrder = true}) async {
    try {
      if (isOrder) {
        billPreviewModel = await ref
            .read(billPreviewRepositoryProvider)
            .getBillPreview(orderId);
      } else {
        billPreviewModel = await ref
            .read(billPreviewRepositoryProvider)
            .getInvoiceBillPreview(invoiceId);
      }
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future getBillTemplate({bool isOrder = true}) async {
    try {
      if (isOrder) {
        billPreviewTemplate = await ref
            .read(billPreviewRepositoryProvider)
            .getBillTemplate(orderId);
        billPreviewModel?.breakdown = billPreviewTemplate?.breakdown;
      } else {
        billPreviewTemplate = await ref
            .read(billPreviewRepositoryProvider)
            .getInvoiceBillTemplate(invoiceId);
        billPreviewModel?.breakdown = billPreviewTemplate?.breakdown;
      }
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    setState;
  }

  Future getPayments() async {
    try {
      transactionList = await ref
          .read(billPreviewRepositoryProvider)
          .getTransactions(invoiceId);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    setState;
  }

  Future getTimelines() async {
    try {
      timelineList = await ref
          .read(billPreviewRepositoryProvider)
          .getTransactionStatement(invoiceId);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    setState;
  }

  void openItem() {
    isOpen = !isOpen;
    setState;
  }

  void openFOCItem(int i) {
    final isFocOpen = billPreviewModel?.itemDetails?[i].isFocOpen;
    billPreviewModel?.itemDetails?[i].isFocOpen = !(isFocOpen!);
    setState;
  }

  List get summaryList => [
        {
          'title':
              'Subtotal of ${billPreviewModel?.itemDetails?.length ?? 0} ${(billPreviewModel?.itemDetails?.length ?? 0) > 0 ? "Item" : "Items"}',
          'price': billPreviewModel?.subTotal?.toCurrencyFormatString(),
        },
        if (billPreviewModel?.discountAmount != null &&
            billPreviewModel?.discountAmount != 0.0)
          {
            'title': 'Discount ${billPreviewModel?.discount} %',
            'price': billPreviewModel?.discountAmount?.toCurrencyFormatString(),
          },
        if (billPreviewModel?.adjustment != null &&
            billPreviewModel?.adjustment != 0.0)
          {
            'title': _adjustment.$1,
            'price': _adjustment.$2,
          },
        if (billPreviewModel?.shippingCharge != null &&
            billPreviewModel?.shippingCharge != 0.0)
          {
            'title': 'Shipping Cost',
            'price':
                '${billPreviewModel?.shippingCharge?.toCurrencyFormatString()}',
          },
      ];

  (String, String) get _adjustment {
    final value = billPreviewModel?.customField as Map;

    final entry = value.entries.first;
    return (entry.key, '₹${entry.value}');
  }

  void deletePaymentPopup(Payment payment) async {
    final response = await dialogService.showConfirmationAlertDialog(
      secondaryButton: 'No',
      primaryButton: "Yes",
      title: "Are you sure you want to cancel the Payment?",
    );
    if (response?.status == true) {
      await _deletePayment(payment);
    }
  }

  Future _deletePayment(Payment payment) async {
    loading = true;
    setState;
    try {
      final res = await ref
          .read(billPreviewRepositoryProvider)
          .deletePayment(payment.id ?? 0);
      if (res == null) {
        toastMsg('Payment cancel is failed');
        return;
      }
      toastMsg(res['message'].toString(), false);
      eventBusService.eventBus.fire(PageRefreshEvent(pageNames: refreshPages));
      await invoiceCall();
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    loading = false;
    setState;
  }

  void deleteCreditPopup(Credit credit) async {
    final response = await dialogService.showConfirmationAlertDialog(
      secondaryButton: 'No',
      primaryButton: "Yes",
      title: "Are you sure you want to cancel the credit note?",
    );
    if (response?.status == true) {
      await _deleteCreditNote(credit);
    }
  }

  Future _deleteCreditNote(Credit credit) async {
    loading = true;
    setState;
    try {
      final res = await ref
          .read(billPreviewRepositoryProvider)
          .deleteCreditNote(credit.id ?? 0);
      if (res == null) {
        toastMsg('Credit Note cancel is failed');
        return;
      }
      toastMsg(res['message'].toString(), false);
      eventBusService.eventBus.fire(PageRefreshEvent(pageNames: refreshPages));
      await orderCalls();
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    loading = false;
    setState;
  }

  void deleteOrderPopup() async {
    final response = await dialogService.showConfirmationAlertDialog(
      secondaryButton: 'No',
      primaryButton: "Yes",
      title: "Are you sure you want to delete the order?",
    );
    if (response?.status == true) {
      await _deleteOrder();
    }
  }

  Future _deleteOrder() async {
    loading = true;
    setState;
    try {
      final res =
          await ref.read(billPreviewRepositoryProvider).deleteOrder(orderId);
      if (res == null) {
        toastMsg('Order delete is failed');
        return;
      }
      toastMsg(res['message'].toString(), false);
      eventBusService.eventBus.fire(PageRefreshEvent(pageNames: refreshPages));

      navigationService.pop();
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    loading = false;
    setState;
  }

  void onEdit() {
    if (isSalesInvoice) {
      navigationService.pushNamed(Routes.salesInvoice,
          arguments: SalesParamsRequestModel(
            clientId: billPreviewModel?.clientId,
            edit: true,
            order: invoiceId,
            billType: BillType.salesInvoice,
          ));
      return;
    }

    if (isSalesOrder) {
      navigationService.pushNamed(Routes.salesOrder,
          arguments: SalesParamsRequestModel(
              clientId: billPreviewModel?.clientId,
              edit: true,
              order: orderId,
              billType: BillType.salesOrder));
      return;
    }

    if (isPurchaseInvoice) {
      navigationService.pushNamed(Routes.purchaseInvoice,
          arguments: SalesParamsRequestModel(
              edit: true,
              isVendor: true,
              order: invoiceId,
              clientId: billPreviewModel?.vendorId,
              billType: BillType.purchaseInvoice));
      return;
    }

    if (isPurchaseOrder) {
      navigationService.pushNamed(Routes.purchaseOrder,
          arguments: SalesParamsRequestModel(
              edit: true,
              isVendor: true,
              order: orderId,
              clientId: billPreviewModel?.vendorId,
              billType: BillType.purchaseOrder));
      return;
    }
  }

  Future<void> onConvert() async {
    //
    // final response = await dialogService.showConfirmationAlertDialog(
    //   secondaryButton: 'No',
    //   primaryButton: "Yes",
    //   title: "Are you sure you want to delete the order?",
    // );
    // if (response?.status == true) {
    //   await _deleteOrder();
    // }
    navigationService.pushNamed(Routes.salesInvoice,
        arguments: SalesParamsRequestModel(
            clientId: billPreviewModel?.clientId,
            covert: true,
            order: orderId,
            billType: BillType.salesOrder));
  }

  int get orderId => billPreviewArgs?.orderId ?? 0;
  int get invoiceId => billPreviewArgs?.invoiceId ?? 0;

  bool get isSalesOrder => billPreviewArgs?.isSalesOrder == true;
  bool get isSalesInvoice => billPreviewArgs?.isSalesInvoice == true;

  bool get isPurchaseOrder => billPreviewArgs?.isPurchaseOrder == true;
  bool get isPurchaseInvoice => billPreviewArgs?.isPurchaseInvoice == true;

  Future navigateToPaymentCreate() async {
    await navigationService.pushNamed(
      Routes.paymentCreate,
      arguments: PaymentParamsRequestModel(
          clientId: billPreviewModel?.clientId,
          billDetail: billPreviewModel,
          billType: isPurchaseOrder
              ? BillType.paymentMade
              : BillType.paymentReceived),
    );
    //TODOs
    //refresh need to call
    //remove manual refresh
    //add event refresh
    // await invoiceCall();
  }

  void onOpenTax() {
    isGstTaxHide = !isGstTaxHide;
    setState;
  }

  void showDialog() {
    dialogService.showPositionedAlertDialog(
      right: 16,
      bottom: 100,
      width: 180.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoCreateItemWidget(
            icon: isSalesInvoice ? Svgs.receipt : Svgs.paymentSent,
            onTap: () {
              navigateToPaymentCreate();
            },
            title: isSalesInvoice ? "Add Receipt" : "Add Payment",
          ),
          gapH4,
          Divider(
            thickness: 1,
            color: AppColors.greyColor300,
          ),
          gapH4,
          CupertinoCreateItemWidget(
            onTap: () {
              onEdit();
            },
            title: "Add Credit",
            icon: Svgs.transaction,
          )
        ],
      ),
    );
  }

  void toastMsg(String msg, [bool isFailed = true]) {
    SnackbarService.toastMsg(msg, isFailed);
  }
}
