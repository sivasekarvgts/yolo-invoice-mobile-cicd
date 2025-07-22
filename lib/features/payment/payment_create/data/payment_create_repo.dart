import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../api/payment_request.dart';
import '../../../../api/master_data_api_request.dart';

import '../../../../locator.dart';
import '../models/payment_create_request_model.dart';
import '../models/payment_due_invoice_model.dart';
import '../models/payment_mode_list.dart';
import '../models/payment_retrieve_model.dart';

class PaymentCreateRepo {
  final PaymentRequest paymentRequest;
  final MasterDataApiRequest masterDataApiRequest;
  PaymentCreateRepo(
      {required this.paymentRequest, required this.masterDataApiRequest});

  Future<List<PaymentModeList>> getPaymentModeList() {
    return apiBaseService.requestList<PaymentModeList>(
        paymentRequest.getPaymentModeList(),
        (res) => (res as List<dynamic>)
            .map((item) =>
                PaymentModeList.fromJson(item as Map<String, dynamic>))
            .toList());
  }

  Future<PaymentRetrieveModel> getPaymentRetrieve(int id) {
    return apiBaseService.request<PaymentRetrieveModel>(
        paymentRequest.getPaymentRetrieve(id),
        (res) => PaymentRetrieveModel.fromJson(res));
  }

  Future<PaymentDueInvoiceModel> getPaymentDueInvoices(
      int client, bool isVendor) {
    return apiBaseService.request<PaymentDueInvoiceModel>(
        paymentRequest.getPaymentInvoices(client, isVendor),
        (res) => PaymentDueInvoiceModel.fromJson(res));
  }

  Future<Map<String, dynamic>?> createPayment(PaymentCreateRequestModel req,
      [bool isVendor = false]) {
    return apiBaseService.request<Map<String, dynamic>?>(
        paymentRequest.createPayment(req, isVendor), (res) {
      if (res == null) return null;
      return res as Map<String, dynamic>;
    });
  }

  Future<Map<String, dynamic>?> updatePayment(
      int id, PaymentCreateRequestModel req,
      [bool isVendor = false]) {
    return apiBaseService.request<Map<String, dynamic>?>(
        paymentRequest.updatePayment(id, req, isVendor), (res) {
      if (res == null) return null;
      return res as Map<String, dynamic>;
    });
  }
}

final paymentCreateRepoProvider = Provider<PaymentCreateRepo>((ref) {
  return PaymentCreateRepo(
    paymentRequest: PaymentRequest(),
    masterDataApiRequest: MasterDataApiRequest(),
  );
});
