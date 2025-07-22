import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yoloworks_invoice/features/item/model/inventory_item_details_model.dart';
import '../../../../locator.dart';
import '../../../../router.dart';
import '../../../../services/event_bus_service.dart';
import '../../data/item_list_repository.dart';
part 'item_detail_controller.g.dart';



@riverpod
class ItemDetailController extends _$ItemDetailController {
  @override
  AsyncValue<void> build() {
    return AsyncValue.loading();
  }

  AsyncValue<void> get setState => state = AsyncValue.data(null);

  AsyncValue<void> get setLoading => state = AsyncValue.loading();



  InventoryItemDetailsModel? inventoryItemDetails;
  int? itemId;
  bool statusLoading = false;


  void onInit(int id){
    itemId = id;
    fetchItemDetails(refresh: true);
    onRefreshEvent();
  }



  void onRefreshEvent() async {
    eventBusService.eventBus.on<PageRefreshEvent>().listen((event) async {
      if (event.pageNames.contains(Routes.itemInventoryDetail))
        await fetchItemDetails(refresh: false);
    });
  }



  Future fetchItemDetails({bool refresh = false}) async {
    if(refresh) setLoading;
    try {
      inventoryItemDetails = await ref
          .read(inventoryItemListRepositoryProvider)
          .getInventoryItemDetail(id: itemId??0);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    setState;
  }



  Future onActiveInActiveItem(bool v) async {
    statusLoading = true;
    setState;
    try {
      final res = await ref.read(inventoryItemListRepositoryProvider).activateInventoryItem(
          id: itemId ??0, status:  v);
      await fetchItemDetails(refresh: false);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    statusLoading = false;
    setState;

  }



}