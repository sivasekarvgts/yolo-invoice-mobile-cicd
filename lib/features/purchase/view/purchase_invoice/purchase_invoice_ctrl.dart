import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yoloworks_invoice/core/enums/order_type.dart';
import 'package:yoloworks_invoice/core/extension/address_extenstion.dart';
import 'package:yoloworks_invoice/core/extension/item_model_request_extension.dart';
import 'package:yoloworks_invoice/locator.dart';

import '../../../../app/constants/app_constants.dart';
import '../../../../app/constants/strings.dart';
import '../../../../router.dart';
import '../../../../services/dialog_service/snackbar_service.dart';

import '../../../../services/sales_purchase_master_services/sales_purchase_master_services.dart';
import '../../../sales/models/invoice/sales_invoice_request_model.dart';
import '../../../sales/models/sales_params_request_model/sales_params_request_model.dart';
import '../../data/purchase_invoice_repository.dart';

part 'purchase_invoice_ctrl.g.dart';

@riverpod
class PurchaseInvoiceCtrl extends _$PurchaseInvoiceCtrl
    with SalesPurchaseMasterService {
  @override
  AsyncValue<void> build() {
    return AsyncValue.loading();
  }

  AsyncValue<void> get setState => state = AsyncValue.data(null);
  AsyncValue<void> get setLoading => state = AsyncValue.loading();

  bool isSalesInvoice = false;
  bool purchaseInvoiceLoading = false;

  Future onInit(SalesParamsRequestModel? req) async {
    await getMasterInfo(req);
  }

  Future getMasterInfo(SalesParamsRequestModel? req) async {
    await init(ref, req);
  }

  void onChangeClient() async {
    final res =
        await navigationService.pushNamed(Routes.vendor, arguments: true);
    if (res == null) return;
    final clientId = res ?? 0;
    await onInit(
      SalesParamsRequestModel(
        order: orderId,
        clientId: clientId,
        isVendor: true,
        billType: BillType.purchaseInvoice,
      ),
    );
  }

  Future sendPurchaseInvoice({bool isDraft = false}) async {
    //TODOS
    //validation need to do

    if (totalCost < 0) {
      return toastMsg(AppStrings.totalAmtError);
    }

    if ((discountPriceValue != 0 || isLineDiscountApplied) &&
        accountsTextCtrl.text.isEmpty) {
      toastMsg('Please select discount account');
      return;
    }

    if (selectedItemList.isEmpty) {
      return toastMsg('Please add items');
    }

    int billStatus = isEdit
        ? (salesInvoiceDetailModel?.billStatusId ?? 1)
        : isDraft
            ? 1
            : 2;

    final req = SalesInvoiceRequestModel(
        warehouse: [selectedWarehouse?.id ?? 0],
        billDate: billDateTime,
        isDiscountBeforeTax: isBeforeTax,
        placeOfSupply: selectedPlaceOfSupply?.id,
        terms: termConditionTxtCtrl.text,
        dueDate: dueDateTime,
        vendorId: client,
        dueTerm: selectedDuePeriod?.id,
        notes: noteTextCtrl.text,
        file: '',
        isDiscountPercentage: discountTypeIndex == 1,
        discount: discountAmtTextCtrl.text.isEmpty ? null : discountPriceValue,
        totalAmount: double.parse(totalCost.toStringAsFixed(2)),
        shippingCharge: double.parse(
            AppConstants.textSymbolRemover(shippingAmtTextCtrl.text)),
        adjustment:
            double.parse(AppConstants.textSymbolRemover(adjustmentText)),
        customField: <String, String>{
          adjustmentNameTextCtrl.text:
              AppConstants.textSymbolRemover(adjustmentText)
        },
        priceListId: selectedPriceList?.id,
        billStatus: billStatus,
        tds: selectedTdsTcsModel.id == 0 ? tdsTcsValueModel?.id : null,
        tcs: selectedTdsTcsModel.id == 1 ? tdsTcsValueModel?.id : null,
        referenceNumber: referenceBillNoTextCtrl.text,
        billingAddress: customerData?.addressDetail?.getBillAddress(),
        shippingAddress: customerData?.addressDetail?.getShippingAddress(),
        discountAccount: selectedAccountItem?.id,
        items: selectedItemList.toItemRequestList(
            warehouseId: selectedWarehouse?.id ?? 0));
    await _sendPurchaseInvoice(req);
  }

  Future _sendPurchaseInvoice(SalesInvoiceRequestModel req) async {
    purchaseInvoiceLoading = true;
    setState;
    try {
      if (isEdit) {
        await ref
            .read(purchaseInvoiceRepositoryProvider)
            .updateSalesInvoice(req, salesInvoiceDetailModel?.id ?? 0);
        fireRefreshEvent();
        navigationService.pop(returnValue: true);
        SnackbarService.toastMsg(
            "Purchase invoice updated successfully !", false);
      } else {
        await ref.read(purchaseInvoiceRepositoryProvider).postSalesInvoice(req);
        fireRefreshEvent();
        navigationService.pop(returnValue: true);
        SnackbarService.toastMsg(
            "Purchase invoice created successfully !", false);
      }
    } catch (e, s) {
      SnackbarService.toastMsg(
          "Purchase invoice is not ${isEdit ? 'updated' : 'created'} !!!");
      state = AsyncValue.error(e, s);
    }

    purchaseInvoiceLoading = false;
    setState;
  }
}
