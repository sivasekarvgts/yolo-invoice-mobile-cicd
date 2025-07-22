import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yoloworks_invoice/core/extension/address_extenstion.dart';
import 'package:yoloworks_invoice/core/extension/item_model_request_extension.dart';

import '../../../../../app/constants/strings.dart';
import '../../../../../app/constants/app_constants.dart';

import '../../../../../router.dart';
import '../../../../../locator.dart';
import '../../../../../core/enums/order_type.dart';

import '../../../data/sales_order_repository.dart';

import '../../../models/invoice/sales_invoice_request_model.dart';
import '../../../models/sales_params_request_model/sales_params_request_model.dart';
import '../../../../../services/sales_purchase_master_services/sales_purchase_master_services.dart';

part 'sales_order_ctrl.g.dart';

@riverpod
class SalesOrderCtrl extends _$SalesOrderCtrl with SalesPurchaseMasterService {
  @override
  AsyncValue<void> build() {
    return AsyncValue.loading();
  }

  AsyncValue<void> get setState => state = AsyncValue.data(null);
  AsyncValue<void> get setLoading => state = AsyncValue.loading();

  bool isSalesInvoice = false;
  bool salesOrderLoading = false;

  Future onInit(SalesParamsRequestModel? req) async {
    await getMasterInfo(req);
  }

  Future getMasterInfo(SalesParamsRequestModel? req) async {
    await init(ref, req);
  }

  void onChangeClient() async {
    final res =
        await navigationService.pushNamed(Routes.customer, arguments: true);
    if (res == null) return;
    final clientId = res ?? 0;
    await onInit(
      SalesParamsRequestModel(
        clientId: clientId,
        edit: false,
        order: orderId,
        billType: BillType.salesOrder,
      ),
    );
  }

  Future createOrder() async {
    if (selectedItemList.isEmpty) {
      return toastMsg(AppStrings.selectItemError);
    }

    final totalAmt = double.parse(totalCost.toStringAsFixed(2));
    if (AppConstants.isAmtValidation(totalAmt)) {
      return toastMsg(AppStrings.totalAmtDigitError);
    }

    if (totalAmt < 0) {
      return toastMsg(AppStrings.totalAmtError);
    }
    if (isEdit) return await _updateSalesOrder();
    await _createSalesOrder();
  }

  Future _createSalesOrder() async {
    salesOrderLoading = true;
    setState;
    try {
      final res = await ref
          .read(salesOrderRepositoryProvider)
          .createSalesOrder(order: _salesOrderReq);
      if (res == null) return;

      fireRefreshEvent();
      navigationService.pop();
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      toastMsg(AppStrings.orderNotCreated);
    }
    salesOrderLoading = false;
    setState;
  }

  Future _updateSalesOrder() async {
    salesOrderLoading = true;
    setState;
    try {
      final res = await ref
          .read(salesOrderRepositoryProvider)
          .updateSalesOrder(orderId: orderId ?? 0, order: _salesOrderReq);
      if (res == null) return;
      fireRefreshEvent();
      navigationService.pop();
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      toastMsg(AppStrings.orderNotUpdate);
    }
    salesOrderLoading = false;
    setState;
  }

  SalesInvoiceRequestModel get _salesOrderReq {
    return SalesInvoiceRequestModel(
      file: '',
      billStatus: 2,
      clientId: client,
      dueDate: dueDateTime,
      orderDate: billDateTime,
      isDiscountBeforeTax: isBeforeTax,
      warehouse: [selectedWarehouse?.id ?? 0],
      placeOfSupply: selectedPlaceOfSupply?.id,
      notes: noteTextCtrl.text,
      terms: termConditionTxtCtrl.text,
      discount: discountAmtTextCtrl.text.isEmpty ? null : discountPriceValue,
      dueTerm: selectedDuePeriod?.id,
      deliveryDate: deliveryDate,
      referenceDate: referenceDate,
      expectedDeliveryDate: expectedDeliveryDate,
      salesPerson: selectedSalesPerson?.id,
      isDiscountPercentage: discountTypeIndex == 1,
      totalAmount: double.parse(totalCost.toStringAsFixed(2)),
      shippingCharge: shippingAmtTextCtrl.text.isEmpty
          ? null
          : double.parse(
              AppConstants.textSymbolRemover(shippingAmtTextCtrl.text)),
      adjustment: double.parse(AppConstants.textSymbolRemover(adjustmentText)),
      customField: adjustmentField,
      priceListId: selectedPriceList?.id,
      tds: selectedTdsTcsModel.id == 0 ? tdsTcsValueModel?.id : null,
      tcs: selectedTdsTcsModel.id == 1 ? tdsTcsValueModel?.id : null,
      referenceNumber: referenceBillNoTextCtrl.text,
      billingAddress: customerData?.addressDetail?.getBillAddress(),
      shippingAddress: customerData?.addressDetail?.getShippingAddress(),
      modeOfTransportation: selectedMOT?.id,
      items: selectedItemList.toItemRequestList(
          warehouseId: selectedWarehouse?.id ?? 0),
    );
  }
}
