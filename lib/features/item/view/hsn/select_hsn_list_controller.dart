import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yoloworks_invoice/features/item/data/item_create_repository.dart';

import '../../../../../locator.dart';
import '../../../../../utils/debounce.dart';
import '../../model/hsn_list_model.dart';

part 'select_hsn_list_controller.g.dart';

@riverpod
class SelectHsnListController extends _$SelectHsnListController {
  @override
  AsyncValue<void> build() {
    return AsyncValue.loading();
  }

  AsyncValue<void> get setState => state = AsyncValue.data(null);

  AsyncValue<void> get setLoading => state = AsyncValue.loading();

  HsnListModel? hsnListData;

  List<HsnData> hsnList = [];
  final searchTextCtrl = TextEditingController();

  bool showSearchBar = true;

  Future<void> onInit() async {
    // onSalesOrderRefreshEvent();
    await fetchData(refresh: true);
  }

  Future onSearchInvoice(String query) async {
    Debounce.debounce('hsn-list-search', () async {
      await fetchData(refresh: true);
    });
  }

  void onClearDateFilter() async {
    navigationService.pop();
    hsnListData = null;
    await fetchData();
  }

  Future fetchData({
    bool refresh = false,
  }) async {
    if (refresh) {
      hsnListData = null;
      hsnList.clear();
      setLoading;
    }

    int numPages = (hsnListData?.numPages ?? 1);
    int currentPage = (hsnListData?.currentPage ?? 0);
    if (currentPage >= numPages) {
      setState;
      return IndicatorResult.none;
    }

    try {
      hsnListData =
          await ref.read(itemCreateRepositoryProvider).getSelectHsnList(
                page: currentPage + 1,
                search: searchTextCtrl.text,
                // isDateFilter: isDateFilter
              );
      hsnList.addAll(hsnListData?.data ?? []);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    setState;
  }

  void onOpenSearch() {
    showSearchBar = true;
    setState;
  }
}
