
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/errors/error_response_exception.dart';
import '../../../../../locator.dart';
import '../../../../../router.dart';
import '../../../../../services/dialog_service/alert_response.dart';
import '../../../../../services/dialog_service/snackbar_service.dart';
import '../../../../../services/event_bus_service.dart';
import '../../../../charts_of_account/models/charts_of_accounts_list_model.dart';
import '../../../../charts_of_account/views/widgets/charts_of_account_widget.dart';
import '../../../../dashboard/view/dashboard_controller.dart';
import '../../../../sales/models/master_model/gst_tax_model.dart';
import '../../../../sales/views/widgets/generic_sheet.dart';
import '../../../data/item_create_repository.dart';
import '../../../model/inventory_item_create_request_model.dart';
import '../../../model/inventory_item_details_model.dart';
import '../../../model/item_drop_down_list_model.dart';
import '../../../model/item_tax_list_model.dart';
import '../widgets/shared/add_reason_widget.dart';
import 'item_edit_view.dart';

part 'item_edit_controller.g.dart';

@riverpod
class ItemEditController extends _$ItemEditController {
  @override
  AsyncValue<void> build() {
    return AsyncValue.loading();
  }

  AsyncValue<void> get setState => state = AsyncValue.data(null);

  AsyncValue<void> get setLoading => state = AsyncValue.loading();


  final taxPrefsKey = GlobalKey<FormState>();


  final taxPreferenceCtrl = TextEditingController();
  final gstRateCtrl = TextEditingController();
  final cessRateCtrl = TextEditingController();
  final exemptionReasonCtrl = TextEditingController();

  final salesAccountCtrl = TextEditingController();
  final purchaseAccountCtrl = TextEditingController();
  final inventoryAccountCtrl = TextEditingController();

  final minStockReminderCtrl = TextEditingController();





  List<ItemDropDownListModel> taxPreferenceList = [];
  ItemDropDownListModel? selectedTaxPreference;

  GstTaxModel selectedSalesIncExcTax = gstTaxModel.first;
  GstTaxModel selectedPurchaseIncExcTax = gstTaxModel.first;
  List<ItemTaxListModel> gstRateList = [];
  List<ItemTaxListModel> cessList = [];
  List<ItemTaxListModel> exemptionReasonList = [];


  ItemTaxListModel? selectedCess;
  GstTaxModel? selectedSalesGstTax;
  ItemTaxListModel? selectedGstRate;
  ItemTaxListModel? selectedExemptionReason;

  NodesList? selectedSalesAccountItem;
  NodesList? selectedPurchaseAccountItem;
  NodesList? selectedInventoryAccountItem;


  InventoryItemDetailsModel? editDetailsData;
  ItemEditType? itemEditType ;


  onInit(InventoryItemDetailsModel? detail) async {
    itemEditType = detail?.itemUpdateType;
    editDetailsData =detail;

    if(itemEditType==ItemEditType.stockDetail) {
      minStockReminderCtrl.text = editDetailsData?.reorderPointValue ?? "";
      return  setState;
    }

   if(itemEditType==ItemEditType.taxPreference) {
      await fetchItemTaxPrefList();
      await fetchItemCessList();
      await fetchTaxList();
      await fetchExemptionReasonList();
      setTaxPreferenceData();
      return  setState;
    }
    _loadChartsOfAccounts();
    setState;

  }



  void setTaxPreferenceData(){
    ItemDropDownListModel? selectedPref = taxPreferenceList
        .cast<ItemDropDownListModel?>()
        .firstWhere(
          (element) => element?.id == (editDetailsData?.taxPreference ?? 0),
      orElse: () => null,
    );


    if (selectedPref != null) {
      selectedTaxPreference = selectedPref;
      taxPreferenceCtrl.text = selectedPref.name ?? "";
    }

    if(selectedTaxPreference?.id==1) {
      ItemTaxListModel? _selectedGst = gstRateList
          .cast<ItemTaxListModel?>()
          .firstWhere(
            (element) => element?.id == (editDetailsData?.taxId ?? 0),
        orElse: () => null,
      );

      if (_selectedGst != null) {
        selectedGstRate = _selectedGst;
        gstRateCtrl.text = _selectedGst.name ?? "";
      }


      ItemTaxListModel? _selectedCess = cessList
          .cast<ItemTaxListModel?>()
          .firstWhere(
            (element) => element?.id == (editDetailsData?.cessRateId ?? 0),
        orElse: () => null,
      );

      if (_selectedCess != null) {
        selectedCess = _selectedCess;
        cessRateCtrl.text = _selectedCess.name ?? "";
      }
    }



    if(selectedTaxPreference?.id==2){
      ItemTaxListModel? selectedReason = exemptionReasonList
          .cast<ItemTaxListModel?>()
          .firstWhere(
            (element) => element?.name == (editDetailsData?.exemptionReasonName ?? 0),
        orElse: () => null,
      );

      if (selectedReason != null) {
        selectedExemptionReason = selectedReason;
        exemptionReasonCtrl.text = selectedReason.name ?? "";
      }
    }

  }

  void clearCESS() {
    cessRateCtrl.clear();
    selectedCess = null;
    setState;
  }

  void _loadChartsOfAccounts() {


    final int salesDefaultAccountId = editDetailsData?.salesAccount??50;
    final int purchaseDefaultAccountId = editDetailsData?.purchaseAccount??84;
    final int inventoryDefaultAccountId = editDetailsData?.inventoryAccount??30;


    if (salesAccountsList.isNotEmpty) {
      final salesListItem = salesAccountsList
          .map((r) => r.nodesList ?? <NodesList>[])
          .expand((t) => t)
          .map((r) => r.nodeListChildren ?? <NodesList>[])
          .expand((t) => t)
          .singleWhere((n) => n.id == salesDefaultAccountId, orElse: () => NodesList());
      if (salesListItem.id != null) {
        selectedSalesAccountItem = salesListItem;
        salesAccountCtrl.text = selectedSalesAccountItem?.name ?? '';
      }
    }

    if (inventoryAccountsList.isNotEmpty) {
      final inventoryNodeItem = inventoryAccountsList
          .map((n) => n.nodeListChildren ?? <NodesList>[])
          .expand((k) => k)
          .singleWhere((m) => m.code == inventoryDefaultAccountId, orElse: () => NodesList());
      if (inventoryNodeItem.id != null) {
        selectedInventoryAccountItem = inventoryNodeItem;
        inventoryAccountCtrl.text = selectedInventoryAccountItem?.name ?? '';
      }
    }

    if (purchaseAccountsList.isNotEmpty) {
      final purchaseNodeItem = purchaseAccountsList
          .map((r) => r.nodesList ?? <NodesList>[])
          .expand((t) => t)
          .map((r) => r.nodeListChildren ?? <NodesList>[])
          .expand((t) => t)
          .singleWhere((n) => n.id == purchaseDefaultAccountId, orElse: () => NodesList());
      if (purchaseNodeItem.id != null) {
        selectedPurchaseAccountItem = purchaseNodeItem;
        purchaseAccountCtrl.text = selectedPurchaseAccountItem?.name ?? '';
      }
    }
  }

  Future fetchItemTaxPrefList({bool? refresh}) async {
    try {
      if (refresh == true) {
        taxPreferenceList = [];
      }
      taxPreferenceList =
      await ref.read(itemCreateRepositoryProvider).getItemTaxPrefList();
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    // state = AsyncValue.data(null);
  }

  Future fetchTaxList({bool? refresh}) async {
    try {
      if (refresh == true) {
        gstRateList = [];
      }
      gstRateList =
      await ref.read(itemCreateRepositoryProvider).getItemTaxList();
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    // state = AsyncValue.data(null);
  }

  Future fetchItemCessList({bool? refresh}) async {
    try {
      if (refresh == true) {
        cessList = [];
      }
      cessList = await ref.read(itemCreateRepositoryProvider).getItemCessList();
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    // state = AsyncValue.data(null);
  }

  Future fetchExemptionReasonList({bool? refresh}) async {
    try {
      if (refresh == true) {
        exemptionReasonList = [];
      }
      exemptionReasonList =
      await ref.read(itemCreateRepositoryProvider).getExemptionReasonList();
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    // state = AsyncValue.data(null);
  }

  Future<void> onUpdate()async{
    if(itemEditType==ItemEditType.taxPreference){
      final isValid = taxPrefsKey.currentState!.validate();
      debugPrint('isValid $isValid');
      if (!isValid) return;
    }
    await  updateItemDetail();
  }


  Future updateItemDetail() async {

    setLoading;
    try {

      final param = itemEditType==ItemEditType.taxPreference?_setTaxPrefsEditRequest().toJsonTaxPref():itemEditType==ItemEditType.stockDetail?_setStockRequest():_setAccountEditRequest().toJson();
      var res = await ref
          .read(itemCreateRepositoryProvider)
          .updateInventoryItem(request:  param,id: editDetailsData?.id??0);
      fireRefreshEvent();
      navigationService.pop(returnValue: true);
      SnackbarService.toastMsg("Item Updated Successfully!", false);
    }on ErrorResponseException catch (e) {
      debugPrint('exception $e');
      final response = e.error?.data;
      SnackbarService.toastMsg(response?.data["Message"] ?? "Something went wrong",);
    }
    catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    state = AsyncValue.data(null);
  }

  Map<String ,dynamic> _setStockRequest(){
    return {"reorder_point": minStockReminderCtrl.text.isEmpty?null:double.parse(minStockReminderCtrl.text)};}

  InventoryItemCreateRequestModel _setTaxPrefsEditRequest(){
    return InventoryItemCreateRequestModel(
      taxPreference:selectedTaxPreference?.id,
      cessRate: selectedTaxPreference?.id == 1 ? selectedCess?.id : null,
      tax: selectedTaxPreference?.id == 1 ? selectedGstRate?.id : null,
      reason: selectedTaxPreference?.id == 2 ? selectedExemptionReason?.id : null,

    );
  }

  InventoryItemCreateRequestModel _setAccountEditRequest(){
    return InventoryItemCreateRequestModel(
      salesAccount: selectedSalesAccountItem?.id,
      purchaseAccount: selectedPurchaseAccountItem?.id,
      inventoryAccount: selectedInventoryAccountItem?.id,

    );
  }

  void fireRefreshEvent() {
    final  List<String> primaryRefreshPages=[Routes.itemInventoryDetail];

    eventBusService.eventBus.fire(PageRefreshEvent(pageNames: primaryRefreshPages));
  }



  void openTaxPreferenceBottomSheet() {
    dialogService.showBottomSheet(
      title: 'Select Tax Preference',
      child: GenericSheet<ItemDropDownListModel>(
        dataList: taxPreferenceList,
        nameExtractor: (u) => u.name,
        selectedData: selectedTaxPreference,
        onTap: (res) {
          selectedTaxPreference = res;
          taxPreferenceCtrl.text = res.name ?? "";
          gstRateCtrl.clear();
          cessRateCtrl.clear();
          setState;
          dialogService.dialogComplete(AlertResponse(status: true));
        },
      ),
    );
  }


  void openGstRateBottomSheet() {
    dialogService.showBottomSheet(
      title: 'Select GST Rate',
      child: GenericSheet<ItemTaxListModel>(
        dataList: gstRateList,
        nameExtractor: (u) => u.name,
        selectedData: selectedGstRate,
        onTap: (res) {
          selectedGstRate = res;
          gstRateCtrl.text = res.name ?? "";
          setState;
          dialogService.dialogComplete(AlertResponse(status: true));
        },
      ),
    );
  }


  void openCessBottomSheet() {
    dialogService.showBottomSheet(
      title: 'Select Cess',
      child: GenericSheet<ItemTaxListModel>(
        dataList: cessList,
        nameExtractor: (u) => u.name,
        selectedData: selectedCess,
        onTap: (res) {
          selectedCess = res;
          cessRateCtrl.text = res.name ?? "";
          setState;
          dialogService.dialogComplete(AlertResponse(status: true));
        },
      ),
    );
  }

  void openExemptionReasonBottomSheet() {
    dialogService.showBottomSheet(
      title: 'Select Exemption Reason',
      child: GenericSheet<ItemTaxListModel>(
          dataList: exemptionReasonList,
          nameExtractor: (u) => u.name,
          selectedData: selectedExemptionReason,
          onTap: (res) {
            selectedExemptionReason = res;
            exemptionReasonCtrl.text = res.name ?? "";
            setState;
            dialogService.dialogComplete(AlertResponse(status: true));
          },
          bottomWidget: AddWidgetOnBottom(
            label: "Add Reason",
            onTap: () {
              dialogService.dialogComplete(AlertResponse(status: true));
              showCreateReasonDialog();
            },
          )),
    );
  }

  Future<void> showCreateReasonDialog() async {
    final res = await showCupertinoDialog(
      barrierDismissible: true,
      context: dialogService.dialogNavigationKey.currentContext!,
      builder: (context) {
        return Dialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: CupertinoColors.systemGrey6,
          child: AddReasonDialogWidget(),
        );
      },
    );
    if (selectedExemptionReason != null) {
      exemptionReasonCtrl.text = selectedExemptionReason?.name ?? "";
    }
  }


  //sales-charts-of-accounts
  void openSalesAccountBottomSheet() {
    dialogService.showBottomSheet(
      title: 'Sales Accounts',
      child: ChartsOfAccountsWidget(
        chartsOfAccountList: salesAccountsList,
        selectedItem: selectedSalesAccountItem,
        onAddAccounts: () async {
          dialogService.dialogComplete(AlertResponse(status: true));
          final res = await navigationService.pushNamed(Routes.addAccounts,
              arguments: 4);
          if (res == true) {
            await dashboardController.getAccountList();
          }
        },
        onTap: (childItem) {
          selectedSalesAccountItem = childItem;
          salesAccountCtrl.text = childItem?.name ?? '';
          setState;
          dialogService.dialogComplete(AlertResponse(status: true));
        },
      ),
    );
  }

  //purchase-charts-of-accounts
  void openPurchaseAccountBottomSheet() {
    dialogService.showBottomSheet(
      title: 'Purchase Accounts',
      child: ChartsOfAccountsWidget(
        selectedItem: selectedPurchaseAccountItem,
        chartsOfAccountList: purchaseAccountsList,
        onAddAccounts: () async {
          dialogService.dialogComplete(AlertResponse(status: true));
          final res = await navigationService.pushNamed(Routes.addAccounts,
              arguments: 5);
          if (res == true) {
            await dashboardController.getAccountList();
          }
        },
        onTap: (childItem) {
          selectedPurchaseAccountItem = childItem;
          purchaseAccountCtrl.text = childItem?.name ?? '';
          setState;
          dialogService.dialogComplete(AlertResponse(status: true));
        },
      ),
    );
  }

  //inventory-charts-of-accounts
  void openInventoryAccountBottomSheet() {
    dialogService.showBottomSheet(
      title: 'Inventory Accounts',
      child: ChartsOfAccountsNodeListWidget(
        selectedItem: selectedInventoryAccountItem,
        accountList: inventoryAccountsList,
        onAddAccounts: () async {
          dialogService.dialogComplete(AlertResponse(status: true));
          final res = await navigationService.pushNamed(Routes.addAccounts,
              arguments: chartsAccountsList().first.accountTypeCode);
          if (res == true) {
            await dashboardController.getAccountList();
          }
        },
        onTap: (childItem) {
          selectedInventoryAccountItem = childItem;
          inventoryAccountCtrl.text = childItem?.name ?? '';
          setState;
          dialogService.dialogComplete(AlertResponse(status: true));
        },
      ),
    );
  }

  List<ChartsOfAccountListModel> get salesAccountsList =>
      dashboardController.accountsList
          .where((t) => t.accountTypeCode == 4)
          .toList();

  List<ChartsOfAccountListModel> get purchaseAccountsList =>
      dashboardController.accountsList
          .where((t) => t.accountTypeCode == 5)
          .toList();

  List<NodesList> get inventoryAccountsList => dashboardController.accountsList
      .where((t) => t.accountTypeCode == 1)
      .map((e) => e.nodesList ?? <NodesList>[])
      .expand((n) => n)
      .where((t) => t.id == 6)
      .toList();

  List<ChartsOfAccountListModel> chartsAccountsList() {
    final accList = dashboardController.accountsList.toList();
    return accList.where((model) {
      if (model.accountTypeCode == 1) {
        return true;
      } else if (model.accountTypeCode == 2) {
        // model.nodesList?.removeWhere((node) => shouldExcludeNode(node));
        model.nodesList?.forEach((node) => cleanChildren(node));
        return true;
      }
      return false; // Exclude other accountTypeCodes
    }).toList();
  }

  bool shouldExcludeNode(NodesList node) {
    return node.accountCode == 33 || node.accountCode == 35;
  }

  void cleanChildren(NodesList node) {
    node.nodeListChildren?.removeWhere((child) => shouldExcludeNode(child));
    node.nodeListChildren?.forEach(cleanChildren);
  }

  DashboardController get dashboardController =>
      ref.read(dashboardControllerProvider.notifier);




}