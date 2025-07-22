import 'package:yoloworks_invoice/features/item/model/inventory_item_create_request_model.dart';

import '../core/enums/request_method.dart';
import '../core/models/request_setting.dart';
import 'api_endpoints.dart';

class ItemCreateRequest {
  RequestSettings getItemCategoryList(
      ) {
    return RequestSettings('${ApiEndPoint.itemCategoryList}', RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getItemUnitList() {
    return RequestSettings('${ApiEndPoint.itemUnit}', RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getItemTaxPrefList(
      ) {
    return RequestSettings('${ApiEndPoint.taxPreference}', RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getItemCessList() {
    return RequestSettings('${ApiEndPoint.itemCess}', RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getExemptionReasonList() {
    return RequestSettings('${ApiEndPoint.itemExemptionReason}', RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings createExemptionReason({required String reason}) {
    return RequestSettings('${ApiEndPoint.itemExemptionReason}', RequestMethod.POST,
        params: {"reason":reason}, authenticated: true);
  }

  RequestSettings createInventoryItem({required InventoryItemCreateRequestModel request}) {
    return RequestSettings('${ApiEndPoint.item}', RequestMethod.POST,
        params: request.toJson(), authenticated: true);
  }

  RequestSettings updateInventoryItem({ required Map<String ,dynamic> request,required int id}) {
    return RequestSettings('${ApiEndPoint.item}$id/', RequestMethod.PATCH,
        params: request, authenticated: true);
  }

  RequestSettings getItemTaxList() {
    return RequestSettings('${ApiEndPoint.itemGst}', RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getSelectHsnList({int? page, String? search}) {
    return RequestSettings(
        "${ApiEndPoint.hsn}?page=$page&page_size=20&search=$search",
        RequestMethod.GET,
        useOrgBaseUrl: true,
        params: null,
        authenticated: true);
  }

  RequestSettings getItemList({int? page, String? search}) {
    return RequestSettings(
        "${ApiEndPoint.item}?page=$page&page_size=20&search=$search",
        RequestMethod.GET,
        useOrgBaseUrl: true,
        params: null,
        authenticated: true);
  }
}
