import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yoloworks_invoice/locator.dart';

import '../../../../api/payment_request.dart';
import '../models/payment_detail_model.dart';
import '../models/payment_template_model.dart';

class PaymentDetailRepo {
  final PaymentRequest paymentRequest;
  PaymentDetailRepo({required this.paymentRequest});

  Future<PaymentDetailModel> getPaymentDetails(int id) {
    return apiBaseService.request<PaymentDetailModel>(
        paymentRequest.getPaymentDetails(id),
        (res) => PaymentDetailModel.fromJson(res));
  }

  Future<PaymentTemplateModel> getPaymentTemplate(int id) {
    return apiBaseService.request<PaymentTemplateModel>(
        paymentRequest.getPaymentTemplate(id),
        (res) => PaymentTemplateModel.fromJson(res));
  }

  Future<Map<String, dynamic>?> deletePayment(int id) {
    return apiBaseService.request<Map<String, dynamic>?>(
        paymentRequest.deletePayment(id), (res) {
      if (res == null) return null;
      return res as Map<String, dynamic>;
    });
  }
}

final paymentDetailsRepoProvider = Provider<PaymentDetailRepo>((ref) {
  return PaymentDetailRepo(
    paymentRequest: PaymentRequest(),
  );
});
