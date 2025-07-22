import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/item_list_request.dart';
import '../../../locator.dart';
import '../model/inventory_item_details_model.dart';
import '../model/inventory_item_list_model.dart';

class InventoryItemListRepository {
  final ItemListRequest inventoryItemListRequest;

  InventoryItemListRepository({required this.inventoryItemListRequest});

  Future<InventoryItemListModel> getInventoryItemList(
          {required int page, required String search}) =>
      apiBaseService.request<InventoryItemListModel>(
          inventoryItemListRequest.getInventoryItemList(
              page: page, search: search),
          (data) => InventoryItemListModel.fromJson(data));


  Future<InventoryItemDetailsModel> getInventoryItemDetail({required int id}) =>
      apiBaseService.request<InventoryItemDetailsModel>(
          inventoryItemListRequest.getInventoryItemDetail(id: id),
              (data) => InventoryItemDetailsModel.fromJson(data));


   Future<InventoryItemDetailsModel> activateInventoryItem({required int id,required bool status}) =>
        apiBaseService.request<InventoryItemDetailsModel>(
            inventoryItemListRequest.activateInventoryItem(id: id,status:status ),
                (data) => InventoryItemDetailsModel.fromJson(data));
}

final inventoryItemListRepositoryProvider =
    Provider<InventoryItemListRepository>((ref) {
  return InventoryItemListRepository(
      inventoryItemListRequest: ItemListRequest());
});
