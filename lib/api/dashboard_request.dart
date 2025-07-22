



import '../core/enums/request_method.dart';
import '../core/models/request_setting.dart';

class DashboardRequest {
  //*

  RequestSettings getSalesPurchase({required startDate,required endDate,required int type }) {
    return RequestSettings("bills/sales-purchase-amount/?start_date=${startDate}&end_date=${endDate}&type=$type",
        RequestMethod.GET, params: null, authenticated: true);
    }

 RequestSettings getReceivablesPayable() {
    return RequestSettings("bills/total-payable-receivable-amount/",
        RequestMethod.GET, params: null, authenticated: true);
  }

}
