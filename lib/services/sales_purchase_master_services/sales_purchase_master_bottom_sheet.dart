part of 'package:yoloworks_invoice/services/sales_purchase_master_services/sales_purchase_master_services.dart';

extension SalesPurchaseMasterBottomSheet on SalesPurchaseMasterService {
  //bill date
  void openBillDatePicker() async {
    final dateTime = AppDateConstant.currentDateTime;
    final pickedDate = await DatePickerService.datePicker(
        firstDate: DateTime(2001), initialDate: billDateTime ?? dateTime);

    if (pickedDate == null) return;
    billDateTime = pickedDate;
    _addDays(selectedDuePeriod?.days ?? 7);
    billDateTextCtrl.text =
        DateFormates.billDateFormat.format(billDateTime ?? DateTime.now());
    updateNotifier();
  }

  void _addDays(int days) {
    if (isCustom) return;
    billDateTime ??= AppDateConstant.currentDateTime;
    dueDateTime = billDateTime?.add(Duration(days: days)) ??
        AppDateConstant.currentDateTime.add(Duration(days: days));
    billDateTextCtrl.text =
        DateFormates.billDateFormat.format(billDateTime ?? DateTime.now());
    dueDateTextCtrl.text =
        DateFormates.billDateFormat.format(dueDateTime ?? DateTime.now());
  }

  //delivery date
  void openDeliveryDatePicker({bool doClear = false}) async {
    if (doClear) {
      deliveryDateTextCtrl.clear();
      return;
    }

    final dateTime = AppDateConstant.currentDateTime;
    final pickedDate = await DatePickerService.datePicker(
        firstDate: dateTime,
        initialDate: deliveryDateTextCtrl.text.isEmpty
            ? dateTime
            : DateFormates.billDateFormat.parse(billDateTextCtrl.text));

    if (pickedDate == null) return;
    deliveryDateTextCtrl.text = DateFormates.billDateFormat.format(pickedDate);

    updateNotifier();
  }

  //expected delivery date
  void openExpectedDeliveryDatePicker() async {
    final dateTime = AppDateConstant.currentDateTime;
    final pickedDate = await DatePickerService.datePicker(
        firstDate: dateTime, initialDate: billDateTime ?? dateTime);

    if (pickedDate == null) return;
    expectedDeliveryDateTextCtrl.text =
        DateFormates.billDateFormat.format(pickedDate);
    updateNotifier();
  }

  //warehouse sheet
  void openWarehouseBottomSheet() {
    Logger.d('warehouse $warehouseList');
    dialogService.showBottomSheet(
      title: 'Warehouse',
      child: GenericSheet<WarehouseListModel>(
        dataList: warehouseList ?? [],
        nameExtractor: (u) => u.name,
        selectedData: selectedWarehouse,
        onTap: (res) {
          selectedWarehouse = res;
          warehouseTextCtrl.text = res.name ?? "";
          onItemValidate();
          dialogService.dialogComplete(AlertResponse(status: true));
        },
      ),
    );
  }

  //reference date
  void openReferenceDatePicker({bool doClear = false}) async {
    if (doClear) {
      referenceBillDateTextCtrl.clear();
      updateNotifier();
      return;
    }
    final dateTime = AppDateConstant.currentDateTime;
    final pickedDate = await DatePickerService.datePicker(
        firstDate: DateTime(2001),
        initialDate: referenceBillDateTextCtrl.text.isEmpty
            ? dateTime
            : DateFormates.billDateFormat.parse(billDateTextCtrl.text));

    if (pickedDate == null) return;
    referenceBillDateTextCtrl.text =
        DateFormates.billDateFormat.format(pickedDate);

    updateNotifier();
  }

  //Due period sheet
  void openDuePeriodBottomSheet() {
    Logger.d('DuePeriod $duePeriodList');
    dialogService.showBottomSheet(
      title: 'Due Period',
      child: GenericSheet<DuePeriodListModel>(
        dataList: duePeriodList,
        nameExtractor: (u) => u.name,
        selectedData: selectedDuePeriod,
        onTap: (res) {
          dialogService.dialogComplete(AlertResponse(status: true));
          selectedDuePeriod = res;
          paymentTermTextCtrl.text = res.name ?? "";
          onChangeDueType(res);
          updateNotifier();
        },
      ),
    );
  }

  //Including Excluding Tax sheet
  void openIncExcTaxBottomSheet() {
    Logger.d('Including Excluding Tax $duePeriodList');
    dialogService.showBottomSheet(
      title: 'Tax Type',
      child: GenericSheet<GstTaxModel>(
        dataList: gstTaxModelList,
        nameExtractor: (u) => u.title,
        selectedData: selectedGstTaxModel,
        onTap: (res) {
          selectedGstTaxModel = res;
          // paymentTermTextCtrl.text = res.title ?? "";
          updateNotifier();
          dialogService.dialogComplete(AlertResponse(status: true));
        },
      ),
    );
  }

  //MOT sheet
  void openModeOfTransportBottomSheet() {
    Logger.d('Mode Of Transport $transportModeList');

    dialogService.showBottomSheet(
      title: 'Mode Of Transport',
      child: GenericSheet<TransportModeModel>(
        dataList: transportModeList ?? [],
        nameExtractor: (u) => u.name,
        selectedData: selectedMOT,
        onTap: (res) {
          selectedMOT = res;
          modeOfTransportTextCtrl.text = res.name ?? "";
          updateNotifier();
          dialogService.dialogComplete(AlertResponse(status: true));
        },
      ),
    );
  }

  void onSelectModeOfTransport(int id) {
    selectedMOT = transportModeList?.singleWhere((t) => t.id == id);
    modeOfTransportTextCtrl.text = selectedMOT?.name ?? '';
  }

  //POS sheet
  void openSalesPersonBottomSheet({bool doClear = false}) {
    Logger.d('Sales Person $salesPersonList');
    if (doClear) {
      selectedSalesPerson = null;
      salesPersonTextCtrl.clear();
      return;
    }
    dialogService.showBottomSheet(
      title: 'Sales Person',
      child: GenericSheet<SalesPersonListModel>(
        dataList: salesPersonList ?? [],
        nameExtractor: (u) => u.name,
        selectedData: selectedSalesPerson,
        onTap: (res) {
          selectedSalesPerson = res;
          salesPersonTextCtrl.text = res.name ?? "";
          updateNotifier();
          dialogService.dialogComplete(AlertResponse(status: true));
        },
      ),
    );
  }

  //POS sheet
  void openPlaceOfSupplyBottomSheet() {
    dialogService.showBottomSheet(
      title: 'Place Of Supply',
      child: GenericSheet<StateModel>(
        dataList: stateList,
        nameExtractor: (u) => u.name,
        selectedData: selectedPlaceOfSupply,
        onTap: (res) {
          selectedPlaceOfSupply = res;
          placeOfSupplyTextCtrl.text = res.name ?? "";
          updateNotifier();
          dialogService.dialogComplete(AlertResponse(status: true));
        },
      ),
    );
  }

  //tdsTcs sheet
  void tdsTcsBottomSheet() {
    dialogService.showBottomSheet(
      title: "Select Tax",
      child: GenericSheet<TdsTcsModel>(
        dataList: tdsTcsModel,
        nameExtractor: (u) => u.title,
        selectedData: selectedTdsTcsModel,
        onTap: (TdsTcsModel res) {
          if (selectedTdsTcsModel.id != res.id) {
            selectedTdsTcsModel = res;
            tdsTcsAmtTextCtrl.clear();
            tdsTcsValueModel = null;
            _calCulateTotal();
          }

          dialogService.dialogComplete(AlertResponse(status: true));
        },
      ),
    );
  }

  //tdsTcs sheet
  void tdsTcsValueBottomSheet() {
    dialogService.showBottomSheet(
        title: "Select ${selectedTdsTcsModel.title}",
        child: TdsTcsValueBottomSheet(
            tdsTcsModel: tdsTcsValueModel,
            selectedTdsTcsModel: selectedTdsTcsModel,
            tdsTcsList: selectedTdsTcsModel.id == 0 ? tdsList : tcsList,
            onAddTdsTcs: () async {
              dialogService.dialogComplete(AlertResponse(status: true));
              final res = await navigationService.pushNamed(Routes.addTdsTcs,
                  arguments: {
                    'tds_tcs_model': selectedTdsTcsModel,
                    'tds_section_list': tdsSectionList
                  });
              if (res == null) return;
              if (selectedTdsTcsModel.id == 0)
                tdsList.add(res);
              else
                tcsList.add(res);
            },
            onTap: (TaxModel item) {
              if (tdsTcsValueModel?.id == item.id) {
                return dialogService
                    .dialogComplete(AlertResponse(status: false));
              }
              tdsTcsAmtTextCtrl.clear();
              tdsTcsValueModel = item;
              _calCulateTotal();
              dialogService.dialogComplete(AlertResponse(status: true));
            }));
  }

  void removeTdsTcs() {
    tdsTcsValueModel = null;
    tdsTcsAmtTextCtrl.clear();
    _calCulateTotal();
  }

  String? get tdsTcsAppliedTxt {
    if (reference == null) return '';
    return tdsTcsValueModel?.id == null
        ? ''
        : '${selectedTdsTcsModel.title} of ${tdsTcsValueModel?.rate}% is applied';
  }

  //adjustment sheet
  void adjustmentBottomSheet() {
    dialogService.showBottomSheet(
      title: 'Adjustment',
      child: GenericSheet<AdjustmentDiscountModel>(
        dataList: adjustmentModel,
        nameExtractor: (u) => u.title,
        selectedData: selectedAdjustment,
        onTap: (res) {
          if (selectedAdjustment != res.id) {
            selectedAdjustment = res;
            adjustAmtTextCtrl.clear();
            adjustmentText =
                adjustAmtTextCtrl.text.isEmpty ? '-₹0.00' : '₹0.00';
            _calCulateTotal();
          }
          dialogService.dialogComplete(AlertResponse(status: true));
        },
      ),
    );
  }

  //discount sheet
  void discountBottomSheet() {
    dialogService.showBottomSheet(
      title: 'Discount',
      child: AdjustmentDiscountWidget(
        isDiscount: true,
        discountAmtIndex: discountTypeIndex,
        adjustmentDiscountModel: discountModel,
        onTap: (int id) {
          if (discountTypeIndex == id) {
            return dialogService.dialogComplete(AlertResponse(status: false));
          }
          discountTypeIndex = id;
          discountAmtTextCtrl.clear();
          discountText =
              discountTypeIndex == 1 ? 'Discount 0.00%' : 'Amount ₹0.00';
          _calCulateTotal();
          dialogService.dialogComplete(AlertResponse(status: true));
        },
      ),
    );
  }

  //gst break down sheet
  void openGstBreakDownBottomSheet() {
    final taxBreakDownList = calculateTaxBreakDown;
    Logger.d('taxBreakDownList $taxBreakDownList');
    dialogService.showBottomSheet(
      title: 'GST BreakDown',
      child: GstBreakDownSheet(breakDownList: taxBreakDownList),
    );
  }

  //discount details
  void openDiscountDetailBottomSheet() {
    dialogService.showBottomSheet(
      title: 'Discount Details',
      child: DiscountDetailsSheet(discountText: _discountDetails),
    );
  }

  //discount details
  void openBeforeAfterTax() {
    dialogService.showBottomSheet(
      title: "Select Discount Tax",
      child: GenericSheet<String>(
        dataList: ['Discount After Tax', 'Discount Before Tax'],
        nameExtractor: (u) => u,
        selectedData:
            isBeforeTax ? 'Discount Before Tax' : 'Discount After Tax',
        onTap: (res) {
          isBeforeTax = res == 'Discount After Tax' ? false : true;
          _calCulateTotal();
          dialogService.dialogComplete(AlertResponse(status: true));
        },
      ),
    );
  }

  //charts of Accounts
  void openChartsOfAccountBottomSheet() {
    dialogService.showBottomSheet(
      title: 'Discount Accounts',
      child: ChartsOfAccountsWidget(
        selectedItem: selectedAccountItem,
        chartsOfAccountList: chartsAccountsList,
        onAddAccounts: () async {
          dialogService.dialogComplete(AlertResponse(status: true));
          final res = await navigationService.pushNamed(Routes.addAccounts,
              arguments: chartsAccountsList.first.accountTypeCode);
          if (res == true) {
            await dashboardController.getAccountList();
          }
        },
        onTap: (childItem) {
          selectedAccountItem = childItem;
          accountsTextCtrl.text = childItem?.name ?? '';
          updateNotifier();
          dialogService.dialogComplete(AlertResponse(status: true));
        },
      ),
    );
  }

  void onSelectPurchaseAccount(int id) {
    selectedAccountItem =
        chartsAccountsList.first.nodesList?.singleWhere((t) => id == t.id);
    accountsTextCtrl.text = selectedAccountItem?.name ?? '';
  }

  void openDueDatePicker() async {
    final dateTime = AppDateConstant.currentDateTime;
    final pickedDate = await DatePickerService.datePicker(
        firstDate: dateTime, initialDate: billDateTime ?? dateTime);

    if (pickedDate == null) return;
    if (dueDateTime != pickedDate) onChangeBillDueDate();
    onSetDueDate(pickedDate);
    updateNotifier();
  }

  void onSetDueDate(dynamic pickedDate) {
    dueDateTime = pickedDate;
    dueDateTextCtrl.text =
        DateFormates.billDateFormat.format(dueDateTime ?? DateTime.now());
  }

  void onSetBillDate(dynamic pickedDate) {
    billDateTime = pickedDate;
    billDateTextCtrl.text =
        DateFormates.billDateFormat.format(billDateTime ?? DateTime.now());
  }

  void onSetDeliveryDate(dynamic pickedDate) {
    deliveryDate = pickedDate;
    deliveryDateTextCtrl.text =
        DateFormates.billDateFormat.format(deliveryDate ?? DateTime.now());
  }

  void onSetExceptedDeliveryDate(dynamic pickedDate) {
    expectedDeliveryDate = pickedDate;
    expectedDeliveryDateTextCtrl.text = DateFormates.billDateFormat
        .format(expectedDeliveryDate ?? DateTime.now());
  }

  void onSetReferenceDeliveryDate(dynamic pickedDate) {
    referenceDate = pickedDate;
    referenceBillDateTextCtrl.text =
        DateFormates.billDateFormat.format(referenceDate ?? DateTime.now());
  }

  void onChangeBillDueDate() {
    selectedDuePeriod = duePeriodList.first;
    paymentTermTextCtrl.text = selectedDuePeriod?.name ?? "Custom";
  }

  void onSetDateFieldValue() {
    final currentDateTime = AppDateConstant.currentDateTime;
    final date = DateFormates.billDateFormat.format(currentDateTime);
    billDateTextCtrl.text = date;
    if (paramReq?.billType == BillType.salesOrder ||
        paramReq?.billType == BillType.purchaseOrder) {
      expectedDeliveryDate = currentDateTime;
      expectedDeliveryDateTextCtrl.text = date;
    }

    final item = duePeriodList.singleWhere((t) => t.days == 7,
        orElse: () => DuePeriodListModel());
    if (item.id != null) {
      selectedDuePeriod = item;
    }
    onChangeDueType(selectedDuePeriod!);
  }

  void retrieveDateFieldsValue(
    int? dueTermId,
    DateTime? dueDateTime,
    DateTime? billDateTime, [
    DateTime? deliveryDateTime,
    DateTime? exceptedDeliveryDateTime,
    DateTime? referenceDate,
  ]) {
    final item = duePeriodList.singleWhere((t) => t.id == dueTermId,
        orElse: () => DuePeriodListModel());
    if (item.id != null) {
      selectedDuePeriod = item;
    }
    onSetDueDate(dueDateTime);
    onSetBillDate(billDateTime);
    if (deliveryDateTime != null) onSetDeliveryDate(deliveryDateTime);
    if (exceptedDeliveryDateTime != null)
      onSetExceptedDeliveryDate(deliveryDateTime);
    if (referenceDate != null) onSetReferenceDeliveryDate(referenceDate);
  }

  void onChangeDueType(DuePeriodListModel type) {
    selectedDuePeriod = type;
    if (isCustom) {
      dueDateTime = null;
      openBillDatePicker();
    } else {
      _addDays(selectedDuePeriod!.days!);
    }
    debugPrint('selected $selectedDuePeriod');
    updateNotifier();
  }

  void selectDefaultPriceListItem({int? priceId}) {
    if (priceList.isEmpty) return;
    final priceLists = priceId != null
        ? priceList.firstWhere((t) => t.id == priceId)
        : priceList.firstWhere((t) => t.priceListModelDefault == true);
    if (priceLists.id == null) return;
    selectedPriceList = priceLists;
  }

  //toast
  void toastMsg(String msg, [bool isFailed = true]) {
    SnackbarService.toastMsg(msg, isFailed);
  }
}
