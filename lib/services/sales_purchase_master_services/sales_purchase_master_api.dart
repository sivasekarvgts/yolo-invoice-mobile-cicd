part of 'package:yoloworks_invoice/services/sales_purchase_master_services/sales_purchase_master_services.dart';

extension SalesPurchaseMasterApi on SalesPurchaseMasterService {
  Future onMasterApiCall() async {
    try {
      await getCustomerInfo(paramReq!.clientId!);
      await fetchWarehouseList();
      await getSalesPersonList();
      await getTransportModeList();
      await fetchStates();
      await getBillConfig();
      await getBillNo();
      await getPriceList(paramReq!.clientId!);
      await getDuePeriodList();
      await getGSTCessList();
      await getTcsList();
      await getTdsList();
      await getTdsSectionList();
      await getTcsSectionList();
    } catch (e, s) {
      Logger.e('Exception $e', s: s);
      toastMsg('⚠️ Oops! Something Went Wrong,Please try again later');
    }
  }

  Future getCustomerInfo(int clientId) async {
    customerData = paramReq?.isVendor == true
        ? await customerRepo.getVendorInfo(id: clientId)
        : await customerRepo.getCustomerInfo(id: clientId);
    client = clientId;
  }

  Future fetchWarehouseList() async {
    final res = await masterRepo.getWarehouseList();
    if (res == null || res.isEmpty) {
      isInventoryEnabled = false;
      return;
    }
    if (res.length == 1) isInventoryEnabled = false;
    warehouseList = res;
    if (isEdit) return;
    _mapWarehouse();
  }

  void onSelectWarehouse() {
    final warehouses = salesInvoiceDetailModel?.warehouse ??
        salesOrderDetailModel?.warehouse ??
        [];
    final id = warehouses.isEmpty ? null : warehouses.first;
    _mapWarehouse(id: id);
  }

  void _mapWarehouse({int? id}) {
    final selectedItem = warehouseList
        ?.firstWhere((t) => id == null ? t.isPrimary == true : t.id == id);
    warehouseTextCtrl.text = selectedItem?.name?.capitalizeFirst ?? '';
    selectedWarehouse = selectedItem;
  }

  Future getSalesPersonList() async {
    if (paramReq?.billType == BillType.salesOrder) return;

    final res = await masterRepo.getSalesPersonList();
    salesPersonList = res;
  }

  Future getTransportModeList() async {
    if (paramReq?.billType == BillType.purchaseOrder &&
        paramReq?.billType == BillType.salesOrder) return;

    final res = await masterRepo.getTransportModeList();
    transportModeList = res;
    if (isEdit) return;

    selectedMOT = res.first;
    modeOfTransportTextCtrl.text = selectedMOT?.name ?? '';
  }

  Future fetchStates({bool? refresh}) async {
    stateList = await customerRepo.getStates();
    final address = customerData?.addressDetail?.getBillAddress();
    if (isEdit) return;
    onSelectState(address?.state ?? 0);
  }

  void onSelectState(int stateCode) {
    final state = stateList.firstWhere((r) => r.id == stateCode);
    selectedPlaceOfSupply = state;
    placeOfSupplyTextCtrl.text = selectedPlaceOfSupply?.name ?? '';
  }

  Future getBillNo() async {
    if (isEdit) return;

    final res = await masterRepo.getBillNoGenerator(
        type: paramReq?.billType?.choice ?? 0);
    if (res == null) return;
    billNo = (paramReq?.billType == BillType.salesInvoice ||
            paramReq?.billType == BillType.purchaseInvoice)
        ? res['Invoice_number']
        : res['Order_number'];
  }

  Future getPriceList(int clientId) async {
    if (isPriceListAvailable) return;

    priceList = await masterRepo.getPriceList(clientId: clientId);
    if (priceList.isEmpty) return;
    selectedPriceList =
        priceList.firstWhere((t) => t.priceListModelDefault == true);
  }

  Future getDuePeriodList() async {
    duePeriodList = await masterRepo.getDuePeriodList();
    if (duePeriodList.isEmpty) return;
    final selectedItem = duePeriodList.firstWhere((r) => r.id == 2);
    paymentTermTextCtrl.text = selectedItem.name ?? '';
    selectedDuePeriod = selectedItem;
  }

  Future getGSTCessList() async {
    taxList = await itemRepo.getItemGst();
    cessList = await itemRepo.getItemCess();
    debugPrint('taxList $cessList');
    debugPrint('taxList $cessList');
  }

  Future getTdsList() async {
    tdsList = await masterRepo.getTdsList();
  }

  Future getTcsList() async {
    tcsList = await masterRepo.getTcsList();
  }

  Future getTdsSectionList() async {
    tdsSectionList = await masterRepo.getTdsSectionList();
  }

  Future getTcsSectionList() async {
    tcsSectionList = await masterRepo.getTcsSectionList();
  }

  Future getBillConfig() async {
    billConfig = await masterRepo.getBillConfig();
    selectedGstTaxModel = billConfig?.isExclusiveTax == true
        ? gstTaxModelList[1]
        : gstTaxModelList[0];
    discountTypeIndex = billConfig?.discountType ?? 1;
    isRoundOff = billConfig?.hasRoundingOff == true;
    isBeforeTax = billConfig?.isDiscountBeforeTax == true;
    termConditionTxtCtrl.text = billConfig?.salesTerms ?? '';
  }
}
