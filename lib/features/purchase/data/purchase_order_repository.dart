import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/purchase_order_request.dart';
import '../../../core/models/client_vendor_request_model.dart';
import '../../../locator.dart';
import '../../sales/models/invoice/sales_invoice_request_model.dart';
import '../../sales/models/sales_order/sales_order_list_model.dart';

class PurchaseOrderRepository {
  final PurchaseOrderRequest purchaseOrderRequest;

  PurchaseOrderRepository({required this.purchaseOrderRequest});

  Future<OrderListModel> getPurchaseOrderList(
      {ClientVendorRequestModel? input}) async {
    return apiBaseService.request<OrderListModel>(
        purchaseOrderRequest.getPurchaseOrderList(input: input),
        (res) => OrderListModel.fromJson(res));
  }

  Future<Map<String, dynamic>?> createPurchaseOrder(
      {required SalesInvoiceRequestModel order}) async {
    return apiBaseService.request<Map<String, dynamic>?>(
        purchaseOrderRequest.createPurchaseOrder(order: order), (res) {
      if (res == null) return null;
      return res as Map<String, dynamic>;
    });
  }

  Future<Map<String, dynamic>?> updatePurchaseOrder(
      {required int orderId, required SalesInvoiceRequestModel order}) async {
    return apiBaseService.request<Map<String, dynamic>?>(
        purchaseOrderRequest.updatePurchaseOrder(
            orderId: orderId, order: order), (res) {
      if (res == null) return null;
      return res as Map<String, dynamic>;
    });
  }
}

final purchaseOrderRepositoryProvider =
    Provider<PurchaseOrderRepository>((ref) {
  return PurchaseOrderRepository(purchaseOrderRequest: PurchaseOrderRequest());
});
