import '../core/enums/request_method.dart';
import '../core/models/request_setting.dart';
import 'api_endpoints.dart';

class MasterDataApiRequest {
  RequestSettings getBillNoGenerator({required int type}) {
    return RequestSettings('${ApiEndPoint.billNo}$type/', RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getPriceList({required int clientId}) {
    return RequestSettings(
        '${ApiEndPoint.priceList}?client=$clientId', RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getDuePeriodList() {
    return RequestSettings(ApiEndPoint.duePeriod, RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getTransportModeList() {
    return RequestSettings(ApiEndPoint.transportMode, RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getSalesPersonList() {
    return RequestSettings(ApiEndPoint.salesPerson, RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getBillConfig() {
    return RequestSettings(ApiEndPoint.billsConfiguration, RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getTdsList() {
    return RequestSettings(ApiEndPoint.billsTds, RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getTcsList() {
    return RequestSettings(ApiEndPoint.billsTcs, RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getTdsSectionList() {
    return RequestSettings(ApiEndPoint.tdsSection, RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getTcsSectionList() {
    return RequestSettings(ApiEndPoint.tcsSection, RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getItemList(
      {int? priceId, required int page, String? search}) {
    return RequestSettings(
        '${ApiEndPoint.billItemList}?price_list=$priceId&${ApiEndPoint.page}$page&page_size=10&${ApiEndPoint.search}$search',
        RequestMethod.GET,
        params: null,
        authenticated: true);
  }

  RequestSettings createTds({required Map<String, dynamic>? params}) {
    return RequestSettings(ApiEndPoint.billsTds, RequestMethod.POST,
        params: params, authenticated: true);
  }

  RequestSettings createTcs({required Map<String, dynamic>? params}) {
    return RequestSettings(ApiEndPoint.billsTcs, RequestMethod.POST,
        params: params, authenticated: true);
  }

  RequestSettings getWarehouseList() {
    return RequestSettings(ApiEndPoint.warehouseList, RequestMethod.GET,
        params: null, authenticated: true, useOrgBaseUrl: true);
  }
}
