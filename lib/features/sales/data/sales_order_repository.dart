import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/sales_order_request.dart';
import '../../../locator.dart';
import '../models/invoice/sales_invoice_request_model.dart';
import '../models/sales_order/sales_order_detail_model.dart';
import '../models/sales_order/sales_order_list_model.dart';

class SalesOrderRepository {
  final SalesOrderRequest salesOrderRequest;

  SalesOrderRepository({required this.salesOrderRequest});

  Future<OrderListModel> getSalesOrderList(
      {required int page,
      String? search,
      String? startDate,
      String? endDate,
      bool? isDateFilter}) async {
    return apiBaseService.request<OrderListModel>(
        salesOrderRequest.getSalesOrderList(
            page: page,
            search: search,
            startDate: startDate,
            endDate: endDate,
            isDateFilter: isDateFilter),
        (res) => OrderListModel.fromJson(res));
  }

  Future<SalesOrderDetailModel> getSalesOrderDetail(
      {required int orderId}) async {
    return apiBaseService.request<SalesOrderDetailModel>(
        salesOrderRequest.getSalesOrderDetail(orderId: orderId),
        (res) => SalesOrderDetailModel.fromJson(res));
  }

  Future<Map<String, dynamic>?> createSalesOrder(
      {required SalesInvoiceRequestModel order}) async {
    return apiBaseService.request<Map<String, dynamic>?>(
        salesOrderRequest.createSalesOrder(order: order), (res) {
      if (res == null) return null;
      return res as Map<String, dynamic>;
    });
  }

  Future<Map<String, dynamic>?> updateSalesOrder(
      {required int orderId, required SalesInvoiceRequestModel order}) async {
    return apiBaseService.request<Map<String, dynamic>?>(
        salesOrderRequest.updateSalesOrder(orderId: orderId, order: order),
        (res) {
      if (res == null) return null;
      return res as Map<String, dynamic>;
    });
  }
}

final salesOrderRepositoryProvider = Provider<SalesOrderRepository>((ref) {
  return SalesOrderRepository(salesOrderRequest: SalesOrderRequest());
});
