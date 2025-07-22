import '../core/enums/request_method.dart';
import '../core/models/client_vendor_request_model.dart';
import '../core/models/request_setting.dart';
import 'api_endpoints.dart';

class TransactionRequest {
  RequestSettings getClientTransactionStatement(
      ClientVendorRequestModel input) {
    return RequestSettings(
        '${ApiEndPoint.clientBill}${input.filters}', RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getVendorTransactionStatement(
      ClientVendorRequestModel input) {
    return RequestSettings(
        '${ApiEndPoint.vendorBill}${input.filters}', RequestMethod.GET,
        params: null, authenticated: true);
  }
}
