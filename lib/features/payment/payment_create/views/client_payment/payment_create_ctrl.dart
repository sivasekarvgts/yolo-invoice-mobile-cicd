import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../app/constants/app_constants.dart';
import '../../../../../app/constants/strings.dart';
import '../../../../../core/extension/datetime_extension.dart';

import '../../../../../locator.dart';
import '../../../../../router.dart';

import '../../../../../services/event_bus_service.dart';
import '../../../../../services/payment_services/payment_master_services.dart';

import '../../data/payment_create_repo.dart';
import '../../models/payment_create_request_model.dart';
import '../../models/payment_params_request_model.dart';

part 'payment_create_ctrl.g.dart';

@riverpod
class PaymentCreateCtrl extends _$PaymentCreateCtrl with PaymentMasterServices {
  @override
  AsyncValue<void> build() {
    return AsyncValue.loading();
  }

  AsyncValue<void> get setState => state = AsyncValue.data(null);
  AsyncValue<void> get setLoading => state = AsyncValue.loading();

  Future onInit( PaymentParamsRequestModel? data) async {
    await init(ref, data);
    setState;
  }

  void onChangeClient() async {
    final res =
        await navigationService.pushNamed(Routes.customer, arguments: true);
    if (res == null) return;

    paramsReq?.clientId = res;
    await onInit( paramsReq);
  }

  Future createPayment() async {
    FocusScope.of(navigationService.navigatorKey.currentContext!).unfocus();

    onValidate();
    if (receivedAmtError != null || paymentModeError != null) {
      return;
    }
    if (selectPaymentMode.id == 2 &&
        (chequeNoError != null || chequeDateError != null)) {
      return;
    }

    if (invoiceReceivedAmt < 0) {
      return toastMsg('Please enter the invoice received amount');
    }

    final excessAmt =
        double.parse(AppConstants.textSymbolRemover(excessAmtTextEditing.text));
    if (excessAmt < 0) {
      return toastMsg('Please check the excess amount');
    }

    if (receivedAmount(null) <= 0) {
      return toastMsg('Please give payment more than zero');
    }

    if (isEdit) return _updateSalesPayment();
    //create payment
    await _createSalesPayment();
  }

  Future _updateSalesPayment() async {
    paymentLoading = true;
    setState;
    try {
      final res = await ref
          .read(paymentCreateRepoProvider)
          .updatePayment(billId, getPaymentReq);
      if (res == null) return;
      toastMsg(res['message'].toString(), false);
      navigationService.pop();
      eventBusService.eventBus.fire(PageRefreshEvent(pageNames: [
        Routes.paymentDetail,
        Routes.paymentList,
        Routes.receiptList,
        Routes.dashboard,
        Routes.customerDetail
      ]));
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      toastMsg(AppStrings.paymentNotCreated);
    }
    paymentLoading = false;
    setState;
  }

  Future _createSalesPayment() async {
    paymentLoading = true;
    setState;
    try {
      final res = await ref
          .read(paymentCreateRepoProvider)
          .createPayment(getPaymentReq);
      if (res == null) return;
      toastMsg(res['message'].toString(), false);
      navigationService.pop();
      eventBusService.eventBus.fire(PageRefreshEvent(pageNames: [
        Routes.paymentList,
        Routes.receiptList,
        Routes.dashboard,
        Routes.customerDetail
      ]));
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      toastMsg(AppStrings.paymentNotCreated);
    }
    paymentLoading = false;
    setState;
  }

  PaymentCreateRequestModel get getPaymentReq {
    List<Invoice> invoices = [];
    if (billDetail != null)
      invoices.add(Invoice(
          amount: AppConstants.textSymbolRemover(receivedTextEditing.text),
          invoice: billDetail?.id));
    else
      invoices = paymentDueInvoiceList
          .map((r) {
            Map<String, dynamic> json = {
              if (r.id != null) 'invoice': r.id,
              'amount': '${r.receivedAmt ?? 0}'
            };

            return Invoice.fromJson(json);
          })
          .where((t) => t.amount != "0.0")
          .toList();

    final paymentRequest = PaymentCreateRequestModel(
        clientId: clientId,
        paymentMode: selectPaymentMode.code,
        notes: notesTextEditing.text,
        referenceNumber: referenceNoTextEditing.text,
        chequeNumber: chequeNoTextEditing.text,
        transactionId: transferIdTextEditing.text,
        date: DateFormates.yearMonthDayFormat.format(billDate!),
        chequeDate: chequeDateTime != null
            ? DateFormates.yearMonthDayFormat.format(chequeDateTime!)
            : null,
        amountInExcess:
            AppConstants.textSymbolRemover(excessAmtTextEditing.text),
        receivableAmount:
            AppConstants.textSymbolRemover(amtUsedTextEditing.text),
        invoices: invoices);
    return paymentRequest;
  }
}
