import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vgts_plugin/form/utils/input_validator.dart';
import 'package:yoloworks_invoice/core/extension/currency_extension.dart';

import '../../api/customer_request.dart';
import '../../api/master_data_api_request.dart';
import '../../api/payment_request.dart';
import '../../app/constants/app_constants.dart';
import '../../core/enums/order_type.dart';
import '../../core/extension/datetime_extension.dart';

import '../../features/bill_preview/models/bill_preview_model.dart';
import '../../features/charts_of_account/models/charts_of_accounts_list_model.dart';
import '../../features/charts_of_account/views/widgets/charts_of_account_widget.dart';
import '../../features/dashboard/data/customer_repository.dart';
import '../../features/dashboard/models/customer/customer_detail_model.dart';
import '../../features/dashboard/view/dashboard_controller.dart';
import '../../features/payment/payment_create/data/payment_create_repo.dart';
import '../../features/payment/payment_create/models/payment_mode_list.dart';
import '../../features/payment/payment_create/models/payment_retrieve_model.dart';
import '../../features/payment/payment_create/models/payment_due_invoice_model.dart';
import '../../features/payment/payment_create/models/payment_params_request_model.dart';
import '../../features/payment/payment_create/views/client_payment/payment_create_ctrl.dart';
import '../../features/payment/payment_create/views/vendor_payment/vendor_payment_create_ctrl.dart';
import '../../features/payment/payment_create/views/widgets/payment_mode_widget.dart';
import '../../features/sales/data/master_data_repository.dart';

import '../../locator.dart';
import '../../router.dart';
import '../../utils/debounce.dart';
import '../date_picker_service.dart';
import '../dialog_service/alert_response.dart';
import '../dialog_service/snackbar_service.dart';

mixin PaymentMasterServices {
  final customerRepo = CustomerRepository(customerRequest: CustomerRequest());
  final masterRepo =
      MasterDataRepository(masterDataApiRequest: MasterDataApiRequest());
  final paymentCreateRepo = PaymentCreateRepo(
      paymentRequest: PaymentRequest(),
      masterDataApiRequest: MasterDataApiRequest());

  Ref<AsyncValue<void>>? reference;
  PaymentParamsRequestModel? paramsReq;

  String? billNo;
  DateTime? billDate;
  String? chequeNoError;
  String? chequeDateError;
  String? accountsError;
  String? billDateError;
  String? receivedAmtError;
  String? paymentModeError;
  DateTime? chequeDateTime;
  String totalPayableAmt = '';

  BillPreviewModel? billDetail;
  CustomerDetailModel? customerData;
  PaymentRetrieveModel? paymentRetrieveModel;
  List<PaymentModeList> paymentModeList = [];
  PaymentModeList selectPaymentMode = PaymentModeList();
  List<PaymentInvoice> paymentDueInvoiceList = [];

  bool isPayFullAmt = false;
  bool isBulkPayment = false;
  bool isOpenInvoices = true;
  bool paymentLoading = false;

  final paymentFormKey = GlobalKey<FormState>();

  //accounts
  NodesList? selectedAccountItem;
  final accountsTextCtrl = TextEditingController();

  //text-ctrl
  final notesTextEditing = TextEditingController();
  final refNoTextEditing = TextEditingController();
  final amtUsedTextEditing = TextEditingController();
  final billDateTextEditing = TextEditingController();
  final receivedTextEditing = TextEditingController();
  final chequeNoTextEditing = TextEditingController();
  final excessAmtTextEditing = TextEditingController();
  final transferIdTextEditing = TextEditingController();
  final chequeDateTextEditing = TextEditingController();
  final referenceNoTextEditing = TextEditingController();
  final paymentModeTextEditing = TextEditingController();
  final transactionTextEditing = TextEditingController();

  Future init(Ref<AsyncValue<void>>? riverpodRef, PaymentParamsRequestModel? data) async {
    reference = riverpodRef;
    paramsReq = data;

    // only added arg
    billDetail = paramsReq?.billDetail;
    notesTextEditing.text = paramsReq?.notes ?? '';
    billDate = DateTime.now();
    billDateTextEditing.text =
        DateFormates.monthDayYearFormat.format(billDate!);
    await getInfo();
    _setPaidAmt();
  }

  Future getInfo() async {
    await getCustomerInfo(clientId);
    if (billDetail == null) {
      await getPaymentDueInvoices(clientId);
    }

    await getPaymentMode();
    await getBillNo();
    if (isEdit) await getPaymentRetrieve(billId);
  }

  Future getCustomerInfo(int clientId) async {
    try {
      customerData = isVendor
          ? await customerRepo.getVendorInfo(id: clientId)
          : await customerRepo.getCustomerInfo(id: clientId);
    } catch (e, s) {
      debugPrint('exception $e, stack-trace $s');
    }
  }

  Future getBillNo() async {
    if (isEdit) return;
    try {
      final res = await masterRepo.getBillNoGenerator(
          type: paramsReq?.billType.choice ?? 0);
      if (res == null) return;
      billNo = isVendor ? res["Payment_number"] : res['Receipt_number'];
    } catch (e, s) {
      debugPrint('exception $e, stack-trace $s');
    }
  }

  Future getPaymentMode() async {
    try {
      final res = await paymentCreateRepo.getPaymentModeList();
      paymentModeList = res;
    } catch (e, s) {
      debugPrint('exception $e, stack-trace $s');
    }
  }

  Future getPaymentDueInvoices(int client) async {
    try {
      final res =
          await paymentCreateRepo.getPaymentDueInvoices(client, isVendor);
      paymentDueInvoiceList = res.data ?? [];
    } catch (e, s) {
      debugPrint('exception $e, stack-trace $s');
    }
  }

  Future getPaymentRetrieve(int id) async {
    try {
      final res = await paymentCreateRepo.getPaymentRetrieve(id);
      paymentRetrieveModel = res;
      _onLoadData(res);
    } catch (e, s) {
      debugPrint('exception $e, stack-trace $s');
    }
  }

  void _onLoadData(PaymentRetrieveModel res) {
    billNo = res.paymentNumber;
    referenceNoTextEditing.text =
        res.referenceNumber != null ? res.referenceNumber.toString() : '';
    billDate = res.date;
    billDateTextEditing.text = res.billDateFormat;
    chequeDateTime = res.chequeDate;
    chequeNoTextEditing.text = res.chequeNumber??"";
    chequeDateTextEditing.text = res.chequeDateFormat;
    transferIdTextEditing.text = res.transactionId ?? '';
    paymentModeTextEditing.text = res.paymentModeName ?? '';
    selectPaymentMode =
        paymentModeList.where((t) => t.id == res.paymentMode).last;
    amtUsedTextEditing.text = res.usedAmt;
    excessAmtTextEditing.text = res.excessAmt;
    receivedTextEditing.text = res.receivedAmt;
    if (res.account != null) {
      final nodesList = chartsAccountsList.first.nodesList
          ?.where((t) => t.id == res.account)
          .toList();
      final value = nodesList?.isEmpty == true
          ? chartsAccountsList.first.nodesList
              ?.map((r) => r.nodeListChildren)
              .expand((e) => e ?? <NodesList>[])
              .where((t) => t.id == res.account)
              .toList()
          : nodesList;
      if (value != null && value.isNotEmpty) {
        selectedAccountItem = value.first;
        accountsTextCtrl.text = selectedAccountItem?.name ?? '';
      }
    }
    _mapInvoices(res.invoiceDetails ?? []);
    updateNotifier();
  }

  void _mapInvoices(List<InvoiceDetail> invoiceDetails) {
    List<InvoiceDetail> addedDueInvoices = [];

    invoiceDetails.forEach((r) {
      final index = paymentDueInvoiceList.indexWhere(
          (t) => t.id == r.invoice || t.invoiceNumber == r.invoiceNumber);
      if (index < 0) {
        addedDueInvoices.add(r);
      }
    });
    final invoices = addedDueInvoices.map((n) {
      Map<String, dynamic> invoiceJson = n.toJson();
      invoiceJson['id'] = invoiceJson['invoice'];
      return PaymentInvoice.fromJson(invoiceJson);
    }).toList();

    paymentDueInvoiceList.insertAll(0, invoices);
    paymentDueInvoiceList.forEach((e) {
      final index = invoiceDetails.indexWhere(
          (t) => t.invoice == e.id || t.invoiceNumber == e.invoiceNumber);
      if (index >= 0) {
        final item = invoiceDetails[index];
        e.id = item.invoice;
        e.amount = item.amount;
        e.balanceDue = item.balanceDue;
        e.total = item.total;
        e.receivedAmt = e.amount;
        e.textCtrlValue?.text =
            e.amount != null ? e.amount!.toCurrencyFormatString() : '';
      }
    });
  }

  void _setPaidAmt() {
    double totalAmt;

    if (paymentDueInvoiceList.isEmpty) {
      totalAmt = billDetail?.balanceDue ?? 0.0;
    } else {
      totalAmt = paymentDueInvoiceList
          .map((e) => e.balanceDue ?? 0.0)
          .fold(0.0, (sum, item) => sum + item);
    }

    totalPayableAmt = totalAmt.toCurrencyFormatString();
  }

  void onReceivedFieldChange(String value) {
    Debounce.debounce('payment-text-field', () {
      paymentDueInvoiceList =
          getInvoiceList(receivedAmount(AppConstants.textSymbolRemover(value)));
      debugPrint('invoiceList $paymentDueInvoiceList');
      excessAmtTextEditing.text = receivedAmount(null) > totalAmount()
          ? (totalAmount() - receivedAmount(null))
              .abs()
              .toCurrencyFormatString()
          : '0';
      amtUsedTextEditing.text = invoiceReceivedAmt.toCurrencyFormatString();
      onValidate();
    });
  }

  void onInvoiceDueChange(String value, int index) {
    Debounce.debounce('invoice-due', () {
      if (receivedTextEditing.text.isEmpty) {
        toastMsg("Please enter the Received amount");
        for (var e in paymentDueInvoiceList) {
          e.receivedAmt = 0;
          e.textCtrlValue?.text = '';
        }
        updateNotifier;
        return;
      }

      final invoice = paymentDueInvoiceList[index];
      final invoiceReceivedAmt =
          double.parse(AppConstants.textSymbolRemover(value));
      if (value.replaceAll('₹', '').isEmpty) {
        invoice.receivedAmt = 0;
        invoice.textCtrlValue?.text = '';
        _adjustExcessAmount(invoice.balanceDue ?? 0, invoiceReceivedAmt);
        updateNotifier();
        return;
      }

      final balanceDue = double.parse('${invoice.balanceDue ?? 0.0}');

      if (invoiceReceivedAmt > balanceDue) {
        invoice.textCtrlValue?.text = balanceDue.toCurrencyFormatString();
        invoice.receivedAmt = balanceDue;
        //excess amount
        _adjustExcessAmount(invoice.balanceDue ?? 0, balanceDue);
        updateNotifier;
        return;
      }

      invoice.receivedAmt = invoiceReceivedAmt;
      //excess amount
      _adjustExcessAmount(invoice.balanceDue ?? 0, invoiceReceivedAmt);
      updateNotifier;
    });
  }

  void _adjustExcessAmount(double balanceAmt, double receivedAmt) {
    final invoiceAmt = invoiceReceivedAmt;
    final receivedTotalAmt = receivedAmount(null);
    double excessAmt = receivedTotalAmt > totalAmount()
        ? (totalAmount() - receivedAmount(null)).abs()
        : 0;

    if (invoiceAmt == 0) {
      excessAmt = receivedTotalAmt;
    }

    if (receivedTotalAmt < invoiceAmt) {
      final value = invoiceAmt - receivedTotalAmt;
      excessAmt = (excessAmt - value);
    } else if (receivedAmt <= balanceAmt) {
      excessAmt = ((receivedTotalAmt - invoiceAmt));
    }

    amtUsedTextEditing.text = invoiceAmt.toCurrencyFormatString();
    excessAmtTextEditing.text = excessAmt.toCurrencyFormatString();
  }

  void changePayFullAmt() {
    isPayFullAmt = !isPayFullAmt;
    if (!isPayFullAmt) {
      amtUsedTextEditing.clear();
      receivedTextEditing.clear();
      excessAmtTextEditing.clear();
      for (var e in paymentDueInvoiceList) {
        e.textCtrlValue?.text = '';
        e.receivedAmt = 0;
      }
    } else {
      receivedTextEditing.text = totalPayableAmt;
      excessAmtTextEditing.text =
          (totalAmount() - receivedAmount(null)).abs().toCurrencyFormatString();
    }
    onReceivedFieldChange(receivedTextEditing.text);
    updateNotifier();
  }

  void openInvoices() {
    isOpenInvoices = !isOpenInvoices;
    updateNotifier();
  }

  void onValidate() {
    receivedAmtError = InputValidator.amountValidator(
      receivedTextEditing.text,
      isEqualTo: true,
      isZeroAmt: true,
      isOptional: false,
      requiredText: 'Amount is Required',
    );
    paymentModeError = InputValidator.emptyValidator(
        paymentModeTextEditing.text,
        requiredText: 'Payment Mode is Required');

    chequeNoError = selectPaymentMode.id == 2
        ? InputValidator.emptyValidator(chequeNoTextEditing.text,
            requiredText: 'Cheque Number is Required')
        : null;
    chequeDateError = selectPaymentMode.id == 2
        ? InputValidator.emptyValidator(chequeDateTextEditing.text,
            requiredText: 'Date is Required')
        : null;

    if (isVendor) {
      accountsError = InputValidator.emptyValidator(accountsTextCtrl.text,
          requiredText: 'Accounts is Required');
    }

    updateNotifier();
  }

  double totalAmount() {
    return totalPayableAmt.isNotEmpty
        ? double.parse(AppConstants.textSymbolRemover(totalPayableAmt))
        : 0;
  }

  double get invoiceReceivedAmt {
    double total = 0;
    for (final e in paymentDueInvoiceList) {
      total += e.receivedAmt ?? 0;
    }
    return total;
  }

  double receivedAmount(String? value) => double.parse(
      AppConstants.textSymbolRemover(value ?? receivedTextEditing.text));

  void onPaymentChange(String value) {
    onValidate();
  }

  List<PaymentInvoice> getInvoiceList(double receivedAmt) {
    final invoices = paymentDueInvoiceList.toList();
    double amount = receivedAmt;
    for (final e in invoices) {
      final isBalanceDue = e.balanceDue == null;
      final dueAmt =
          (isBalanceDue || e.balanceDue == 0 || e.total == e.balanceDue
                  ? e.total
                  : (double.parse(!isBalanceDue ? '0' : e.total.toString()) -
                          double.parse(e.balanceDue.toString()))
                      .abs()) ??
              0.0;
      if (amount < dueAmt) {
        e.receivedAmt = amount;
        e.textCtrlValue?.text =
            amount == 0.0 ? '' : amount.toCurrencyFormatString();
        amount = math.max(0, amount - dueAmt);
      } else {
        e.receivedAmt = dueAmt;
        e.textCtrlValue?.text =
            dueAmt == 0.0 ? '' : (dueAmt).toCurrencyFormatString();
        amount = math.max(0, amount - dueAmt);
      }
    }
    return invoices;
  }

  void onChangeChequeData() async {
    final dateTime = AppDateConstant.currentDateTime;
    final pickedDate = await DatePickerService.datePicker(
        firstDate: dateTime, initialDate: chequeDateTime ?? dateTime);

    if (pickedDate == null) return;
    chequeDateTime = pickedDate;
    chequeDateTextEditing.text =
        DateFormates.monthDayYearFormat.format(chequeDateTime!);
    updateNotifier();
  }

  void onChangeBillDate() async {
    final dateTime = AppDateConstant.currentDateTime;
    final pickedDate = await DatePickerService.datePicker(
        firstDate: dateTime, initialDate: billDate ?? dateTime);

    if (pickedDate == null) return;
    billDate = pickedDate;
    billDateTextEditing.text =
        DateFormates.monthDayYearFormat.format(billDate!);
    updateNotifier();
  }

  void selectPaymentModeBottomSheet() async {
    final res = await dialogService.showBottomSheet(
        title: 'Payment Mode',
        child: PaymentModeWidget(
          selectedId: selectPaymentMode.id ?? 0,
          typeModelList: paymentModeList.toList(),
          title: 'Payment Mode',
          onTap: (PaymentModeList type) {
            selectPaymentMode = type;
            paymentModeTextEditing.text = type.name!;
            if (selectPaymentMode.id == 2) {
              chequeDateTime = DateTime.now();
              chequeDateTextEditing.text =
                  DateFormates.monthDayYearFormat.format(chequeDateTime!);
            } else {
              chequeDateTime = null;
              chequeNoTextEditing.clear();
              chequeDateTextEditing.clear();
            }
            if (selectPaymentMode.id != 3) {
              transferIdTextEditing.text = '';
            }
            dialogService.dialogComplete(AlertResponse(status: false));
            onValidate();
          },
        ));
    print('res $res');
  }

  void updateNotifier() {
    switch (paramsReq?.billType) {
      case BillType.paymentReceived:
        paymentCreateCtrl.setState;
        break;
      case BillType.paymentMade:
        vendorPaymentCreateCtrl.setState;
        break;

      default:
        break;
    }
  }

  //charts of Accounts
  void openChartsOfAccountBottomSheet() {
    dialogService.showBottomSheet(
      title: 'Discount Accounts',
      child: ChartsOfAccountsWidget(
        selectedItem: selectedAccountItem,
        chartsOfAccountList: chartsAccountsList,
        onAddAccounts: () async {
          dialogService.dialogComplete(AlertResponse(status: true));
          final res = await navigationService.pushNamed(Routes.addAccounts,
              arguments: chartsAccountsList.first.accountTypeCode);
          if (res == true) {
            await dashboardController.getAccountList();
          }
        },
        onTap: (childItem) {
          selectedAccountItem = childItem;
          accountsTextCtrl.text = childItem?.name ?? '';
          updateNotifier();
          dialogService.dialogComplete(AlertResponse(status: true));
        },
      ),
    );
  }

  void toastMsg(String msg, [bool isFailed = true]) {
    SnackbarService.toastMsg(msg, isFailed);
  }


  List<ChartsOfAccountListModel> get chartsAccountsList {
    final accList = dashboardController.accountsList.toList();
    return accList.where((model) {

      if (model.accountTypeCode == 1) {
        model.nodesList?.removeWhere((node) => ((node.id != 2)&&node.id !=5));
        return true;
      }

      if (model.accountTypeCode == 2) {

        model.nodesList?.removeWhere((node1) => node1.id != 7);

        model.nodesList?.forEach((node) => cleanChildren(node));
        print(model.nodesList?.first.name);
        print(model.nodesList?.length);
        print(model.nodesList?.length);
        return true;
      }
        return false; // Exclude other accountTypeCodes
    }).toList();
  }

  bool shouldExcludeNode(NodesList node) {
    try{
    return node.accountCode == 33 || node.accountCode == 35||node.code==33||node.code == 35;

    }catch(e){
      return false;
    }
  }

  void cleanChildren(NodesList node) {
    node.nodeListChildren?.removeWhere((child) => shouldExcludeNode(child));
    node.nodeListChildren?.forEach(cleanChildren);
  }


  bool get isEdit => paramsReq?.isEdit == true;
  bool get isVendor => paramsReq?.isVendor == true;

  int get billId => paramsReq?.billId ?? 0;
  int get clientId => paramsReq?.clientId ?? 0;

  PaymentCreateCtrl get paymentCreateCtrl =>
      reference!.read(paymentCreateCtrlProvider.notifier);

  VendorPaymentCreateCtrl get vendorPaymentCreateCtrl =>
      reference!.read(vendorPaymentCreateCtrlProvider.notifier);

  DashboardController get dashboardController =>
      reference!.read(dashboardControllerProvider.notifier);
}
