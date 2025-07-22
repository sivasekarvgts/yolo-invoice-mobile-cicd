import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../locator.dart';
import '../../../services/dialog_service/alert_response.dart';
import '../../../services/dialog_service/snackbar_service.dart';
import '../../sales/views/widgets/generic_sheet.dart';
import '../data/charts_of_accounts_repository.dart';
import '../models/charts_of_accounts_list_model.dart';

part 'add_charts_accounts_ctrl.g.dart';

@riverpod
class AddChartsAccountsCtrl extends _$AddChartsAccountsCtrl {
  @override
  AsyncValue<void> build() {
    return AsyncValue.loading();
  }

  AsyncValue<void> get setState => state = AsyncValue.data(null);
  AsyncValue<void> get setLoading => state = AsyncValue.loading();

  bool isLoading = false;
  bool markAsDefault = false;

  NodesList? selectedParent;
  NodesList? selectedNodesList;
  ChartsOfAccountListModel? accountsModel;

  final accountsFormKey = GlobalKey<FormState>();

  final accountTypeTextCtrl = TextEditingController();
  final accountNameTextCtrl = TextEditingController();
  final parentAccountTextCtrl = TextEditingController();
  final accountDescriptionTextCtrl = TextEditingController();

  Future onInit(List<int> id) async {
    _getAccountList(id);
  }

  Future<void> _getAccountList(List<int> id) async {
    try {
      final res = await ref
          .read(chartsOfAccountsRepositoryProvider)
          .getChartsOfAccountList();
      accountsModel = res
          .where((r) => id.any((w) => w == (r.accountTypeCode ?? 0)) == true)
          .toList()
          .first;
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    state = AsyncValue.data(null);
  }

  void makeAsDefaultAccount() {
    markAsDefault = !markAsDefault;
    if (!markAsDefault) {
      selectedParent = null;
      parentAccountTextCtrl.clear();
    }
    setState;
  }

  void onClear() {
    selectedParent = null;
    selectedNodesList = null;

    accountTypeTextCtrl.clear();
    accountNameTextCtrl.clear();
    parentAccountTextCtrl.clear();
    accountDescriptionTextCtrl.clear();

    final isValid = accountsFormKey.currentState!.validate();
    if (!isValid) return;
  }

  Future saveAccount() async {
    FocusScope.of(navigationService.navigatorKey.currentContext!).unfocus();

    try {
      final input = {
        "name": accountNameTextCtrl.text,
        "description": accountDescriptionTextCtrl.text.isEmpty
            ? ''
            : accountDescriptionTextCtrl.text,
        "category": selectedNodesList?.id,
        "sub_category": selectedParent?.id
      };
      isLoading = true;
      setState;
      final res = await ref
          .read(chartsOfAccountsRepositoryProvider)
          .saveChartsOfAccount(input);

      isLoading = false;
      setState;
      if (res != null) {
        toastMsg("Account is created successfully", false);
        navigationService.pop(returnValue: true);
        return;
      }
      toastMsg("Account is not created successfully");
    } catch (e) {
      isLoading = false;
      setState;
      debugPrint('exception $e');
    }
  }

  //accounts-type sheet
  void openAccountTypeBottomSheet() {
    dialogService.showBottomSheet(
      title: 'Account Type',
      child: GenericSheet<NodesList>(
        dataList: accountsModel?.nodesList ?? [],
        nameExtractor: (u) => u.name,
        selectedData: selectedNodesList,
        onTap: (res) {
          selectedNodesList = res;
          accountTypeTextCtrl.text = res.name ?? "";
          setState;
          dialogService.dialogComplete(AlertResponse(status: true));
        },
      ),
    );
  }

  //parent-type sheet
  void openParentTypeBottomSheet() {
    dialogService.showBottomSheet(
      title: 'Parent Type',
      child: GenericSheet<NodesList>(
        dataList: selectedNodesList?.nodeListChildren ?? [],
        nameExtractor: (u) => u.name,
        selectedData: selectedParent,
        onTap: (res) {
          selectedParent = res;
          parentAccountTextCtrl.text = res.name ?? "";
          setState;
          dialogService.dialogComplete(AlertResponse(status: true));
        },
      ),
    );
  }

  void toastMsg(String msg, [bool isFailed = true]) {
    SnackbarService.toastMsg(msg, isFailed);
  }
}
