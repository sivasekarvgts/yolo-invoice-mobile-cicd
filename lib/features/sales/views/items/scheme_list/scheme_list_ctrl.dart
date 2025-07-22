import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yoloworks_invoice/locator.dart';

import '../../../../../app/constants/strings.dart';
import '../../../../../services/dialog_service/snackbar_service.dart';

import '../../../data/item_list_repository.dart';
import '../../../models/master_model/scheme_list_model.dart';

part 'scheme_list_ctrl.g.dart';

@riverpod
class SchemeListCtrl extends _$SchemeListCtrl {
  @override
  AsyncValue<void> build() {
    return AsyncValue.loading();
  }

  AsyncValue<void> get setState => state = AsyncValue.data(null);
  AsyncValue<void> get setLoading => state = AsyncValue.loading();

  Map input = {};
  List<int> schemeList = [];
  SchemeListModel? schemeListModel;

  Future onInit(Map data) async {
    input = data;
    await fetchSchemeData();
    setState;
  }

  Future fetchSchemeData() async {
    setLoading;
    try {
      final unit = input['unit'];
      final itemId = input['itemId'];
      final client = input['client'];
      final quantity = input['quantity'];
      final totalQty = input['totalQty'];
      final itemUnit = input['itemUnit'];
      final warehouse = input['warehouse'];
      schemeList = input['scheme_list'] ?? [];

      schemeListModel = await ref
          .read(itemListRepositoryProvider)
          .getSchemeList(
              req: SchemeRequestData(
                  itemId: itemId,
                  quantity: quantity,
                  client: client,
                  unit: unit,
                  itemUnit: itemUnit,
                  totalQty: totalQty,
                  warehouseId: warehouse));
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    setState;
  }

  void onSelectedFoc(List scheme) {
    schemeList.clear();
    schemeList = scheme.map((r) => r['id'] as int).toList();
    setState;
  }

  void onApplyFoc() {
    if (schemeList.isEmpty) {
      SnackbarService.toastMsg(AppStrings.schemeError);
      return;
    }
    navigationService.pop(returnValue: schemeList);
  }
}
