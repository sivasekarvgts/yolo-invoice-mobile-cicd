import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yoloworks_invoice/api/payment_request.dart';

import '../../../../core/models/client_vendor_request_model.dart';
import '../../../../locator.dart';
import '../models/payment_list_model.dart';

class PaymentListRepository {
  final PaymentRequest paymentRequest;

  PaymentListRepository({required this.paymentRequest});

  Future<PaymentListModel> getPaymentList(ClientVendorRequestModel input) {
    return apiBaseService.request<PaymentListModel>(
        paymentRequest.getPaymentList(input),
        (res) => PaymentListModel.fromJson(res));
  }
}

final paymentListRepoProvider = Provider<PaymentListRepository>((ref) {
  return PaymentListRepository(paymentRequest: PaymentRequest());
});
