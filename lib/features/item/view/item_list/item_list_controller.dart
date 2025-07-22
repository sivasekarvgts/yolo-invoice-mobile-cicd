import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yoloworks_invoice/features/item/model/inventory_item_list_model.dart';

import '../../../../app/common_widgets/hide_floating.dart';
import '../../../../locator.dart';
import '../../../../router.dart';
import '../../../../services/event_bus_service.dart';
import '../../../../utils/debounce.dart';
import '../../data/item_list_repository.dart';

part 'item_list_controller.g.dart';

@riverpod
class ItemListController extends _$ItemListController with HideFloating {
  @override
  AsyncValue<void> build() {
    return AsyncValue.loading();
  }

  AsyncValue<void> get setState => state = AsyncValue.data(null);

  AsyncValue<void> get setLoading => state = AsyncValue.loading();

  InventoryItemListModel? itemListData;

  List<InventoryItemDatum> itemList = [];
  final searchTextCtrl = TextEditingController();
  bool showSearchBar = false;

  Future<void> onInit() async {
    await fetchData(refresh: true);
    onRefreshEvent();
  }

  void onRefreshEvent() async {
    eventBusService.eventBus.on<PageRefreshEvent>().listen((event) async {
      if (event.pageNames.contains(Routes.itemInventoryList))
        await fetchData(refresh: event.isRefresh);
    });
  }

  Future fetchData({
    bool refresh = false,
  }) async {
    if (refresh) {
      itemListData = null;
      itemList.clear();
      setLoading;
    }

    int numPages = (itemListData?.numPages ?? 1);
    int currentPage = (itemListData?.currentPage ?? 0);
    if (currentPage >= numPages) {
      setState;
      return IndicatorResult.none;
    }

    try {
      itemListData = await ref
          .read(inventoryItemListRepositoryProvider)
          .getInventoryItemList(
            page: currentPage + 1,
            search: searchTextCtrl.text,
          );
      itemList.addAll(itemListData?.data ?? []);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    setState;
  }

  Future onSearch(String query) async {
    Debounce.debounce('item-list-search', () async {
      await fetchData(refresh: true);
    });
  }

  void onOpenSearch() {
    showSearchBar = true;
    setState;
  }
}
