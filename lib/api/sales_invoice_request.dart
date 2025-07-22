import '../core/enums/request_method.dart';
import '../core/models/client_vendor_request_model.dart';
import '../core/models/request_setting.dart';
import '../features/sales/models/invoice/sales_invoice_request_model.dart';
import 'api_endpoints.dart';

class SalesInvoiceRequest {
  RequestSettings getSalesInvoiceList(ClientVendorRequestModel input) {
    return RequestSettings(
        '${ApiEndPoint.salesInvoiceV2}${input.filters}', RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings warehouseItemValidate(List<int> items, List<int> itemUnits,
      List<double> quantities, int warehouse) {
    return RequestSettings(
        '${ApiEndPoint.warehouseItemValidate}?items=$items&item_units=$itemUnits&quantities=$quantities&warehouse=${warehouse}',
        RequestMethod.GET,
        params: null,
        authenticated: true);
  }

  RequestSettings postSalesInvoice(SalesInvoiceRequestModel request) {
    final Map<String, dynamic> params = request.toJson();
    return RequestSettings(ApiEndPoint.salesInvoice, RequestMethod.POST,
        params: params, authenticated: true);
  }

  RequestSettings updateSalesInvoice(SalesInvoiceRequestModel request, int id) {
    final Map<String, dynamic> params = request.toJson();
    return RequestSettings(
        "${ApiEndPoint.salesInvoiceUpdate}$id/", RequestMethod.PUT,
        params: params, authenticated: true);
  }

  RequestSettings getSalesInvoiceDetail(int id) {
    return RequestSettings(
        "${ApiEndPoint.billInvoiceDetail}$id/", RequestMethod.GET,
        params: null, authenticated: true);
  }
}
