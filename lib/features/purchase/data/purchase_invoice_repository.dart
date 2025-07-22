import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/purchase_invoice_request.dart';
import '../../../core/models/client_vendor_request_model.dart';
import '../../../locator.dart';
import '../../sales/models/invoice/invoice_list_model.dart';
import '../../sales/models/invoice/sales_invoice_request_model.dart';

class PurchaseInvoiceRepository {
  final PurchaseInvoiceRequest purchaseInvoiceRequest;

  PurchaseInvoiceRepository({required this.purchaseInvoiceRequest});

  Future<InvoiceListModel> getPurchaseInvoiceList(
      ClientVendorRequestModel input) async {
    return apiBaseService.request<InvoiceListModel>(
        purchaseInvoiceRequest.getPurchaseInvoiceList(input),
        (res) => InvoiceListModel.fromJson(res));
  }

  Future<dynamic> postSalesInvoice(SalesInvoiceRequestModel req) async {
    return apiBaseService.request<dynamic>(
        purchaseInvoiceRequest.postPurchaseInvoice(req), (res) => (res));
  }

  Future<dynamic> updateSalesInvoice(
      SalesInvoiceRequestModel req, int id) async {
    return apiBaseService.request<dynamic>(
        purchaseInvoiceRequest.updatePurchaseInvoice(req, id), (res) => (res));
  }
}

final purchaseInvoiceRepositoryProvider =
    Provider<PurchaseInvoiceRepository>((ref) {
  return PurchaseInvoiceRepository(
      purchaseInvoiceRequest: PurchaseInvoiceRequest());
});
