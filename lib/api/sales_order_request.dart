import '../core/enums/request_method.dart';
import '../core/models/request_setting.dart';

import '../features/sales/models/invoice/sales_invoice_request_model.dart';
import 'api_endpoints.dart';

class SalesOrderRequest {
  RequestSettings getSalesOrderList(
      {required int page,
      String? search,
      String? startDate,
      String? endDate,
      bool? isDateFilter}) {
    final filter = isDateFilter == true
        ? '&page_size=20&'
        : '${ApiEndPoint.page}$page&page_size=20&';
    return RequestSettings(
        '${ApiEndPoint.salesOrder}?$filter${ApiEndPoint.search}$search&${ApiEndPoint.startDate}$startDate&${ApiEndPoint.endDate}$endDate',
        RequestMethod.GET,
        params: null,
        authenticated: true);
  }

  RequestSettings getSalesOrderDetail({required int orderId}) {
    return RequestSettings(
        '${ApiEndPoint.orderDetail}$orderId/', RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings updateSalesOrder(
      {required int orderId, required SalesInvoiceRequestModel order}) {
    return RequestSettings(
        '${ApiEndPoint.billOrderUpdate}$orderId/', RequestMethod.PUT,
        params: order.toJson(), authenticated: true);
  }

  RequestSettings createSalesOrder({required SalesInvoiceRequestModel order}) {
    return RequestSettings(ApiEndPoint.salesOrder, RequestMethod.POST,
        params: order.toJson(), authenticated: true);
  }
}
