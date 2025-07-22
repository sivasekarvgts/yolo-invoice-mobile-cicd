import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yoloworks_invoice/core/enums/order_type.dart';
import 'package:yoloworks_invoice/core/extension/address_extenstion.dart';
import 'package:yoloworks_invoice/core/extension/datetime_extension.dart';
import 'package:yoloworks_invoice/core/extension/item_model_request_extension.dart';
import 'package:yoloworks_invoice/features/sales/data/sales_invoice_repository.dart';

import '../../../../../app/constants/app_constants.dart';
import '../../../../../app/constants/strings.dart';
import '../../../../../locator.dart';
import '../../../../../router.dart';
import '../../../../../services/dialog_service/snackbar_service.dart';
import '../../../models/invoice/sales_invoice_request_model.dart';
import '../../../models/master_model/due_period_list_model.dart';
import '../../../models/sales_params_request_model/sales_params_request_model.dart';
import '../../../../../services/sales_purchase_master_services/sales_purchase_master_services.dart';

part 'sales_invoice_ctrl.g.dart';

@riverpod
class SalesInvoiceCtrl extends _$SalesInvoiceCtrl
    with SalesPurchaseMasterService {
  @override
  AsyncValue<void> build() {
    return AsyncValue.loading();
  }

  AsyncValue<void> get setState => state = AsyncValue.data(null);
  AsyncValue<void> get setLoading => state = AsyncValue.loading();

  int? customerId;

  bool isSalesInvoice = false;
  bool salesInvoiceLoading = false;

  Future onInit(SalesParamsRequestModel? req) async {
    orderId = req?.order;
    customerId = req?.clientId;
    isConvert = req?.covert ?? false;
    await getMasterInfo(req);

    if (isEdit) {
      if (req?.billType == Routes.salesInvoice) {
        final item = duePeriodList.singleWhere(
            (t) => t.id == salesInvoiceDetailModel?.dueTermId,
            orElse: () => DuePeriodListModel());
        if (item.id != null) {
          selectedDuePeriod = item;
        }
        dueDateTime = salesInvoiceDetailModel?.dueDate!.toFormattedDateTime();
        billDateTime = salesInvoiceDetailModel?.billDate!.toFormattedDateTime();
      } else {
        final item = duePeriodList.singleWhere(
            (t) => t.id == salesOrderDetailModel?.dueTermId,
            orElse: () => DuePeriodListModel());
        if (item.id != null) {
          selectedDuePeriod = item;
        }
        dueDateTime = salesOrderDetailModel?.dueDate!.toFormattedDateTime();
        billDateTime = salesOrderDetailModel?.orderDate!.toFormattedDateTime();
      }
      onChangeDueType(selectedDuePeriod!);

      setState;
    }
  }

  Future getMasterInfo(SalesParamsRequestModel? req) async {
    await init(ref, req);
    if (isEdit) return;
    selectDefaultPriceListItem();
    final item = duePeriodList.singleWhere((t) => t.days == 7,
        orElse: () => DuePeriodListModel());
    if (item.id != null) {
      selectedDuePeriod = item;
    }
    setState;
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
        billType: BillType.salesInvoice,
      ),
    );
  }

  Future<void> saveInvoice({bool isDraft = false}) async {
    //TODOS
    //validation need to do
    if (totalCost < 0) {
      return toastMsg(AppStrings.totalAmtError);
    }

    if (selectedItemList.isEmpty) {
      return toastMsg('Please add items');
    }

    final salesErrorList =
        selectedItemList.where((t) => t.errorMsg != null).toList();
    if (salesErrorList.isNotEmpty) {
      final item = salesErrorList.first;
      return toastMsg('Please check the ${item.itemName} ${item.unitName}');
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
        clientId: customerId,
        dueTerm: selectedDuePeriod?.id,
        notes: noteTextCtrl.text,
        file: '',
        isDiscountPercentage: discountTypeIndex == 1,
        discount: discountAmtTextCtrl.text.isEmpty ? null : discountPriceValue,
        totalAmount: double.parse(totalCost.toStringAsFixed(2)),
        shippingCharge: shippingAmtTextCtrl.text.isEmpty
            ? null
            : double.parse(
                AppConstants.textSymbolRemover(shippingAmtTextCtrl.text)),
        adjustment:
            double.parse(AppConstants.textSymbolRemover(adjustmentText)),
        customField: adjustmentField,
        billStatus: billStatus,
        priceListId: selectedPriceList?.id,
        tds: selectedTdsTcsModel.id == 0 ? tdsTcsValueModel?.id : null,
        tcs: selectedTdsTcsModel.id == 1 ? tdsTcsValueModel?.id : null,
        referenceNumber: referenceBillNoTextCtrl.text.isEmpty
            ? null
            : referenceBillNoTextCtrl.text,
        billingAddress: customerData?.addressDetail?.getBillAddress(),
        shippingAddress: customerData?.addressDetail?.getShippingAddress(),
        items: selectedItemList.toItemRequestList(
            warehouseId: selectedWarehouse?.id ?? 0));
    await sendInvoice(req);
  }

  Future sendInvoice(SalesInvoiceRequestModel req) async {
    salesInvoiceLoading = true;
    setState;

    try {
      if (isEdit) {
        await ref
            .read(salesInvoiceRepositoryProvider)
            .updateSalesInvoice(req, salesInvoiceDetailModel?.id ?? 0);
        fireRefreshEvent();
        navigationService.pop(returnValue: true);
        SnackbarService.toastMsg("Invoice Updated Successfully!", false);
      } else {
        await ref.read(salesInvoiceRepositoryProvider).postSalesInvoice(req);
        fireRefreshEvent();
        navigationService.pop(returnValue: true);
        SnackbarService.toastMsg("Invoice Created Successfully!", false);
      }
    } catch (e, s) {
      SnackbarService.toastMsg(
          "Invoice is not ${isEdit ? 'updated' : 'created'} Successfully!");
      state = AsyncValue.error(e, s);
    } finally {
      salesInvoiceLoading = false;
      setState;
    }
  }
}
