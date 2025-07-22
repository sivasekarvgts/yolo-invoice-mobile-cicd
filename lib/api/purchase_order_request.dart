import '../core/enums/request_method.dart';
import '../core/models/client_vendor_request_model.dart';
import '../core/models/request_setting.dart';
import '../features/sales/models/invoice/sales_invoice_request_model.dart';
import 'api_endpoints.dart';

class PurchaseOrderRequest {
  RequestSettings getPurchaseOrderList({ClientVendorRequestModel? input}) {
    return RequestSettings(
        '${ApiEndPoint.purchaseOrder}${input?.filters}', RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getPurchaseOrderDetail({required int orderId}) {
    return RequestSettings(
        '${ApiEndPoint.orderDetail}$orderId/', RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings updatePurchaseOrder(
      {required int orderId, required SalesInvoiceRequestModel order}) {
    return RequestSettings(
        '${ApiEndPoint.purchaseOrderUpdate}$orderId/', RequestMethod.PUT,
        params: order.toJson(), authenticated: true);
  }

  RequestSettings createPurchaseOrder(
      {required SalesInvoiceRequestModel order}) {
    return RequestSettings(ApiEndPoint.purchaseOrder, RequestMethod.POST,
        params: order.toJson(), authenticated: true);
  }
}
