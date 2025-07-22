import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yoloworks_invoice/services/event_bus_service.dart';

import '../../../../../app/constants/strings.dart';
import '../../../../../core/errors/error_response_exception.dart';
import '../../../../../locator.dart';
import '../../../../../app/constants/app_constants.dart';

import '../../../../../router.dart';
import '../../../../../services/dialog_service/alert_response.dart';
import '../../../../../services/dialog_service/snackbar_service.dart';

import '../../../../../utils/debounce.dart';
import '../../../../item/model/item_units.dart';
import '../../../data/item_list_repository.dart';
import '../../../../item/model/item_tax_list_model.dart';

import '../../../models/item_model/item_list_model.dart';
import '../../../models/item_model/sales_line_item.dart';
import '../../../models/master_model/gst_tax_model.dart';
import '../../../models/master_model/scheme_list_model.dart';
import '../../../models/sales_params_request_model/sales_params_request_model.dart';

import 'widgets/update_hsn_code_widget.dart';
import '../../widgets/generic_sheet.dart';
import '../../widgets/adjustment_discount_widget.dart';

part 'add_items_ctrl.g.dart';

@riverpod
class AddItemCtrl extends _$AddItemCtrl {
  @override
  AsyncValue<void> build() {
    return AsyncValue.loading();
  }

  AsyncValue<void> get setState => state = AsyncValue.data(null);

  int discountType = 1;
  int selectedIndex = 0;
  ItemTaxListModel? selectedTaxItem;
  ItemTaxListModel? selectedCessItem;
  List<ItemTaxListModel> taxList = [];
  List<ItemTaxListModel> cessList = [];

  ItemUnit? selectedItemUnit;
  ItemDatum? selectedLineItem;
  List<ItemUnit> itemUnitList = [];
  SalesLineItem? selectedSalesLineItem;
  List<SalesLineItem> selectedItemsList = [];
  AddItemRequestModel? addItemRequestModel;

  String? hsnCode;
  String? skuCode;

  final qtyCtrl = TextEditingController();
  final rateCtrl = TextEditingController();
  final noteCtrl = TextEditingController();
  final itemCtrl = TextEditingController();
  final hsnCodeCtrl = TextEditingController();
  final discountCtrl = TextEditingController();

  bool isHsnCodeLoading = false;
  final hsnCodeFormKey = GlobalKey<FormState>();
  final addItemsFormKey = GlobalKey<FormState>();

  String? errorMsg;

  Future onInit(AddItemRequestModel? addItemReq) async {
    addItemRequestModel = addItemReq;
    taxList = addItemRequestModel?.taxList ?? [];
    cessList = addItemRequestModel?.cessList ?? [];
    discountType = addItemRequestModel?.discountType ?? 1;
    selectedIndex = addItemRequestModel?.selectedIndex ?? 0;
    List<SalesLineItem> items = (addItemRequestModel?.selectedItemList as List)
        .map((item) => SalesLineItem.fromJson(item))
        .toList();

    selectedItemsList = items;

    onRetrieveItem();
    setState;
  }

  void onRetrieveItem() {
    if (!isEdit) {
      discountType = addItemRequestModel?.discountType ?? 1;
      return;
    }
    selectedSalesLineItem = selectedItemsList[selectedIndex];
    if (selectedSalesLineItem?.errorMsg?.isNotEmpty == true)
      errorMsg = selectedSalesLineItem?.errorMsg;
    discountType = selectedSalesLineItem?.lineItemDiscountType ?? 1;
    selectedCessItem = selectedSalesLineItem?.cessId != null
        ? cessList.singleWhere((t) => t.id == selectedSalesLineItem?.cessId)
        : null;
    selectedTaxItem = selectedSalesLineItem?.taxId != null
        ? taxList.singleWhere((t) => t.id == selectedSalesLineItem?.taxId)
        : null;
    qtyCtrl.text =
        AppConstants.removeZero(selectedSalesLineItem?.qtyValue ?? 1);
    rateCtrl.text =
        AppConstants.removeZero(selectedSalesLineItem?.priceValue ?? 0);
    noteCtrl.text = selectedSalesLineItem?.notes ?? '';
    itemCtrl.text = selectedSalesLineItem?.itemName ?? '';
    hsnCodeCtrl.text = selectedSalesLineItem?.hsnCode ?? '';
    discountCtrl.text = selectedSalesLineItem?.lineItemDiscountValue ?? '';
    selectedItemUnit = selectedSalesLineItem?.itemUnit;
    selectedLineItem = selectedSalesLineItem?.itemData;
    itemUnitList = selectedSalesLineItem?.itemUnitList ?? [];
  }

  Future<List<ItemDatum>> fetchData(String value) async {
    try {
      debugPrint('isSales $isSales');
      final itemList = isSales
          ? await ref.read(itemListRepositoryProvider).getItemList(
                page: 1,
                search: value,
                priceListId: addItemRequestModel?.priceListId,
              )
          : await ref.read(itemListRepositoryProvider).getPurchaseItemList(
                page: 1,
                search: value,
              );
      debugPrint('itemList.data ${itemList.toJson()}');
      return itemList.data ?? [];
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    return [];
  }

  Future updateHsnCode() async {
    if ((hsnCodeFormKey.currentState?.validate() == false)) return;
    if (hsnCodeCtrl.text.isEmpty) return;

    isHsnCodeLoading = true;
    setState;

    try {
      final res = await ref
          .read(itemListRepositoryProvider)
          .updateHsnCode(id: selectedLineItem!.id!, code: hsnCodeCtrl.text);
      if (res != null) {
        selectedSalesLineItem?.hsnCode = hsnCodeCtrl.text;
      }
    } catch (e) {
      debugPrint('exception $e');
      toastMsg('HSN Code is not updated.');
    }

    dialogService.dialogComplete(AlertResponse(status: true));
    isHsnCodeLoading = false;
    setState;
  }

  void onSelectItem(ItemDatum item) async {
    selectedLineItem = item;
    itemCtrl.text = item.item ?? item.name ?? '';
    selectedItemUnit = item.itemUnits?.first;
    itemUnitList = item.itemUnits ?? [];
    hsnCodeCtrl.text = item.hsnCode ?? '';

    if (item.cessId != null || item.cessRateId != null) {
      selectedCessItem = cessList
          .firstWhere((t) => t.id == item.cessId || t.id == item.cessRateId);
    }
    if (item.taxId != null) {
      selectedTaxItem = taxList.firstWhere((t) => t.id == item.taxId);
    }

    if (qtyCtrl.text.isEmpty) {
      qtyCtrl.text = '1';
    }

    if (selectedItemUnit != null) {
      rateCtrl.text = AppConstants.removeZero(selectedItemUnitPrice ?? 0);
    }

    _addItem(item);
    //TODOS
    //call item-validation & scheme api
    await _addSchemeList();
    AppConstants.removeFocus();
    setState;
  }

  void _addItem(ItemDatum item) {
    final qty = double.tryParse(qtyCtrl.text) ?? 1;
    selectedSalesLineItem = SalesLineItem(
      id: AppConstants.microSecondPK,
      pk: selectedSalesLineItem?.pk,
      qty: qty,
      itemId: item.id,
      itemName: item.item ?? item.name,
      skuCode: item.skuCode,
      hsnCode: item.hsnCode,
      itemUnit: selectedItemUnit,
      itemUnitList: item.itemUnits,
      itemData: selectedLineItem,
      taxId: selectedTaxItem?.id,
      cessId: selectedCessItem?.id,
      taxValue: selectedTaxItem?.value,
      unitId: selectedItemUnit?.id,
      unitName: selectedItemUnit?.unit,
      itemUnitId: selectedItemUnit?.id,
      cessRateName: selectedCessItem?.value,
      lineItemDiscountType: discountType,
      price: selectedItemUnitPrice,
      originalPrice: selectedItemUnit?.sellingPrice,
      isGstRegistered: addItemRequestModel?.isGstRegistered,
      isSalesTaxExclusive: addItemRequestModel?.isExcludingTax,
      primaryUnitQty: (selectedItemUnit?.baseQuantity ?? 1) * qty,
      isTaxInclusive: addItemRequestModel?.isExcludingTax == false,
    );
  }

  showConfirmPop(context) async {
    AlertResponse? response = await dialogService.showConfirmationAlertDialog(
      secondaryButton: 'No',
      primaryButton: "Yes",
      title: (itemCtrl.text.isNotEmpty)
          ? "Are you sure you want to go back without saving the current ${itemCtrl.text.toUpperCase()} item changes?"
          : "Are you sure you want to go back?",
    );
    if (response?.status == true) {
      navigationService.pop();
    }
  }

  void onChangeDiscount(String value) {
    Debounce.debounce('on-discount-change', () {
      try {
        if (value.isEmpty) {
          selectedSalesLineItem?.lineItemDiscountValue = null;
          setState;
          return;
        }
        final rate = double.tryParse(value);
        debugPrint('rate $rate');
        selectedSalesLineItem?.lineItemDiscountValue = value;
      } catch (e) {
        debugPrint('discount change exception $e');
      }
      setState;
    });
  }

  void onPriceChange(String value) {
    Debounce.debounce('on-price-change', () {
      try {
        if (value.isEmpty) return;

        final rate = double.tryParse(value);
        selectedSalesLineItem?.price = rate;
      } catch (e) {
        debugPrint('price change exception $e');
      }
      setState;
    });
  }

  void onQtyChange(String value) {
    Debounce.debounce('on-qty-change', () async {
      try {
        errorMsg = null;
        if (value.isEmpty) return;
        final qty = double.tryParse(value);

        if (qty == 0) {
          errorMsg = "Quantity can't be zero";
          setState;
          return;
        }

        selectedSalesLineItem?.qty = qty;
        selectedSalesLineItem?.primaryUnitQty =
            (qty ?? 1) * (selectedItemUnit?.baseQuantity ?? 1);

        debugPrint('removeZero in ${selectedSalesLineItem?.hsnCode}');
        //TODOs
        // 1.call scheme api
        // 2.add scheme to selectedSalesLineItem.schemeList
        await _addSchemeList();
      } catch (e) {
        debugPrint('qty change exception $e');
      }
      setState;
    }, const Duration(milliseconds: 200));
  }

  Future _addSchemeList() async {
    if (addItemRequestModel?.isValidate == false) return;
    final scheme = await _getSchemeList();
    if (scheme == null || scheme.schemes?.isEmpty == true) return;
    selectedSalesLineItem?.isFocItemPresent = true;
  }

  void removeFoc([bool isRefresh = true]) {
    selectedSalesLineItem?.schemeList = null;
    selectedSalesLineItem?.schemeLength = 0;
    if (isRefresh) setState;
  }

  Future<SchemeListModel?> _getSchemeList() async {
    try {
      final res = await ref.read(itemListRepositoryProvider).getSchemeList(
            req: SchemeRequestData(
              itemId: selectedSalesLineItem?.itemId,
              quantity: selectedSalesLineItem?.qty,
              totalQty: totalQty,
              client: addItemRequestModel?.clientId,
              unit: selectedItemUnit?.unitId,
              itemUnit: selectedItemUnit?.id,
              warehouseId: addItemRequestModel?.warehouseId,
            ),
          );
      errorMsg = null;
      return res;
    } on ErrorResponseException catch (e) {
      debugPrint('exception $e');
      final response = e.error?.data;
      final msg = '${response?.data['message']}';
      errorMsg = '$msg';
    }
    return null;
  }

  //Save-item
  Future addNewItem([bool isPop = false]) async {
    AppConstants.removeFocus();

    if (!isItemSelected) {
      return toastMsg('Please add item.');
    }

    if (errorMsg != null) {
      return toastMsg('Please check ${selectedSalesLineItem?.itemName} item.');
    }

    if (selectedSalesLineItem?.formattedSubTotal.contains('-') == true) {
      return toastMsg(AppStrings.totalAmtError);
    }
    
    selectedSalesLineItem?.itemUnit = selectedItemUnit;
    selectedSalesLineItem?.unitId = selectedItemUnit?.id;
    selectedSalesLineItem?.unitName = selectedItemUnit?.unit;
    selectedSalesLineItem?.itemUnitId = selectedItemUnit?.id;
    selectedSalesLineItem?.notes = noteCtrl.text;
    if (isEdit)
      selectedItemsList[selectedIndex] = selectedSalesLineItem!;
    else
      selectedItemsList.add(selectedSalesLineItem!);

    toastMsg('Item is added successfully', false);
    onPopEvent();
    if (!isPop) _onClear();
    if (isPop) {
      navigationService.pop();
    }
  }

  void onPopEvent() {
    eventBusService.eventBus
        .fire(AddItemRefreshEvent(data: selectedItemsList.toList()));
  }

  void openScheme() async {
    AppConstants.removeFocus();
    Map input = {
      'totalQty': totalQty,
      'unit': selectedItemUnit?.unitId,
      'itemId': selectedSalesLineItem?.itemId,
      'client': addItemRequestModel?.clientId,
      'itemUnit': selectedItemUnit?.id,
      'quantity': selectedSalesLineItem?.qty,
      'warehouse': addItemRequestModel?.warehouseId,
      'scheme_list': selectedSalesLineItem?.schemeList,
    };
    final res =
        await navigationService.pushNamed(Routes.schemeList, arguments: input);
    if (res == null) return;

    selectedSalesLineItem?.schemeList = res as List<int>;
    selectedSalesLineItem?.schemeLength = res.length;
    setState;
  }

  void openItemUnitBottomSheet() {
    if (!isItemSelected) {
      return toastMsg('Please add item.');
    }

    dialogService.showBottomSheet(
      title: 'UOM',
      child: GenericSheet<ItemUnit>(
        dataList: itemUnitList,
        nameExtractor: (u) => u.unit?.toUpperCase(),
        selectedData: selectedItemUnit,
        onTap: (res) async {
          dialogService.dialogComplete(AlertResponse(status: true));

          if (selectedItemUnit == res) return;
          selectedItemUnit = res;

          selectedSalesLineItem?.price = selectedItemUnitPrice;
          rateCtrl.text = AppConstants.removeZero(selectedItemUnitPrice ?? 0.0);

          //clear scheme & call scheme api
          removeFoc();
          selectedSalesLineItem?.isFocItemPresent = null;
          //call item-validation api
          await _addSchemeList();

          setState;
        },
      ),
    );
  }

  void openGSTCessBottomSheet(bool isGST) {
    if (!isItemSelected) {
      return toastMsg('Please add item.');
    }

    dialogService.showBottomSheet(
      title: isGST ? 'GST Tax' : 'CESS Tax',
      child: GenericSheet<ItemTaxListModel>(
        dataList: isGST ? taxList : cessList,
        nameExtractor: (u) => u.name,
        selectedData: isGST ? selectedTaxItem : selectedCessItem,
        onTap: (res) {
          dialogService.dialogComplete(AlertResponse(status: true));

          if (isGST) {
            selectedTaxItem = res;
            selectedSalesLineItem?.taxId = selectedTaxItem?.id;
            selectedSalesLineItem?.taxValue = selectedTaxItem?.value;
            return;
          }

          selectedCessItem = res;
          selectedSalesLineItem?.cessId = selectedCessItem?.id;
          selectedSalesLineItem?.cessRateName = selectedCessItem?.value;
          setState;
        },
      ),
    );
  }

  //discount sheet
  void discountBottomSheet() {
    if (!isItemSelected) {
      return toastMsg('Please add item.');
    }

    dialogService.showBottomSheet(
      title: 'Discount',
      isDivider: false,
      showCloseIcon: false,
      dismissable: false,
      child: AdjustmentDiscountWidget(
        isDiscount: true,
        discountAmtIndex: discountType,
        adjustmentDiscountModel: discountModel,
        onTap: (int type) {
          discountType = type;
          discountCtrl.clear();

          selectedSalesLineItem?.lineItemDiscountType = type;
          selectedSalesLineItem?.lineItemDiscountValue = null;
          dialogService.dialogComplete(AlertResponse(status: true));
          setState;
        },
      ),
    );
  }

  void openHSNCodeBottomSheet() {
    hsnCodeCtrl.text = selectedLineItem?.hsnCode ?? '';
    dialogService.showBottomSheet(
      title: 'HSN Code',
      isDivider: false,
      showCloseIcon: false,
      child: UpdateHsnCodeWidget(),
    );
  }

  void _onClear() {
    FocusManager.instance.primaryFocus?.unfocus();

    hsnCode = null;
    skuCode = null;
    errorMsg = null;

    qtyCtrl.clear();
    rateCtrl.clear();
    noteCtrl.clear();
    itemCtrl.clear();
    hsnCodeCtrl.clear();
    discountCtrl.clear();

    selectedTaxItem = null;
    selectedCessItem = null;
    selectedItemUnit = null;
    selectedLineItem = null;
    selectedSalesLineItem = null;

    setState;
  }

  bool get isEdit => addItemRequestModel?.isEdit == true;
  bool get isItemSelected => selectedSalesLineItem?.id != null;

  double get totalQty {
    final id = selectedSalesLineItem?.id;
    return _totalQty(selectedItemsList
        .where((t) => t.id != id)
        .where((t) => t.itemId == selectedSalesLineItem?.itemId)
        .toList());
  }

  double _totalQty(List<SalesLineItem> itemList) {
    double qty = 0.0;

    itemList.forEach((e) {
      qty += e.primaryUnitQty ?? 0;
    });

    return qty + (selectedSalesLineItem?.primaryUnitQty ?? 0);
  }

  bool get isSales =>
      addItemRequestModel?.isSalesInvoice == true ||
      addItemRequestModel?.isSalesOrder == true;

  bool get isValidate => addItemRequestModel?.isValidate == true;

  double? get selectedItemUnitPrice => (isSales
      ? selectedItemUnit?.sellingPrice
      : selectedItemUnit?.purchasePrice);

  void toastMsg(String msg, [bool isFailed = true]) {
    SnackbarService.toastMsg(msg, isFailed);
  }
}
