import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/extension/datetime_extension.dart';
import '../../../../services/date_picker_service.dart';
import '../../models/master_model/due_period_list_model.dart';

part 'sales_info_ctrl.g.dart';

@riverpod
class SalesInfoCtrl extends _$SalesInfoCtrl {
  @override
  AsyncValue<void> build() {
    return AsyncValue.loading();
  }

  AsyncValue<void> get setState => state = AsyncValue.data(null);

  List<DuePeriodListModel> duePeroidList = [];
  DuePeriodListModel? selectedItem;

  DateTime? dueDateTime;
  DateTime? billDateTime;

  void onInit(
      DuePeriodListModel? selectedDue, List<DuePeriodListModel> duePeriods) {
    selectedItem = selectedDue;
    duePeroidList = duePeriods;
    _addDays(selectedItem?.days ?? AppDateConstant.currentDateTime.day);
  }

  void openDatePicker() async {
    final dateTime = billDateTime ?? AppDateConstant.currentDateTime;
    final pickedDate = await DatePickerService.datePicker(
        firstDate: dateTime, initialDate: dueDateTime ?? dateTime);

    if (pickedDate == null) return;
    dueDateTime = pickedDate;
    selectedItem = duePeroidList.singleWhere((e) => e.name == 'custom');
    setState;
  }

  void openBillDatePicker() async {
    final dateTime = AppDateConstant.currentDateTime;
    final pickedDate = await DatePickerService.datePicker(
        firstDate: dateTime, initialDate: billDateTime ?? dateTime);

    if (pickedDate == null) return;
    billDateTime = pickedDate;
    setState;
  }

  void onChangeDueType(DuePeriodListModel type) {
    selectedItem = type;
    if (isCustom) {
      dueDateTime = null;
      openDatePicker();
    } else {
      _addDays(selectedItem!.days!);
    }
    print('selected $selectedItem');
    setState;
  }

  void _addDays(int days) {
    if (isCustom) return;
    dueDateTime = billDateTime?.add(Duration(days: days)) ??
        AppDateConstant.currentDateTime.add(Duration(days: days));
  }

  // void soDateBottomSheet() {
  //   dialogService.showBottomSheet(
  //       isDivider: false,
  //       showActionBar: false,
  //       showCloseIcon: false,
  //       child: TDSTCSBottomSheet(
  //           tdstcsModel: selectedTdsTcsModel,
  //           onTap: (TDSTCSModel item) {
  //             if (selectedTdsTcsModel.id == item.id) {
  //               return dialogService
  //                   .dialogComplete(AlertResponse(status: false));
  //             }
  //             tdsTcsAmtTextCtrl.clear();
  //             tdstcsValueModel = null;
  //             selectedTdsTcsModel = item;
  //             _calCulateTotal();
  //             dialogService.dialogComplete(AlertResponse(status: true));
  //           }));
  // }

  bool get isCustom => (selectedItem?.name == 'custom');
}
