import '../core/enums/request_method.dart';
import '../core/models/request_setting.dart';
import '../features/sales/data/item_list_repository.dart';
import 'api_endpoints.dart';

class ItemListRequest {


  RequestSettings getItemGst() {
    return RequestSettings('${ApiEndPoint.itemGst}', RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getItemCess() {
    return RequestSettings('${ApiEndPoint.itemCess}', RequestMethod.GET,
        params: null, authenticated: true);
  }


  RequestSettings getInventoryItemList({int? page, String? search}) {
    return RequestSettings(
        "${ApiEndPoint.item}?page=$page&page_size=20&search=$search",
        RequestMethod.GET,
        params: null,
        authenticated: true);
  }

  RequestSettings getInventoryItemDetail({int? id}) {
    return RequestSettings(
        "${ApiEndPoint.item}$id/",
        RequestMethod.GET,
        params: null,
        authenticated: true);
  }

  RequestSettings activateInventoryItem({ required int? id,required bool status}) {
    return RequestSettings(
        "${ApiEndPoint.item}$id/",
        RequestMethod.PATCH,
        params: {"status":status},
        authenticated: true);
  }

  RequestSettings getItemList({int? priceId, int? page, String? search}) {
    final priceListString = priceId != null ? "&price_list=$priceId" : "";
    final url =
        '${ApiEndPoint.billItemList}?${ApiEndPoint.page}$page&page_size=20&${ApiEndPoint.search}$search$priceListString'
            .trim();
    return RequestSettings(url, RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getPurchaseItemList({int? page, String? search}) {
    final url =
        '${ApiEndPoint.purchaseItemList}?${ApiEndPoint.page}$page&page_size=20&${ApiEndPoint.search}$search';
    return RequestSettings(url, RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings applyPriceList({Map? input}) {
    final qty = input?['qty'];
    final item = input?['item'];
    final itemUnit = input?['itemUnit'];
    final priceListId = input?['priceId'];
    final priceListString =
        priceListId != null ? "&price_list=$priceListId" : "";
    final url =
        '${ApiEndPoint.applyPriceList}?item=$item&item_units=$itemUnit&quantity=$qty$priceListString'
            .trim();
    return RequestSettings(url, RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings updateHsnCodeItem(
      {required String hsnCode, required int id}) {
    return RequestSettings('${ApiEndPoint.item}$id', RequestMethod.PATCH,
        params: {'hsn_code': hsnCode}, authenticated: true);
  }

  RequestSettings getInventoryList({int? priceId, int? page, String? search}) {
    return RequestSettings(
        '${ApiEndPoint.billItemList}$priceId&${ApiEndPoint.page}$page&page_size=20&${ApiEndPoint.search}$search',
        RequestMethod.GET,
        params: null,
        authenticated: true);
  }

  RequestSettings getSchemeList({required SchemeRequestData req}) {
    return RequestSettings(
        '${ApiEndPoint.schemeList}${req.itemId}/?quantity=${req.quantity}&client=${req.client}&unit=${req.unit}&item_unit=${req.itemUnit}&total_qty=${req.totalQty}&warehouse=${req.warehouseId??""}',
        RequestMethod.GET,
        params: null,
        authenticated: true);
  }
}
