import '../core/enums/request_method.dart';
import '../core/models/client_vendor_request_model.dart';
import '../core/models/request_setting.dart';
import '../features/payment/payment_create/models/payment_create_request_model.dart';
import 'api_endpoints.dart';

class PaymentRequest {
  RequestSettings getPaymentList(ClientVendorRequestModel input) {
    String endPoint = input.addClient
        ? ApiEndPoint.clientPaymentList
        : ApiEndPoint.vendorPaymentList;

    return RequestSettings('$endPoint${input.filters}', RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getPaymentModeList() {
    return RequestSettings('${ApiEndPoint.paymentModeList}', RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getPaymentInvoices(int client, bool isVendor) {
    String endPoint = isVendor
        ? '${ApiEndPoint.vendorPaymentDueInvoice}$client/'
        : '${ApiEndPoint.paymentDueInvoice}$client/';
    return RequestSettings(endPoint, RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getPaymentRetrieve(int id) {
    return RequestSettings(
        '${ApiEndPoint.paymentRetrieve}$id/', RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getPaymentDetails(int id) {
    return RequestSettings(
        '${ApiEndPoint.paymentDetails}$id/', RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getPaymentTemplate(int id) {
    return RequestSettings(
        '${ApiEndPoint.paymentTemplate}$id/', RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings createPayment(PaymentCreateRequestModel req, bool isVendor) {
    String endPoint =
        isVendor ? ApiEndPoint.vendorPaymentCreate : ApiEndPoint.paymentCreate;
    return RequestSettings(endPoint, RequestMethod.POST,
        params: req.toJson(true), authenticated: true);
  }

  RequestSettings updatePayment(
      int id, PaymentCreateRequestModel req, bool isVendor) {
    String endPoint = isVendor
        ? '${ApiEndPoint.vendorPaymentUpdate}$id/'
        : '${ApiEndPoint.paymentUpdate}$id/';
    return RequestSettings(endPoint, RequestMethod.PUT,
        params: req.toJson(true), authenticated: true);
  }

  RequestSettings deletePayment(int id) {
    return RequestSettings(
        '${ApiEndPoint.paymentDelete}$id/', RequestMethod.DELETE,
        params: null, authenticated: true);
  }
}
