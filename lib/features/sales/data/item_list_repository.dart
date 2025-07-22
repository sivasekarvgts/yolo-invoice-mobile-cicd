import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../locator.dart';
import '../../../api/item_list_request.dart';
import '../../item/model/item_tax_list_model.dart';
import '../models/item_model/item_list_model.dart';
import '../models/item_model/apply_price_list_model.dart';
import '../models/master_model/scheme_list_model.dart';

class ItemListRepository {
  final ItemListRequest itemListRequest;

  ItemListRepository({required this.itemListRequest});




  Future<List<ItemTaxListModel>> getItemGst() async {
    return apiBaseService.requestList<ItemTaxListModel>(
        itemListRequest.getItemGst(),
        (res) => (res as List<dynamic>)
            .map((item) =>
                ItemTaxListModel.fromJson(item as Map<String, dynamic>))
            .toList());
  }

  Future<List<ItemTaxListModel>> getItemCess() async {
    return apiBaseService.requestList<ItemTaxListModel>(
        itemListRequest.getItemCess(),
        (res) => (res as List<dynamic>)
            .map((item) =>
                ItemTaxListModel.fromJson(item as Map<String, dynamic>))
            .toList());
  }

  Future<ItemListModel> getItemList(
      {int? priceListId, int? page, String? search}) async {
    return apiBaseService.request<ItemListModel>(
        itemListRequest.getItemList(
            priceId: priceListId, page: page, search: search),
        (res) => ItemListModel.fromJson(res));
  }

  Future<ItemListModel> getPurchaseItemList({int? page, String? search}) async {
    return apiBaseService.request<ItemListModel>(
        itemListRequest.getPurchaseItemList(page: page, search: search),
        (res) => ItemListModel.fromJson(res));
  }

  Future<Map<String, dynamic>?> updateHsnCode(
      {required int id, required String code}) async {
    return apiBaseService.request<Map<String, dynamic>?>(
        itemListRequest.updateHsnCodeItem(id: id, hsnCode: code), (res) => res);
  }

  Future<SchemeListModel> getSchemeList(
      {required SchemeRequestData req}) async {
    return apiBaseService.request<SchemeListModel>(
        itemListRequest.getSchemeList(req: req),
        (res) => SchemeListModel.fromJson(res));
  }

  Future<List<ApplyPriceListModel>> applyPriceList({Map? input}) {
    return apiBaseService.requestList<ApplyPriceListModel>(
        itemListRequest.applyPriceList(input: input),
        (res) => (res as List<dynamic>)
            .map((item) =>
                ApplyPriceListModel.fromJson(item as Map<String, dynamic>))
            .toList());
  }
}

final itemListRepositoryProvider = Provider<ItemListRepository>((ref) {
  return ItemListRepository(itemListRequest: ItemListRequest());
});

class SchemeRequestData {
  final int? itemId;
  final double? quantity;
  final int? client;
  final int? unit;
  final int? itemUnit;
  final int? warehouseId;
  final double? totalQty;

  SchemeRequestData(
      {required this.itemId,
      required this.quantity,
      required this.client,
      required this.unit,
      required this.itemUnit,
      required this.warehouseId,
      required this.totalQty});
}
