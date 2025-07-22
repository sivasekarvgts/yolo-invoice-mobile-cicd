import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yoloworks_invoice/features/item/data/item_create_repository.dart';
import 'package:yoloworks_invoice/features/item/model/hsn_list_model.dart';
import 'package:yoloworks_invoice/features/item/model/inventory_item_create_request_model.dart';
import 'package:yoloworks_invoice/features/item/view/new_item/widgets/item_basic_info_view.dart';
import 'package:yoloworks_invoice/features/item/view/new_item/widgets/item_purchase_details_view.dart';
import 'package:yoloworks_invoice/features/item/view/new_item/widgets/item_sale_details_view.dart';
import 'package:yoloworks_invoice/features/item/view/new_item/widgets/shared/add_reason_widget.dart';

import '../../../../app/constants/app_constants.dart';
import '../../../../locator.dart';
import '../../../../router.dart';
import '../../../../services/dialog_service/alert_response.dart';
import '../../../../services/dialog_service/snackbar_service.dart';
import '../../../../services/event_bus_service.dart';
import '../../../charts_of_account/models/charts_of_accounts_list_model.dart';
import '../../../charts_of_account/views/widgets/charts_of_account_widget.dart';
import '../../../dashboard/view/dashboard_controller.dart';
import '../../../sales/models/master_model/gst_tax_model.dart';
import '../../../sales/views/widgets/generic_sheet.dart';
import '../../model/inventory_item_details_model.dart';
import '../../model/item_drop_down_list_model.dart';
import '../../model/item_tax_list_model.dart';

part 'item_create_controller.g.dart';

@riverpod
class ItemCreateController extends _$ItemCreateController {
  @override
  AsyncValue<void> build() {
    return AsyncValue.loading();
  }

  AsyncValue<void> get setState => state = AsyncValue.data(null);

  AsyncValue<void> get setLoading => state = AsyncValue.loading();

  int selectedIndex = 0;
  double completedPercent = 0;
   List<Widget>  formWidgets = const [
     ItemBasicInfoView(),
     ItemSaleDetailsView(),
     ItemPurchaseDetailsView(),
   ];

  final basicInfoKey = GlobalKey<FormState>();
  // final salesKey = GlobalKey<FormState>();
  // final purchaseKey = GlobalKey<FormState>();
  final productNameCtrl = TextEditingController();
  final categoryCtrl = TextEditingController();
  final productDescriptionCtrl = TextEditingController();
  final hsnCodeCtrl = TextEditingController();
  final skuBarCodeCtrl = TextEditingController();

  final List<AddUnitModel> addUomListCtrl = [];

  final unitOfMeasureCtrl = TextEditingController();
  final salePricePerUnitCtrl = TextEditingController();
  final alternateUOMCtrl = TextEditingController();
  final alternateQuantityCtrl = TextEditingController();
  final taxPreferenceCtrl = TextEditingController();
  final gstRateCtrl = TextEditingController();
  final cessRateCtrl = TextEditingController();
  final salesAccountCtrl = TextEditingController();
  final exemptionReasonCtrl = TextEditingController();

  final openingStockCtrl = TextEditingController();
  final minStockReminderCtrl = TextEditingController();
  final costPerPcsCtrl = TextEditingController();
  final purchaseAccountCtrl = TextEditingController();
  final inventoryAccountCtrl = TextEditingController();
  bool haveOpeningStock = true;

  List<ItemDropDownListModel> itemCategoryList = [];
  ItemDropDownListModel? selectedCategory;
  List<ItemDropDownListModel> unitOfMeasureList = [];
  ItemDropDownListModel? selectedUnitOfMeasure;
  List<GstTaxModel> incExcTaxPList = gstTaxModel;
  List<ItemDropDownListModel> taxPreferenceList = [];
  ItemDropDownListModel? selectedTaxPreference;

  GstTaxModel selectedSalesIncExcTax = gstTaxModel.first;
  GstTaxModel selectedPurchaseIncExcTax = gstTaxModel.first;
  List<ItemTaxListModel> gstRateList = [];
  List<ItemTaxListModel> cessList = [];
  List<ItemTaxListModel> exemptionReasonList = [];

  HsnData? selectedHsn;
  ItemTaxListModel? selectedCess;
  GstTaxModel? selectedSalesGstTax;
  GstTaxModel? selectedPurchaseGstTax;
  ItemTaxListModel? selectedGstRate;
  ItemTaxListModel? selectedExemptionReason;

  NodesList? selectedSalesAccountItem;
  NodesList? selectedPurchaseAccountItem;
  NodesList? selectedInventoryAccountItem;

  bool isEdit = false;
  InventoryItemDetailsModel? editDetailsData;

  InventoryItemCreateRequestModel newItemRequest =
      InventoryItemCreateRequestModel();

  Future onInit(InventoryItemDetailsModel? editDetails) async {



    await _onLoadWidget();

    await fetchItemCategoryList();
    if(editDetails!=null) {

      isEdit = true;
      editDetailsData = editDetails;
      _setEditData();
      return setState;
    }
    await fetchItemUnitList();
    await fetchItemTaxPrefList();
    await fetchItemCessList();
    await fetchTaxList();
    await fetchExemptionReasonList();
    _loadChartsOfAccounts();
    setState;
  }

  void fireRefreshEvent() {
    final  List<String> primaryRefreshPages=[Routes.itemInventoryList,Routes.itemInventoryDetail];

    eventBusService.eventBus.fire(PageRefreshEvent(pageNames: primaryRefreshPages));
  }

  Future<void> _onLoadWidget() async {
    // formWidgets = const [
    //   ItemBasicInfoView(),
    //   ItemSaleDetailsView(),
    //   ItemPurchaseDetailsView(),
    // ];
    _onDownloadPercent();
  }

  _setEditData(){
    productNameCtrl.text =editDetailsData?.name??"";
    hsnCodeCtrl.text =editDetailsData?.hsnCode??"";
    skuBarCodeCtrl.text =editDetailsData?.skuCode??"";
    ItemDropDownListModel? selected = itemCategoryList
        .cast<ItemDropDownListModel?>()
        .firstWhere(
          (element) => element?.id == (editDetailsData?.categoryId ?? 0),
      orElse: () => null,
    );

    if (selected != null) {
      selectedCategory = selected;
      categoryCtrl.text = selected.name ?? "";
    }

  }

  void _loadChartsOfAccounts() {
    if (salesAccountsList.isNotEmpty) {
      final salesListItem = salesAccountsList
          .map((r) => r.nodesList ?? <NodesList>[])
          .expand((t) => t)
          .map((r) => r.nodeListChildren ?? <NodesList>[])
          .expand((t) => t)
          .singleWhere((n) => n.id == 50, orElse: () => NodesList());
      if (salesListItem.id != null) {
        selectedSalesAccountItem = salesListItem;
        salesAccountCtrl.text = selectedSalesAccountItem?.name ?? '';
      }
    }

    if (inventoryAccountsList.isNotEmpty) {
      final inventoryNodeItem = inventoryAccountsList
          .map((n) => n.nodeListChildren ?? <NodesList>[])
          .expand((k) => k)
          .singleWhere((m) => m.code == 30, orElse: () => NodesList());
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
          .singleWhere((m) => m.code == 84, orElse: () => NodesList());
      if (purchaseNodeItem.id != null) {
        selectedPurchaseAccountItem = purchaseNodeItem;
        purchaseAccountCtrl.text = selectedPurchaseAccountItem?.name ?? '';
      }
    }
  }

  void _onDownloadPercent() {
    if (selectedIndex == 0) {
      completedPercent = 3;
    } else if (selectedIndex == 1) {
      completedPercent = 2;
    } else {
      completedPercent = 1;
    }
  }

  void onNext(int index) {
    selectedIndex = index;
    _onDownloadPercent();
    setState;
  }

  Future<void> onSaveBasicInfo() async {
    final isValid = basicInfoKey.currentState!.validate();
    debugPrint('isValid $isValid');
    if (!isValid) return;
    if(isEdit) return await updateBasicDetail();
    onNext(1);
  }

  Future<void> onSaveSales() async {
    final isValid = basicInfoKey.currentState!.validate();
    if (!isValid) return;
    onNext(2);
  }

  void onSavePurchase() async {
    final isValid = basicInfoKey.currentState!.validate();
    if (!isValid) return;

    state = AsyncValue.loading();
    await createItem();
  }

  Future updateBasicDetail() async {
    setLoading;
    try {
      var res = await ref
          .read(itemCreateRepositoryProvider)
          .updateInventoryItem(request:  _setBasicInfoEditRequest(),id: editDetailsData?.id??0);
      fireRefreshEvent();
      navigationService.pop(returnValue: true);
      SnackbarService.toastMsg("Item Updated Successfully!", false);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    state = AsyncValue.data(null);
  }

  Map<String, dynamic> _setBasicInfoEditRequest(){
    return InventoryItemCreateRequestModel(
      name: productNameCtrl.text,
      category: selectedCategory?.id,
      description: productDescriptionCtrl.text.isEmpty?null:productDescriptionCtrl.text,
      hsnCode: hsnCodeCtrl.text.isEmpty?null:hsnCodeCtrl.text,
      skuCode: skuBarCodeCtrl.text.isEmpty?null:skuBarCodeCtrl.text,
    ).toJsonBasicDetail();
  }

  Future createItem() async {
    setLoading;
    _setItemRequest();
    try {
      var res = await ref
          .read(itemCreateRepositoryProvider)
          .createInventoryItem(request:newItemRequest );
      fireRefreshEvent();
      navigationService.pop(returnValue: true);
      SnackbarService.toastMsg("Item Created Successfully!", false);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    state = AsyncValue.data(null);
  }

  _setItemRequest() {
    int type = 1;
     List<AddUnitModel> uomConversions = [];
     uomConversions = addUomListCtrl.map((e) {

      final double purchasePrice = double.tryParse(
          AppConstants.textSymbolRemover(costPerPcsCtrl.text))??0;
      final double qty =double.tryParse(e.quantityListCtrl.text)??0;

      return AddUnitModel(
        unit: ++type,
        type: ++type,
        baseUnit: selectedUnitOfMeasure?.id??0,
        quantity: qty,
        sellingPrice: double.tryParse(
            AppConstants.textSymbolRemover(e.salesPriceListCtrl.text)),
        purchasePrice: (purchasePrice * qty),
        quantity2: 1,
        isForPurchase: false,
        isPrimary: false,
        salesAccount: selectedSalesAccountItem?.id,
      );


    }).toList();

    uomConversions.insert(0,
        AddUnitModel(
      unit: 1,
      type: 1,
      quantity: 1,
      sellingPrice: double.tryParse(
          AppConstants.textSymbolRemover(salePricePerUnitCtrl.text)),
      isForPurchase: true,
      isPrimary: true,
      salesAccount: selectedSalesAccountItem?.id,
      purchasePrice:  double.tryParse(
          AppConstants.textSymbolRemover(costPerPcsCtrl.text))??0,
    ));



    newItemRequest = InventoryItemCreateRequestModel(
      itemType: selectedCategory?.id ?? 1, // 1 for goods, 2 for services
      name: productNameCtrl.text,
      category: selectedCategory?.id,
      description: productDescriptionCtrl.text.isEmpty?null:productDescriptionCtrl.text,
      hsnCode: hsnCodeCtrl.text.isEmpty?null:hsnCodeCtrl.text,
      skuCode: skuBarCodeCtrl.text.isEmpty?null:skuBarCodeCtrl.text,
      cessRate: selectedTaxPreference == 1 ? selectedCess?.id : null,
      tax: selectedTaxPreference == 1 ? selectedGstRate?.id : null,
      isSalesTaxExclusive: selectedSalesIncExcTax != gstTaxModel.first,
      isPurchaseTaxExclusive: selectedPurchaseIncExcTax != gstTaxModel.first,
      hasInventory: true,
      openingStock:
          haveOpeningStock ? double.tryParse(openingStockCtrl.text) : null,
      reorderPoint:
          haveOpeningStock ? double.tryParse(minStockReminderCtrl.text) : null,
      initialStockRate:
          haveOpeningStock ? double.tryParse(minStockReminderCtrl.text) : null,
      purchaseAccount: selectedPurchaseAccountItem?.id,
      inventoryAccount: selectedInventoryAccountItem?.id,
      salesAccount: selectedSalesAccountItem?.id,
      itemTracking: 1,
      isAutoIncrement: false,
      taxPreference: selectedTaxPreference?.id,
      reason: selectedTaxPreference == 2 ? selectedExemptionReason?.id : null,
      units: uomConversions
    );
  }

  Future fetchItemCategoryList({bool? refresh}) async {
    try {
      if (refresh == true) {
        itemCategoryList = [];
      }
      itemCategoryList =
          await ref.read(itemCreateRepositoryProvider).getItemCategoryList();
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    state = AsyncValue.data(null);
  }

  Future fetchItemUnitList({bool? refresh}) async {
    try {
      if (refresh == true) {
        unitOfMeasureList = [];
      }
      unitOfMeasureList =
          await ref.read(itemCreateRepositoryProvider).getItemUnitList();
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    state = AsyncValue.data(null);
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
    state = AsyncValue.data(null);
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
    state = AsyncValue.data(null);
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
    state = AsyncValue.data(null);
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
    state = AsyncValue.data(null);
  }

  Future<bool> createExemptionReason(reason) async {
    try {
      selectedExemptionReason = await ref
          .read(itemCreateRepositoryProvider)
          .createExemptionReason(reason: reason);
      exemptionReasonList.add(selectedExemptionReason!);
      state = AsyncValue.data(null);
      return true;
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    state = AsyncValue.data(null);
    return false;
  }

  void clearCategory() {
    categoryCtrl.clear();
    selectedCategory = null;
    setState;
  }

   void clearCESS() {
    cessRateCtrl.clear();
    selectedCess = null;
    setState;
  }

  void onManualChangeAddUOM(index) {
    addUomListCtrl[index].isManuallyChanged = true;
  }

  void onChangePrice(String val) {
    addUomListCtrl.forEach(
      (element) {
        if (element.isManuallyChanged) return;
        final qty = double.tryParse(element.quantityListCtrl.text);
        final price = double.parse(
            AppConstants.textSymbolRemover(salePricePerUnitCtrl.text));
        element.salesPriceListCtrl.text = ((qty ?? 0) * price).toString();
      },
    );
  }

  void openCategoryBottomSheet() {
    dialogService.showBottomSheet(
      title: 'Select Category',
      child: GenericSheet<ItemDropDownListModel>(
        dataList: itemCategoryList,
        nameExtractor: (u) => u.name,
        selectedData: selectedCategory,
        onTap: (res) {
          selectedCategory = res;
          categoryCtrl.text = res.name ?? "";
          setState;
          dialogService.dialogComplete(AlertResponse(status: true));
        },
      ),
    );
  }

  void openUnitOfMeasureBottomSheet({int? index}) {
    bool forAddUOM = index != null;
    final List<ItemDropDownListModel> addUOMDropDown =
        List.from(unitOfMeasureList);
    addUOMDropDown.removeWhere(
      (element) => element == selectedUnitOfMeasure,
    );

    dialogService.showBottomSheet(
      title: 'Select Unit of Measure',
      child: GenericSheet<ItemDropDownListModel>(
        dataList: forAddUOM ? addUOMDropDown : unitOfMeasureList,
        nameExtractor: (u) => u.name,
        selectedData: forAddUOM
            ? addUomListCtrl[index].selectedUom
            : selectedUnitOfMeasure,
        onTap: (res) {
          dialogService.dialogComplete(AlertResponse(status: true));

          if (!forAddUOM) {
            if (selectedUnitOfMeasure == res) return;
            addUomListCtrl.clear();

            selectedUnitOfMeasure = res;
            unitOfMeasureCtrl.text = res.name ?? "";
          } else {
            addUomListCtrl[index].selectedUom = res;
            addUomListCtrl[index].uomListCtrl.text = res.name ?? "";
          }
          setState;
        },
      ),
    );
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

  void openSalesPurchaseIncExcTaxBottomSheet([bool isPurchase = false]) {
    dialogService.showBottomSheet(
      title: 'Select Tax Preference',
      child: GenericSheet<GstTaxModel>(
        dataList: incExcTaxPList,
        nameExtractor: (u) => u.title,
        selectedData: isPurchase ? selectedPurchaseGstTax : selectedSalesGstTax,
        onTap: (res) {
          if (isPurchase) {
            selectedPurchaseGstTax = res;
          } else {
            selectedSalesGstTax = res;
          }
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

  void toggleOpeningStock() {
    haveOpeningStock = !haveOpeningStock;
    setState;
    if (!haveOpeningStock) {
      openingStockCtrl.text = "0";
      minStockReminderCtrl.text = "0";
    }
    // else {
    //   openingStockCtrl.clear();
    //   minStockReminderCtrl.clear();
    // }
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

