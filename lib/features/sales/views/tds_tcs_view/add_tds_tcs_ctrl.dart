import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/constants/app_constants.dart';
import '../../../../locator.dart';
import '../../../../services/dialog_service/alert_response.dart';
import '../../../../services/dialog_service/snackbar_service.dart';
import '../../data/master_data_repository.dart';
import '../../models/master_model/gst_tax_model.dart';
import '../../models/master_model/tds_tcs_section_model.dart';
import '../widgets/generic_sheet.dart';
import 'tds_tcs_type_sheet.dart';

part 'add_tds_tcs_ctrl.g.dart';

@riverpod
class AddTdsTcsCtrl extends _$AddTdsTcsCtrl {
  @override
  AsyncValue<void> build() {
    return AsyncValue.data(null);
  }

  AsyncValue<void> get setState => state = AsyncValue.data(null);
  AsyncValue<void> get setLoading => state = AsyncValue.loading();

  final formKey = GlobalKey<FormState>();
  final taxNameCtrl = TextEditingController();
  final taxRateCtrl = TextEditingController();
  final taxTypeCtrl = TextEditingController();
  final taxDescriptionCtrl = TextEditingController();

  TdsTcsModel? tdsTcsModel;
  List<TdsTcsSectionModel> tdsTcsSectionList = [];
  TdsTcsSectionModel selectedTdsTcsSection = TdsTcsSectionModel();

  Future onInit(Map? input) async {
    tdsTcsModel = input?['tds_tcs_model'];
    tdsTcsSectionList = input?['tds_section_list'];
    setState;
  }

  Future saveTdsTcs() async {
    if ((formKey.currentState?.validate() == false)) return;
    final value = AppConstants.textSymbolRemover(taxRateCtrl.text);
    final input = {
      "name": taxNameCtrl.text,
      "rate": double.parse(value),
      "tax_type": selectedTdsTcsSection.id,
      "description": taxDescriptionCtrl.text
    };
    if (tdsTcsModel?.id == 0) {
      await createTds(input);
      return;
    }
    await createTcs(input);
    return;
  }

  Future createTds(Map<String, Object?> input) async {
    try {
      final res = await ref
          .read(masterDataRepositoryProvider)
          .createTdsSection(input: input);
      if (res == null) {
        SnackbarService.toastMsg("TDS is not created", false);
        return;
      }
      navigationService.pop(returnValue: res);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future createTcs(Map<String, Object?> input) async {
    try {
      final res = await ref
          .read(masterDataRepositoryProvider)
          .createTcsSection(input: input);
      if (res == null) {
        SnackbarService.toastMsg("Tcs is not created", false);
        return;
      }
      navigationService.pop(returnValue: res);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  void tdsTcsBottomSheet() {
    dialogService.showBottomSheet(
      title: "Tax Type",
        child:  GenericSheet<TdsTcsSectionModel>(
          dataList: tdsTcsSectionList ,
          nameExtractor: (u) => u.name,
          selectedData: selectedTdsTcsSection,
          onTap: (res) {
            selectedTdsTcsSection = res;
            taxTypeCtrl.text = res.name ?? "";setState;
             dialogService.dialogComplete(AlertResponse(status: true));
          },
        ),


         );
  }
}
