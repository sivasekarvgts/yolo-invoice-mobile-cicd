import '../core/enums/request_method.dart';
import '../core/models/client_vendor_request_model.dart';
import '../core/models/request_setting.dart';

import '../features/sales/models/invoice/sales_invoice_request_model.dart';
import 'api_endpoints.dart';

class PurchaseInvoiceRequest {
  RequestSettings getPurchaseInvoiceList(ClientVendorRequestModel input) {
    return RequestSettings(
        '${ApiEndPoint.purchaseInvoice}${input.filters}', RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings postPurchaseInvoice(SalesInvoiceRequestModel request) {
    final Map<String, dynamic> params = request.toJson();
    return RequestSettings(
        '${ApiEndPoint.billPurchaseInvoice}', RequestMethod.POST,
        params: params, authenticated: true);
  }

  RequestSettings updatePurchaseInvoice(
      SalesInvoiceRequestModel request, int id) {
    final Map<String, dynamic> params = request.toJson();
    return RequestSettings(
        '${ApiEndPoint.billPurchaseInvoiceUpdate}$id/', RequestMethod.PUT,
        params: params, authenticated: true);
  }
}
