import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yoloworks_invoice/core/enums/order_type.dart';
import 'package:yoloworks_invoice/core/extension/string_extension.dart';

import 'package:yoloworks_invoice/core/extension/address_extenstion.dart';
import 'package:yoloworks_invoice/core/extension/currency_extension.dart';
import 'package:yoloworks_invoice/features/purchase/view/purchase_order/purchase_order_controller.dart';

import '../../api/customer_request.dart';
import '../../api/item_list_request.dart';
import '../../api/sales_order_request.dart';
import '../../api/sales_invoice_request.dart';
import '../../api/master_data_api_request.dart';

import '../../app/constants/app_constants.dart';
import '../../core/extension/datetime_extension.dart';
import '../../core/errors/error_response_exception.dart';

import '../../router.dart';
import '../../locator.dart';

import '../date_picker_service.dart';
import '../dialog_service/alert_response.dart';

import '../../utils/logger.dart';
import '../../utils/debounce.dart';
import '../../utils/gst_calculation_utils.dart';

import '../../features/bill_preview/models/bill_preview_model.dart';
import '../../features/dashboard/data/customer_repository.dart';
import '../../features/dashboard/view/dashboard_controller.dart';
import '../../features/dashboard/models/customer/state_model.dart';
import '../../features/dashboard/models/customer/customer_detail_model.dart';

import '../../features/charts_of_account/models/charts_of_accounts_list_model.dart';
import '../../features/charts_of_account/views/widgets/charts_of_account_widget.dart';

import '../../features/sales/data/item_list_repository.dart';
import '../../features/sales/data/master_data_repository.dart';
import '../../features/sales/data/sales_order_repository.dart';
import '../../features/sales/data/sales_invoice_repository.dart';

import '../../features/sales/models/master_model/tax_model.dart';
import '../../features/sales/models/item_model/warehouse_item_validation_model.dart';

import '../../features/item/model/item_tax_list_model.dart';
import '../../features/sales/models/master_model/gst_tax_model.dart';
import '../../features/sales/models/item_model/sales_line_item.dart';
import '../../features/sales/models/master_model/price_list_model.dart';
import '../../features/sales/models/master_model/bill_config_model.dart';
import '../../features/sales/models/item_model/apply_price_list_model.dart';
import '../../features/sales/models/master_model/tds_tcs_section_model.dart';
import '../../features/sales/models/master_model/transport_mode_model.dart';
import '../../features/sales/models/master_model/warehouse_list_model.dart';
import '../../features/sales/models/master_model/due_period_list_model.dart';
import '../../features/sales/models/invoice/sales_invoice_details_model.dart';
import '../../features/sales/models/sales_order/sales_order_detail_model.dart';
import '../../features/sales/models/master_model/sales_person_list_model.dart';
import '../../features/sales/models/sales_params_request_model/sales_params_request_model.dart';

import '../../features/sales/views/orders/sales_order/sales_order_ctrl.dart';
import '../../features/purchase/view/purchase_invoice/purchase_invoice_ctrl.dart';
import '../../features/sales/views/invoices/sales_invoice/sales_invoice_ctrl.dart';

import '../../features/sales/views/widgets/generic_sheet.dart';
import '../../features/sales/views/widgets/gst_break_down_sheet.dart';
import '../../features/sales/views/widgets/discount_details_widget.dart';
import '../../features/sales/views/widgets/adjustment_discount_widget.dart';

import '../event_bus_service.dart';
import '../dialog_service/snackbar_service.dart';

part 'sales_purchase_master_api.dart';
part 'sales_purchase_refresh_event.dart';
part 'sales_purchase_master_bottom_sheet.dart';

mixin SalesPurchaseMasterService {
  //repos
  final customerRepo = CustomerRepository(customerRequest: CustomerRequest());
  final itemRepo = ItemListRepository(itemListRequest: ItemListRequest());
  final salesOrderRepo =
      SalesOrderRepository(salesOrderRequest: SalesOrderRequest());
  final salesInvoiceRepo =
      SalesInvoiceRepository(salesInvoiceRequest: SalesInvoiceRequest());
  final masterRepo =
      MasterDataRepository(masterDataApiRequest: MasterDataApiRequest());

  Ref<AsyncValue<void>>? reference;

  final unFocusKey = GlobalKey<FormState>();

  String? billNo;
  List<StateModel> stateList = [];
  List<WarehouseListModel>? warehouseList;
  List<SalesPersonListModel>? salesPersonList;
  List<TransportModeModel>? transportModeList;

  bool isRoundOff = false;
  bool isBeforeTax = false;
  bool isGstRegister = false;
  bool isItemListDisabled = true;
  bool isInventoryEnabled = true;

  TransportModeModel? selectedMOT;
  StateModel? selectedPlaceOfSupply;
  WarehouseListModel? selectedWarehouse;
  SalesPersonListModel? selectedSalesPerson;

  PriceListModel? selectedPriceList;
  CustomerDetailModel? customerData;
  BillConfigurationModel? billConfig;

  TaxModel? tdsTcsValueModel = TaxModel();
  List<GstTaxModel> gstTaxModelList = gstTaxModel;
  GstTaxModel selectedGstTaxModel = gstTaxModel.first;
  TdsTcsModel selectedTdsTcsModel = tdsTcsModel.first;

  List<TaxModel> tdsList = [];
  List<TaxModel> tcsList = [];
  List<ItemTaxListModel> taxList = [];
  List<ItemTaxListModel> cessList = [];
  List<TdsTcsSectionModel> tdsSectionList = [];
  List<TdsTcsSectionModel> tcsSectionList = [];

  List<PriceListModel> priceList = [];
  List<DuePeriodListModel> duePeriodList = [];

  List<SalesLineItem> selectedItemList = [];
  List<Map<String, dynamic>> taxBreakDownList = <Map<String, dynamic>>[];

  DateTime? dueDateTime;
  DateTime? billDateTime;
  DateTime? deliveryDate;
  DateTime? referenceDate;
  DateTime? expectedDeliveryDate;
  DuePeriodListModel? selectedDuePeriod;

  //accounts
  NodesList? selectedAccountItem;
  final accountsTextCtrl = TextEditingController();

  //text-ctrl
  final taxTextCtrl = TextEditingController();
  final noteTextCtrl = TextEditingController();
  final roundedTextCtrl = TextEditingController();
  final subTotalTextCtrl = TextEditingController();
  final adjustAmtTextCtrl = TextEditingController();
  final tdsTcsAmtTextCtrl = TextEditingController();
  final discountAmtTextCtrl = TextEditingController();
  final shippingAmtTextCtrl = TextEditingController();
  final termConditionTxtCtrl = TextEditingController();
  final referenceBillNoTextCtrl = TextEditingController(text: '');
  final adjustmentNameTextCtrl = TextEditingController(text: 'Adjustment');

  final dueDateTextCtrl = TextEditingController();
  final billDateTextCtrl = TextEditingController();
  final warehouseTextCtrl = TextEditingController();
  final salesPersonTextCtrl = TextEditingController();
  final paymentTermTextCtrl = TextEditingController();
  final deliveryDateTextCtrl = TextEditingController();
  final placeOfSupplyTextCtrl = TextEditingController();
  final modeOfTransportTextCtrl = TextEditingController();
  final referenceBillDateTextCtrl = TextEditingController();
  final expectedDeliveryDateTextCtrl = TextEditingController();

  int? client;
  int? orderId;

  bool isError = false;
  bool isConvert = false;
  bool isTermsEdit = false;

  double totalCost = 0.0;
  double tempTotalCost = 0.0;
  AdjustmentDiscountModel selectedAdjustment = adjustmentModel.first;

  // discount-type -> 1 => Percent,2 => Amount
  int discountTypeIndex = 1;
  String discountText = '0.00 %';
  String adjustmentText = '-₹0.00';

  SalesParamsRequestModel? paramReq;
  SalesOrderDetailModel? salesOrderDetailModel;
  SalesInvoiceDetailModel? salesInvoiceDetailModel;

  Future init(
      Ref<AsyncValue<void>> riverpodRef, SalesParamsRequestModel? data) async {
    paramReq = data;
    orderId = paramReq?.order;
    client = paramReq?.clientId;
    reference = riverpodRef;
    isGstRegister = dashboardController.org?.registrationType == 1;

    await _onLoad();
    if ((isEdit || isConvert) && orderId != null) {
      if (data?.billType == BillType.salesOrder ||
          data?.billType == BillType.purchaseOrder) {
        await getSalesOrderDetails();
      }
      if (data?.billType == BillType.salesInvoice ||
          data?.billType == BillType.purchaseInvoice) {
        await getSalesInvoiceDetails();
      }
    }
    if (!isEdit) {
      onSetDateFieldValue();
    }
    addItemEventListener();
  }

  Future _onLoad() async {
    await onMasterApiCall();
  }

  void onShowItems() {
    isItemListDisabled = !isItemListDisabled;
    updateNotifier();
  }

  void onViewPriceListItem() async {
    final res =
        await navigationService.pushNamed(Routes.selectPriceList, arguments: {
      'price_list': priceList,
      'selected_price_list': selectedPriceList,
    });
    if (res == null) return;
    //change items price and update amt
    selectedPriceList = res as PriceListModel;
    if (selectedPriceList == null) return;
    _mapPriceList();
  }

  Future removePriceList() async {
    selectedPriceList = null;
    await _mapPriceList();
  }

  Future _mapPriceList() async {
    final input = {
      'qty': selectedItemList.map((e) => e.qty ?? 0).join(','),
      'item': selectedItemList.map((e) => e.itemId ?? 0).join(','),
      'itemUnit': selectedItemList.map((e) => e.unitId ?? 0).join(','),
      'priceId': selectedPriceList?.id
    };

    final priceListRes = await _applyPriceList(input);
    if (priceListRes.isEmpty) return;

    for (final salesItem in selectedItemList) {
      final priceList = priceListRes
          .map((e) => e.unitsList)
          .expand((r) => r ?? <ItemUnitList>[])
          .toList();
      if (priceList.isEmpty) continue;

      final unit = priceList.singleWhere((t) => t.id == salesItem.unitId);
      if (unit.id == null) continue;

      salesItem.lineItemDiscountValue = null;
      salesItem.price = unit.sellingPrice ?? (salesItem.price);
    }

    _calCulateTotal();
  }

  Future<List<ApplyPriceListModel>> _applyPriceList(Map input) async {
    try {
      return await itemRepo.applyPriceList(input: input);
    } catch (e, s) {
      Logger.e('error $e', s: s);
      return [];
    }
  }

  void onDeleteItem(int index) {
    selectedItemList.removeAt(index);
    _calCulateTotal();
    onItemValidate();
  }

  bool get isExcludingTax => (selectedGstTaxModel.id == 1);

  void onTermsEdit() {
    isTermsEdit = !isTermsEdit;
    updateNotifier();
  }

  Future getSalesInvoiceDetails() async {
    if (orderId == null) return;

    try {
      salesInvoiceDetailModel =
          await salesInvoiceRepo.getSalesInvoiceDetail(id: orderId!);
      if (salesInvoiceDetailModel == null &&
          salesInvoiceDetailModel?.itemDetails == null) return;

      final List<ItemDetail>? itemDetails =
          salesInvoiceDetailModel?.itemDetails;

      shippingAmtTextCtrl.text =
          salesInvoiceDetailModel?.shippingCharge.toCurrencyFormatString() ??
              '';
      noteTextCtrl.text = salesInvoiceDetailModel?.notes ?? '';
      termConditionTxtCtrl.text = salesInvoiceDetailModel?.terms ?? '';
      discountTypeIndex =
          salesInvoiceDetailModel?.isDiscountPercentage == true ? 1 : 2;
      discountAmtTextCtrl.text = discountTypeIndex == 2
          ? (salesInvoiceDetailModel?.discount?.toCurrencyFormatString() ?? '')
          : '${salesInvoiceDetailModel?.discount}%';
      billNo = salesInvoiceDetailModel?.invoiceNumber ?? billNo;
      isBeforeTax = salesInvoiceDetailModel?.isDiscountBeforeTax == true;
      subTotalTextCtrl.text =
          salesInvoiceDetailModel?.subTotal.toCurrencyFormatString() ?? '';

      final taxSource = salesInvoiceDetailModel?.taxSource;
      if (taxSource != null) {
        tdsTcsValueModel = TaxModel.fromJson(taxSource.toJson());
        final tdsValue = tdsList.where((t) =>
            t.id == tdsTcsValueModel?.id &&
            t.code == tdsTcsValueModel?.code &&
            t.name == tdsTcsValueModel?.name);
        final tcsValue = tcsList.where((t) =>
            t.id == tdsTcsValueModel?.id &&
            t.code == tdsTcsValueModel?.code &&
            t.name == tdsTcsValueModel?.name);

        if (tdsValue.isNotEmpty) {
          selectedTdsTcsModel = tdsTcsModel.first;
        } else if (tcsValue.isNotEmpty) {
          selectedTdsTcsModel = tdsTcsModel.last;
        }
      }

      if (salesInvoiceDetailModel?.customField?.isNotEmpty == true) {
        final customField = salesInvoiceDetailModel?.customField as Map;
        adjustmentNameTextCtrl.text = customField.keys.first;
        selectedAdjustment =
            salesInvoiceDetailModel?.adjustment.toString().contains('-') == true
                ? adjustmentModel.first
                : adjustmentModel.last;
        final value = customField.values.first;
        if (value != null) {
          adjustAmtTextCtrl.text = '₹${value.toString().replaceAll('-', '')}';
        }
      }

      if (salesInvoiceDetailModel?.placeOfSupply != null) {
        onSelectState(salesInvoiceDetailModel!.placeOfSupply!);
      }

      if (salesInvoiceDetailModel?.discountAccount != null) {
        onSelectPurchaseAccount(salesInvoiceDetailModel!.discountAccount!);
      }

      retrieveDateFieldsValue(
          salesInvoiceDetailModel?.dueTermId,
          salesInvoiceDetailModel?.dueDateFormatted,
          salesInvoiceDetailModel?.billDateFormatted);

      onSelectWarehouse();
      //select price-list
      selectDefaultPriceListItem(priceId: salesInvoiceDetailModel?.priceListId);
      _mapSalesLineItem(itemDetails ?? []);
    } catch (e, s) {
      Logger.e('error $e', s: s);
    }
  }

  Future getSalesOrderDetails() async {
    if (orderId == null) return;

    try {
      salesOrderDetailModel =
          await salesOrderRepo.getSalesOrderDetail(orderId: orderId!);
      if (salesOrderDetailModel == null &&
          salesOrderDetailModel?.itemDetails == null) return;
      final itemDetails = salesOrderDetailModel!.itemDetails;

      shippingAmtTextCtrl.text =
          salesOrderDetailModel?.shippingCharge.toCurrencyFormatString() ?? '';
      noteTextCtrl.text = salesOrderDetailModel?.notes ?? '';
      termConditionTxtCtrl.text = salesOrderDetailModel?.terms ?? '';
      discountTypeIndex =
          salesOrderDetailModel?.isDiscountPercentage == true ? 1 : 2;
      discountAmtTextCtrl.text = discountTypeIndex == 2
          ? (salesOrderDetailModel?.discount?.toCurrencyFormatString() ?? '')
          : '${salesOrderDetailModel?.discount}%';
      billNo = salesOrderDetailModel?.orderNumber ?? billNo;
      isBeforeTax = salesOrderDetailModel?.isDiscountBeforeTax == true;
      subTotalTextCtrl.text =
          salesOrderDetailModel?.subTotal.toCurrencyFormatString() ?? '';

      final taxSource = salesOrderDetailModel?.taxSource;
      if (taxSource != null) {
        tdsTcsValueModel = TaxModel.fromJson(taxSource.toJson());
        final tdsValue = tdsList.where((t) =>
            t.id == tdsTcsValueModel?.id &&
            t.code == tdsTcsValueModel?.code &&
            t.name == tdsTcsValueModel?.name);
        final tcsValue = tcsList.where((t) =>
            t.id == tdsTcsValueModel?.id &&
            t.code == tdsTcsValueModel?.code &&
            t.name == tdsTcsValueModel?.name);

        if (tdsValue.isNotEmpty) {
          selectedTdsTcsModel = tdsTcsModel.first;
        } else if (tcsValue.isNotEmpty) {
          selectedTdsTcsModel = tdsTcsModel.last;
        }
      }

      if (salesInvoiceDetailModel?.customField?.isNotEmpty == true) {
        final customField = salesOrderDetailModel?.customField as Map;
        adjustmentNameTextCtrl.text = customField.keys.first;
        selectedAdjustment =
            salesOrderDetailModel?.adjustment.toString().contains('-') == true
                ? adjustmentModel.first
                : adjustmentModel.last;
        final value = customField.values.first;
        if (value != null) {
          adjustAmtTextCtrl.text = '₹${value.toString().replaceAll('-', '')}';
        }
      }

      if (salesOrderDetailModel?.placeOfSupply != null) {
        onSelectState(salesOrderDetailModel!.placeOfSupply!);
      }

      if (salesOrderDetailModel?.modeOfTransportationId != null) {
        onSelectModeOfTransport(salesOrderDetailModel?.modeOfTransportationId);
      }

      if (salesOrderDetailModel?.referenceNo?.isNotEmpty == true) {
        referenceBillNoTextCtrl.text = '${salesOrderDetailModel?.referenceNo}';
      }

      retrieveDateFieldsValue(
        salesOrderDetailModel?.dueTermId,
        salesOrderDetailModel?.dueDateFormatted,
        salesOrderDetailModel?.billDateFormatted,
        salesOrderDetailModel?.deliveryDateFormatted,
        salesOrderDetailModel?.exceptedDeliveryDateFormatted,
        salesOrderDetailModel?.referenceDateFormatted,
      );

      onSelectWarehouse();
      //select price-list
      selectDefaultPriceListItem(priceId: salesOrderDetailModel?.priceListId);
      _mapSalesLineItem(itemDetails ?? []);
    } catch (e, s) {
      Logger.e('error $e', s: s);
    }
  }

  void _mapSalesLineItem(List<ItemDetail> itemDetails) {
    itemDetails.forEach((item) {
      final isFocItemPresent = item.scheme?.isNotEmpty == true;
      final selectedUnit =
          item.itemUnits?.firstWhere((t) => t.id == item.unitId);
      final isLineDiscountNotEmpty = item.discount == 0.0;

      final lineItem = SalesLineItem(
        id: item.id,
        pk: item.id,
        taxValue: item.tax,
        taxId: item.taxId,
        cessId: item.cessId,
        cessRateName: item.cess,
        itemId: item.itemId,
        itemName: item.item,
        originalPrice: item.originalPrice,
        isGstRegistered: isGstRegister,
        isFocItemPresent: isFocItemPresent,
        unitName: item.unit,
        itemUnitId: item.unitId,
        unitId: selectedUnit?.unitId,
        itemUnit: selectedUnit,
        itemUnitList: item.itemUnits,
        isSalesTaxExclusive: item.isExclusiveTax,
        isLineItemDisInclusive:
            isLineDiscountNotEmpty ? null : !(item.isExclusiveTax == true),
        lineItemDiscountType: item.isDiscountPercentage == true ? 1 : 2,
        lineItemDiscountValue:
            isLineDiscountNotEmpty ? null : '${item.discount ?? '0'}',
        schemeList: item.scheme!.map((m) => m.id ?? 0).toList(),
        qty: item.quantity,
        price: item.rate,
        notes: item.itemNotes,
      );

      selectedItemList.add(lineItem);
    });
    _calCulateTotal();
  }

  bool get isCustom => (selectedDuePeriod?.name == 'custom');

  void onClear() {
    taxTextCtrl.clear();
    roundedTextCtrl.clear();
    subTotalTextCtrl.clear();
    adjustAmtTextCtrl.clear();
    shippingAmtTextCtrl.clear();
    discountAmtTextCtrl.clear();

    totalCost = 0.0;
    selectedAdjustment = adjustmentModel.first;
    discountTypeIndex = 1;
    discountText = '0.00 %';
  }

  void onChangeTaxModel(GstTaxModel selectedTax) {
    selectedGstTaxModel = selectedTax;
    for (final e in selectedItemList) {
      e.isSalesTaxExclusive = isExcludingTax;
      e.isLineItemDisInclusive =
          e.lineItemDiscountValue != null && e.lineItemDiscountValue != '0'
              ? !isExcludingTax
              : null;
    }
    _calCulateTotal();
  }

  void onViewItem([bool isEdit = false, int index = 0]) async {
    final isSalesInvoice = paramReq?.billType == BillType.salesInvoice;
    final isSalesOrder = paramReq?.billType == BillType.salesOrder;
    final isPurchaseInvoice = paramReq?.billType == BillType.purchaseInvoice;

    List<Map<String, dynamic>> jsonList =
        selectedItemList.map((item) => item.toJson()).toList();

    final addItemReq = AddItemRequestModel(
      isEdit: isEdit,
      clientId: client,
      taxList: taxList,
      cessList: cessList,
      selectedIndex: index,
      isGstRegistered: isBeforeTax,
      isExcludingTax: isExcludingTax,
      discountType: discountTypeIndex,
      priceListId: selectedPriceList?.id,
      warehouseId: selectedWarehouse?.id,
      selectedItemList: jsonList,
      isValidate: isSalesInvoice,
      isSalesInvoice: isSalesInvoice,
      isSalesOrder: isSalesOrder,
      isPurchaseInvoice: isPurchaseInvoice,
    );
    navigationService.pushNamed(
      Routes.addItems,
      arguments: addItemReq,
    );
  }

  addItemEventListener() {
    eventBusService.eventBus.on<AddItemRefreshEvent>().listen((event) async {
      selectedItemList = event.data.toList();
      addDefaultPurchaseInvoiceAccounts();
      _calCulateTotal();
    });
  }

  Future onItemValidate() async {
    if (paramReq?.billType != BillType.salesInvoice) {
      updateNotifier();
      return;
    }

    final itemList = selectedItemList.map((e) => e.itemId ?? 0).toList();
    final List<int> itemUnitList =
        selectedItemList.map((e) => e.itemUnitId ?? 0).toList();
    final List<double> itemQtyList =
        selectedItemList.map((e) => e.qtyValue).toList();
    try {
      final res = await salesInvoiceRepo.warehouseItemValidate(
          itemList, itemUnitList, itemQtyList, selectedWarehouse?.id ?? 0);
      Logger.d('res $res');
      mapSalesLineErrorList([]);
    } on ErrorResponseException catch (e, s) {
      final response = (e.error?.data?.data as List<dynamic>)
          .map((item) => WarehouseItemValidationModel.fromJson(
              item as Map<String, dynamic>))
          .toList();

      // warehouseItemValidationModelFromJson(
      //     e.error?.data
      //
      // );
      mapSalesLineErrorList(response);
    }
  }

  void mapSalesLineErrorList(List<WarehouseItemValidationModel> res) {
    selectedItemList.forEach((e) {
      final index = res.indexWhere(
          (t) => t.itemId == e.itemId && t.itemUnit == e.itemUnitId);
      if (index >= 0) {
        e.errorMsg = res[index].stocks;
      } else {
        e.errorMsg = null;
      }
    });
    updateNotifier();
  }

  String get _discountDetails {
    if (reference == null) return '';
    final afterBeforeTaxText = !isBeforeTax ? '(After)' : '(Before)';
    final discountAppliedAmt =
        GSTCalculationUtils.subAmtFormatValue(discountAppliedText);
    final discount = double.parse(getDiscountprice);
    if (discountTypeIndex == 2) {
      return 'Discount$afterBeforeTaxText : ${selectedItemList.isNotEmpty ? AppConstants.amtToPercentage(subTotal: discountAppliedAmt, amt: discount) : '0.0'}%';
    }
    return 'Discount$afterBeforeTaxText : ${selectedItemList.isNotEmpty ? AppConstants.percentageToAmt(amt: discountAppliedAmt, percent: discount).toCurrencyFormatString() : '₹0.0'}';
  }

  String get getDiscountprice {
    if (reference == null) return '';
    return discountTypeIndex == 2
        ? AppConstants.textSymbolRemover(discountAmtTextCtrl.text)
        : AppConstants.textSymbolRemover(discountAmtTextCtrl.text, symbol: '%');
  }

  double get discountPriceValue {
    return double.parse(discountTypeIndex == 2
        ? AppConstants.textSymbolRemover(discountAmtTextCtrl.text)
        : AppConstants.textSymbolRemover(discountAmtTextCtrl.text,
            symbol: '%'));
  }

  double get taxPriceValue {
    return double.parse(taxTextCtrl.text.isEmpty
        ? '0'
        : AppConstants.textSymbolRemover(taxTextCtrl.text));
  }

  double getDiscountTdsTcsValue(double totalAmt) {
    if (discountTypeIndex == 1) {
      return totalAmt - (totalAmt * (discountPriceValue / 100));
    }
    return totalAmt - discountPriceValue;
  }

  String get discountAppliedText {
    if (reference == null) return '';
    double subTotal =
        GSTCalculationUtils.subAmtFormatValue(subTotalTextCtrl.text);
    double taxTotal = GSTCalculationUtils.subAmtFormatValue(taxTextCtrl.text);

    if (!isExcludingTax) {
      double total = 0;
      for (final e in selectedItemList) {
        final subAmt =
            GSTCalculationUtils.subAmtFormatValue(e.formattedSubTotal);
        final taxPercentage = e.taxPercentage;
        final tax = GSTCalculationUtils.inclusiveTax(
            {'amount': subAmt, 'taxPercentage': taxPercentage});
        total = total + subAmt - tax;
      }

      if (!isBeforeTax) {
        double afterTaxAmt = total + taxTotal;
        return afterTaxAmt.toCurrencyFormatString();
      }

      return total.toCurrencyFormatString();
    }

    if (!isBeforeTax) {
      double afterTaxAmt = subTotal + taxTotal;
      return afterTaxAmt.toCurrencyFormatString();
    }

    return subTotal.toCurrencyFormatString();
  }

  void _calCulateTotal() {
    double subTotalAmt = subTotal;
    subTotalTextCtrl.text = subTotalAmt.toCurrencyFormatString();

    final totalTax = _totalTaxAmt;
    if (discountAmtTextCtrl.text.isNotEmpty && getDiscountprice.isNotEmpty) {
      _discountChange(getDiscountprice);
      roundOff();
      return;
    }

    taxTextCtrl.text = totalTax.toCurrencyFormatString();
    if (isExcludingTax) {
      _adjustmentCalCulation((subTotalAmt + totalTax));
      roundOff();
      return;
    }
    _adjustmentCalCulation(subTotalAmt);
    roundOff();
  }

  void adjustmentChange(String value) {
    Debounce.debounce('adjustment-onChange', () async {
      final amt = _adjustmentAmt(value: value);
      if (value.isEmpty ||
          amt == 0 ||
          value == '0' ||
          value == '.0' ||
          value == '0.') {
        _calCulateTotal();
        adjustmentText = '₹ 0';
        return;
      }
      final totalAmt = tempTotalCost;
      totalCost = selectedAdjustment == adjustmentModel.first
          ? totalAmt - amt
          : totalAmt + amt;
      adjustmentText =
          selectedAdjustment == adjustmentModel.first ? '-$value' : value;
      roundOff();
      _isValidTotal();
      return;
    });
  }

  void _adjustmentCalCulation(double total) {
    tempTotalCost = total;
    final amt = _adjustmentAmt(value: adjustAmtTextCtrl.text);
    if (adjustAmtTextCtrl.text.isNotEmpty && amt != 0) {
      adjustmentChange(adjustAmtTextCtrl.text);
    } else {
      totalCost = total;
    }
    _isValidTotal();
  }

  void _tcsTdsCalculation() {
    final amt = AppConstants.textSymbolRemover(discountAppliedText);
    final subTotalAmt =
        getDiscountTdsTcsValue(double.parse(amt.isEmpty ? '0' : amt));

    if (tdsTcsValueModel?.id != null) {
      if (selectedTdsTcsModel.id == 0) {
        final tdsTcsValue = AppConstants.percentageToAmt(
            amt: subTotalAmt, percent: tdsTcsValueModel?.rate ?? 0.0);
        tdsTcsAmtTextCtrl.text = '-₹$tdsTcsValue';
        totalCost = totalCost - tdsTcsValue;
      } else {
        final tdsTcsValue = AppConstants.percentageToAmt(
            amt: subTotalAmt + taxPriceValue,
            percent: tdsTcsValueModel?.rate ?? 0.0);
        tdsTcsAmtTextCtrl.text = '₹$tdsTcsValue';
        totalCost = totalCost + tdsTcsValue;
      }
    }
  }

  void onShippingCostChange(String value) {
    Debounce.debounce('shipping-onChange', () {
      _calCulateTotal();
    });
  }

  void _onShippingCostCalculation() {
    final amt = AppConstants.textSymbolRemover(shippingAmtTextCtrl.text);
    if (amt.isEmpty || amt == '0' || amt == '.0' || amt == '0.') {
      return;
    }
    final totalAmt = totalCost;
    final price = double.parse(amt);
    totalCost = totalAmt + price;
  }

  void _isValidTotal() {
    if (totalCost < 0) {
      isError = true;
      return;
    }
    isError = false;
  }

  double _adjustmentAmt({String? value}) {
    if (adjustAmtTextCtrl.text.isEmpty) return 0;
    final formatAmt =
        AppConstants.textSymbolRemover(value ?? adjustAmtTextCtrl.text);
    final amt = formatAmt.isEmpty ? '0' : formatAmt;
    if (selectedAdjustment == adjustmentModel.first) {
      return double.parse(amt);
    }
    return double.parse(amt);
  }

  void roundOff() {
    _tcsTdsCalculation();
    _onShippingCostCalculation();
    if (isRoundOff) {
      final total = totalCost;
      totalCost = totalCost.roundToDouble();
      roundedTextCtrl.text = (totalCost - total).abs().toCurrencyFormatString();
    }
    updateNotifier();
  }

  void discountChange(String value) {
    Debounce.debounce('discount-onChange', () async {
      final price = discountTypeIndex == 2
          ? AppConstants.textSymbolRemover(value)
          : AppConstants.textSymbolRemover(value, symbol: '%');
      final discountAppliedPriceFormat =
          double.parse(AppConstants.textSymbolRemover(discountAppliedText));
      if (value.isEmpty ||
          price.isEmpty ||
          price == '0' ||
          price == '.0' ||
          price == '0.') {
        addDefaultPurchaseInvoiceAccounts();
        return _calCulateTotal();
      }

      addDefaultPurchaseInvoiceAccounts();
      if (discountTypeIndex == 2) {
        final amt = double.parse(price);
        final isPrice = (amt >= discountAppliedPriceFormat);
        _discountChange(
            isPrice ? discountAppliedPriceFormat.toString() : amt.toString());
        if (isPrice) {
          discountAmtTextCtrl.text = discountAppliedText;
        }
      } else {
        _discountChange(price);
      }
      roundOff();
      return;
    });
  }

  void addDefaultPurchaseInvoiceAccounts() {
    if (paramReq?.billType != BillType.purchaseInvoice) return;

    if (discountAmtTextCtrl.text.isEmpty && (!isLineDiscountApplied)) {
      selectedAccountItem = null;
      accountsTextCtrl.clear();
      return;
    }

    if (accountsTextCtrl.text.isNotEmpty) return;
    selectedAccountItem =
        chartsAccountsList.first.nodesList?.singleWhere((t) => t.id == 13);
    accountsTextCtrl.text = selectedAccountItem?.name ?? '';
  }

  void _discountChange(String value) {
    final subTotalAmt = subTotal;
    if (discountTypeIndex == 2) {
      final amt = double.parse(value);

      if (!isGstRegister || !isBeforeTax) {
        final totalTaxAmt = _totalTaxAmt;
        final taxAmt = isGstRegister && isExcludingTax ? totalTaxAmt : 0.0;
        taxTextCtrl.text = totalTaxAmt.toCurrencyFormatString();
        _adjustmentCalCulation(((subTotalAmt + taxAmt) - amt));
        return;
      }

      if (isExcludingTax) {
        final overAllDiscount =
            _overAllDiscountApplied(subTotalAmt, amt, false, false);
        taxTextCtrl.text = overAllDiscount.$2.toCurrencyFormatString();
        _adjustmentCalCulation((overAllDiscount.$1));
        return;
      }

      final overAllDiscount =
          _overAllDiscountApplied(subTotalWithOutTax(), amt, false, true);
      taxTextCtrl.text = overAllDiscount.$2.toCurrencyFormatString();
      _adjustmentCalCulation((overAllDiscount.$1));
      return;
    }

    final percentAmt = double.parse(value);

    if (!isGstRegister || !isBeforeTax) {
      final totalTaxAmt = _totalTaxAmt;
      final taxAmt = isGstRegister && isExcludingTax ? totalTaxAmt : 0.0;
      final totalAmt = (subTotalAmt + taxAmt);
      taxTextCtrl.text = totalTaxAmt.toCurrencyFormatString();
      _adjustmentCalCulation((totalAmt - (totalAmt * (percentAmt / 100))));
      return;
    }

    if (isExcludingTax) {
      final overAllDiscount =
          _overAllDiscountApplied(subTotalAmt, percentAmt, true, false);
      taxTextCtrl.text = overAllDiscount.$2.toCurrencyFormatString();
      _adjustmentCalCulation((overAllDiscount.$1));
      return;
    }

    final overAllDiscount =
        _overAllDiscountApplied(subTotalWithOutTax(), percentAmt, true, true);
    taxTextCtrl.text = overAllDiscount.$2.toCurrencyFormatString();
    _adjustmentCalCulation((overAllDiscount.$1));
    return;
  }

  (double, double) _overAllDiscountApplied(
      double subTotalAmt, double disAmount, bool isPercent, bool isInclusive) {
    double taxAmt = 0.0;
    double totalAmt = 0.0;
    double singleItemPercent = 0.0;
    double singleItemPercentDiscountAmt = 0.0;
    List<Map<String, dynamic>> breakDowns = [];

    for (final e in selectedItemList) {
      final subAmt = GSTCalculationUtils.subAmtFormatValue(e.formattedSubTotal);
      final taxPercentage = e.taxPercentage;
      double orgPrice = subAmt;
      double discount = 0.0;

      if (isInclusive) {
        final tax = GSTCalculationUtils.inclusiveTax(
            {'amount': subAmt, 'taxPercentage': taxPercentage});
        orgPrice = subAmt - tax;
      }

      if (!isPercent) {
        singleItemPercent = GSTCalculationUtils.findSingleItemPercentage(
            {'price': orgPrice, 'totalAmt': subTotalAmt});

        singleItemPercentDiscountAmt =
            GSTCalculationUtils.findSingleItemPercentWithDiscountAmt(
                {'percent': singleItemPercent, 'discount': disAmount});
      } else {
        discount = (orgPrice * (disAmount / 100));
      }

      final deductionAmt = GSTCalculationUtils.deductionWithItemPrice({
        'price': orgPrice,
        'discount': !isPercent ? singleItemPercentDiscountAmt : discount
      });

      final calculateTaxAmt = GSTCalculationUtils.calculateTaxAmt(
          {'percent': taxPercentage, 'amount': deductionAmt});

      totalAmt += (deductionAmt + calculateTaxAmt);
      taxAmt += calculateTaxAmt;
      breakDowns.add({
        'gstTaxAmt': GSTCalculationUtils.calculateTaxAmt(
            {'percent': e.taxRate, 'amount': deductionAmt}),
        'cessAmt': GSTCalculationUtils.calculateTaxAmt(
            {'percent': e.cessRate, 'amount': deductionAmt}),
        'cessTax': e.cessRate,
        'gstTax': e.taxRate
      });
    }
    taxBreakDownList = breakDowns;
    return (totalAmt, taxAmt);
  }

  (double, double) getItemTotalTaxAmt(double formattedTotal,
      double itemSubTotalAmt, double qtyValue, double taxPercentage) {
    if (discountAmtTextCtrl.text.isEmpty) return (formattedTotal, qtyValue);
    final discountAmt = double.parse(getDiscountprice);

    if (discountTypeIndex == 2) {
      if (!isGstRegister || !isBeforeTax) {
        return (formattedTotal, qtyValue);
      }

      if (isExcludingTax) {
        final overAllDiscount =
            GSTCalculationUtils.overAllDiscountForSalesItem({
          'subTotalAmt': formattedTotal,
          'itemSubTotalAmt': itemSubTotalAmt,
          'disAmount': discountAmt,
          'taxPercentage': taxPercentage,
          'isPercent': false,
          'isInclusive': false
        });
        return overAllDiscount;
      }

      final overAllDiscount = GSTCalculationUtils.overAllDiscountForSalesItem({
        'subTotalAmt': formattedTotal,
        'itemSubTotalAmt': itemSubTotalAmt,
        'taxPercentage': taxPercentage,
        'disAmount': discountAmt,
        'isPercent': false,
        'isInclusive': true
      });
      return overAllDiscount;
    }

    if (!isGstRegister || !isBeforeTax) {
      return (formattedTotal, qtyValue);
    }

    if (isExcludingTax) {
      final overAllDiscount = GSTCalculationUtils.overAllDiscountForSalesItem({
        'subTotalAmt': formattedTotal,
        'itemSubTotalAmt': itemSubTotalAmt,
        'disAmount': discountAmt,
        'taxPercentage': taxPercentage,
        'isPercent': true,
        'isInclusive': false
      });
      return overAllDiscount;
    }

    final overAllDiscount = GSTCalculationUtils.overAllDiscountForSalesItem({
      'subTotalAmt': formattedTotal,
      'itemSubTotalAmt': itemSubTotalAmt,
      'disAmount': discountAmt,
      'taxPercentage': taxPercentage,
      'isPercent': true,
      'isInclusive': true
    });
    return overAllDiscount;
  }

  List get calculateTaxBreakDown {
    final salesList = isBeforeTax && discountAmtTextCtrl.text.isNotEmpty
        ? taxBreakDownList
        : selectedItemList.map((e) => e.taxBreakDown).toList();
    Logger.d('salesList $salesList');

    final breakDownList = GSTCalculationUtils.getBreakDownList(salesList, {
      'orgStateCode':
          dashboardController.org?.addressDetail.getBillAddress()?.state,
      'customerStateCode': selectedPlaceOfSupply?.id
    });
    return breakDownList;
  }

  double subTotalWithOutTax() {
    double total = 0.0;
    for (final e in selectedItemList) {
      final subAmt = GSTCalculationUtils.subAmtFormatValue(e.formattedSubTotal);
      final tax = subAmt * (e.taxPercentage / (e.taxPercentage + 100));
      total += subAmt - tax;
    }
    return total;
  }

  void removeChartOfAccounts() {
    selectedAccountItem = null;
    accountsTextCtrl.clear();
  }

  void updateNotifier() {
    switch (paramReq?.billType) {
      case BillType.purchaseInvoice:
        purchaseInvoiceCtrl.setState;
        break;
      case BillType.salesInvoice:
        salesInvoiceCtrl.setState;
        break;
      case BillType.purchaseOrder:
        purchaseOrderCtrl.setState;
        break;
      case BillType.salesOrder:
        salesOrderCtrl.setState;
        break;
      default:
        // Handle other cases or do nothing
        break;
    }
  }

  bool get isSameState {
    final address = customerData?.addressDetail?.getBillAddress();
    if (address != null && address.id == null) return false;
    return address?.state == selectedPlaceOfSupply?.id;
  }

  Map<String, String>? get adjustmentField {
    final value = adjustmentNameTextCtrl.text;
    final adjustment = value.isEmpty ? 'Adjustment' : value;
    return {
      adjustment:
          '${selectedAdjustment == 0 ? '-' : '+'}${double.parse(AppConstants.textSymbolRemover(adjustAmtTextCtrl.text))}'
    };
  }

  bool get isPriceListAvailable =>
      (paramReq?.billType == BillType.purchaseInvoice ||
          paramReq?.billType == BillType.purchaseOrder);

  bool get isLineDiscountApplied =>
      selectedItemList.any((r) => r.lineItemDiscountValue != null);

  bool get isEdit => paramReq?.edit == true;

  double get subTotal => selectedItemList.calCulateSubTotal();
  double get _totalTaxAmt => selectedItemList.calCulateTotalTax();

  List<ChartsOfAccountListModel> get chartsAccountsList =>
      dashboardController.accountsList
          .where((t) => paramReq?.billType == BillType.purchaseInvoice
              ? t.accountTypeCode == 5
              : t.accountTypeCode == 1)
          .toList();

  SalesOrderCtrl get salesOrderCtrl =>
      reference!.read(salesOrderCtrlProvider.notifier);

  SalesInvoiceCtrl get salesInvoiceCtrl =>
      reference!.read(salesInvoiceCtrlProvider.notifier);

  PurchaseInvoiceCtrl get purchaseInvoiceCtrl =>
      reference!.read(purchaseInvoiceCtrlProvider.notifier);

  PurchaseOrderController get purchaseOrderCtrl =>
      reference!.read(purchaseOrderControllerProvider.notifier);

  DashboardController get dashboardController =>
      reference!.read(dashboardControllerProvider.notifier);
}
