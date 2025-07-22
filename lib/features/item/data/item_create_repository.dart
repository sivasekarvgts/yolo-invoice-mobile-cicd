import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yoloworks_invoice/core/models/message.dart';
import 'package:yoloworks_invoice/features/item/model/hsn_list_model.dart';
import 'package:yoloworks_invoice/features/item/model/inventory_item_list_model.dart';

import '../../../api/item_create_request.dart';
import '../../../locator.dart';
import '../model/inventory_item_create_request_model.dart';
import '../model/item_drop_down_list_model.dart';
import '../model/item_tax_list_model.dart';

class ItemCreateRepository {
  final ItemCreateRequest itemCreateRequest;

  ItemCreateRepository({required this.itemCreateRequest});

  Future<List<ItemDropDownListModel>> getItemCategoryList() =>
      apiBaseService.request<List<ItemDropDownListModel>>(
          itemCreateRequest.getItemCategoryList(),
          (data) => (data as List<dynamic>)
              .map((item) =>
                  ItemDropDownListModel.fromJson(item as Map<String, dynamic>))
              .toList());

  Future<List<ItemDropDownListModel>> getItemUnitList() =>
      apiBaseService.request<List<ItemDropDownListModel>>(
          itemCreateRequest.getItemUnitList(),
          (data) => (data as List<dynamic>)
              .map((item) =>
                  ItemDropDownListModel.fromJson(item as Map<String, dynamic>))
              .toList());

  Future<List<ItemDropDownListModel>> getItemTaxPrefList() =>
      apiBaseService.request<List<ItemDropDownListModel>>(
          itemCreateRequest.getItemTaxPrefList(),
          (data) => (data as List<dynamic>)
              .map((item) =>
                  ItemDropDownListModel.fromJson(item as Map<String, dynamic>))
              .toList());

  Future<List<ItemTaxListModel>> getItemCessList() =>
      apiBaseService.request<List<ItemTaxListModel>>(
          itemCreateRequest.getItemCessList(),
          (data) => (data as List<dynamic>)
              .map((item) =>
                  ItemTaxListModel.fromJson(item as Map<String, dynamic>))
              .toList());

  Future<List<ItemTaxListModel>> getExemptionReasonList() =>
      apiBaseService.request<List<ItemTaxListModel>>(
          itemCreateRequest.getExemptionReasonList(),
          (data) => (data as List<dynamic>)
              .map((item) =>
                  ItemTaxListModel.fromJson(item as Map<String, dynamic>))
              .toList());

  Future<ItemTaxListModel> createExemptionReason({required String reason}) =>
      apiBaseService.request<ItemTaxListModel>(
          itemCreateRequest.createExemptionReason(reason: reason),
          (data) => ItemTaxListModel.fromJson(data));

  Future<Message> createInventoryItem({required InventoryItemCreateRequestModel request}) =>
      apiBaseService.request<Message>(
          itemCreateRequest.createInventoryItem(request: request),
          (data) => Message.fromJson(data));

  Future<Message> updateInventoryItem({required Map<String ,dynamic> request,required int id}) =>
      apiBaseService.request<Message>(
          itemCreateRequest.updateInventoryItem(request: request,id: id),
          (data) => Message.fromJson(data));

  Future<List<ItemTaxListModel>> getItemTaxList() =>
      apiBaseService.request<List<ItemTaxListModel>>(
          itemCreateRequest.getItemTaxList(),
          (data) => (data as List<dynamic>)
              .map((item) =>
                  ItemTaxListModel.fromJson(item as Map<String, dynamic>))
              .toList());

  Future<HsnListModel> getSelectHsnList(
          {required int page, required String search}) =>
      apiBaseService.request<HsnListModel>(
          itemCreateRequest.getSelectHsnList(page: page, search: search),
          (data) => HsnListModel.fromJson(data));

  Future<InventoryItemListModel> getItemList(
          {required int page, required String search}) =>
      apiBaseService.request<InventoryItemListModel>(
          itemCreateRequest.getItemList(page: page, search: search),
          (data) => InventoryItemListModel.fromJson(data));
}

final itemCreateRepositoryProvider = Provider<ItemCreateRepository>((ref) {
  return ItemCreateRepository(itemCreateRequest: ItemCreateRequest());
});
