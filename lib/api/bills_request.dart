import '../core/enums/request_method.dart';
import '../core/models/request_setting.dart';
import 'api_endpoints.dart';

class BillsRequest {
  RequestSettings getBillPreview({required int order}) {
    return RequestSettings('${ApiEndPoint.billOrder}$order/', RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getBillTemplate({required int order}) {
    return RequestSettings(
        '${ApiEndPoint.billOrderTemplate}$order/', RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getInvoiceBillPreview({required int id}) {
    return RequestSettings('${ApiEndPoint.billInvoice}$id/', RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getInvoiceBillTemplate({required int id}) {
    return RequestSettings(
        '${ApiEndPoint.billInvoiceTemplate}$id/', RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getTransactions({required int id}) {
    return RequestSettings(
        '${ApiEndPoint.billInvoiceTransaction}$id/', RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getTransactionStatement({required int id}) {
    return RequestSettings(
        '${ApiEndPoint.billTransactionStatement}$id/', RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings deletePayment({required int id}) {
    return RequestSettings(
        '${ApiEndPoint.paymentCancel}$id/', RequestMethod.DELETE,
        params: null, authenticated: true);
  }

  RequestSettings deleteCreditNote({required int id}) {
    return RequestSettings(
        '${ApiEndPoint.creditNoteCancel}$id/', RequestMethod.DELETE,
        params: null, authenticated: true);
  }

  RequestSettings deleteOrder({required int order}) {
    return RequestSettings(
        '${ApiEndPoint.billOrderDelete}$order/', RequestMethod.DELETE,
        params: null, authenticated: true);
  }
}
