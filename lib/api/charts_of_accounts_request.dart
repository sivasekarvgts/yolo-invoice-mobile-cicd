import '../core/enums/request_method.dart';
import '../core/models/request_setting.dart';
import 'api_endpoints.dart';

class ChartsOfAccountsRequest {
  RequestSettings getChartsOfAccountList() {
    return RequestSettings(ApiEndPoint.chartsOfAccounts, RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings saveChartsOfAccount(Map data) {
    return RequestSettings(ApiEndPoint.saveAccounts, RequestMethod.POST,
        params: data, authenticated: true);
  }
}
