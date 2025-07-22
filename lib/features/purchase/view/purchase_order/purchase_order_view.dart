import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vgts_plugin/form/vgts_form.dart';
import 'package:yoloworks_invoice/core/extension/address_extenstion.dart';
import 'package:yoloworks_invoice/services/sales_purchase_master_services/sales_purchase_master_services.dart';

import '../../../../app/common_widgets/app_bar_widget.dart';
import '../../../../app/common_widgets/app_error_widget.dart';
import '../../../../app/common_widgets/app_loading_widget.dart';
import '../../../../app/common_widgets/button.dart';
import '../../../../app/constants/app_sizes.dart';
import '../../../../app/constants/strings.dart';
import '../../../../app/styles/colors.dart';
import '../../../../app/styles/text_styles.dart';
import '../../../../locator.dart';
import '../../../sales/models/sales_params_request_model/sales_params_request_model.dart';
import '../../../sales/views/sales_info/sales_info.dart';
import '../../../sales/views/widgets/bill_summary.dart';
import '../../../sales/views/widgets/customer_info_widget.dart';
import '../../../sales/views/widgets/notes_widget.dart';
import '../../../sales/views/widgets/price_item_count_widget.dart';
import '../../../sales/views/widgets/sales_review_widget.dart';
import 'purchase_order_controller.dart';

class PurchaseOrderView extends ConsumerStatefulWidget {
  const PurchaseOrderView({super.key, required this.data});

  final SalesParamsRequestModel? data;

  @override
  ConsumerState<PurchaseOrderView> createState() => _PurchaseOrderViewState();
}

class _PurchaseOrderViewState extends ConsumerState<PurchaseOrderView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = ref.read(purchaseOrderControllerProvider.notifier);
      await controller.onInit(
        widget.data,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(purchaseOrderControllerProvider.notifier);
    final state = ref.watch(purchaseOrderControllerProvider);

    final isLoading = state.isLoading;

    return VGTSForm(
      key: controller.unFocusKey,
      child: AppOverlayLoaderWidget(
        isLoading: controller.salesOrderLoading,
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          appBar: AppBarWidget.empty(
            title: "Order: #${controller.billNo ?? ''}",
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: Divider(height: 1),
            ),
          ),
          bottomNavigationBar: isLoading
              ? null
              : SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Divider(height: 1),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16.w, right: 16.w, top: 10.h, bottom: 0.h),
                        child: Row(
                          children: [
                            if (!controller.isEdit)
                              Expanded(
                                child: AppButton.outline(
                                  key: Key("back_order"),
                                  'Back',
                                  textStyle: AppTextStyle.blueFS14FW500,
                                  height: 35.h,
                                  borderRadius: BorderRadius.circular(8.r),
                                  onPressed: () => navigationService.pop(),
                                ),
                              ),
                            if (!controller.isEdit) gapW20,
                            Expanded(
                              child: AppButton(
                                key: controller.isEdit
                                    ? Key("update")
                                    : Key("save"),
                                controller.isEdit ? 'Update' : 'Save',
                                height: 35.h,
                                borderRadius: BorderRadius.circular(8.r),
                                onPressed: controller.createOrder,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomerInfoWidget(
                  isLoading: isLoading,
                  name: controller.customerData?.displayName ?? '-',
                  image: controller.customerData?.logo ?? '',
                  address: controller.customerData?.addressDetail
                          ?.toCityAddressOne() ??
                      '-',
                  isEnabled: !controller.isEdit,
                  onChange: controller.onChangeClient,
                ),
                SalesInfoWidget(
                    isOrder: true,
                    isPurchaseOrder: true,
                    billNo: controller.billNo,
                    billDateTextCtrl: controller.billDateTextCtrl,
                    warehouseTextCtrl: controller.warehouseTextCtrl,
                    isInventoryEnabled: controller.isInventoryEnabled,
                    paymentTermTextCtrl: controller.paymentTermTextCtrl,
                    salesPersonTextCtrl: controller.salesPersonTextCtrl,
                    deliveryDateTextCtrl: controller.deliveryDateTextCtrl,
                    expectedDeliveryDateTextCtrl:
                        controller.expectedDeliveryDateTextCtrl,
                    modeOfTransportTextCtrl: controller.modeOfTransportTextCtrl,
                    placeOfSupplyTextCtrl: controller.placeOfSupplyTextCtrl,
                    referenceBillDateCtrl: controller.referenceBillDateTextCtrl,
                    referenceBillNo: controller.referenceBillNoTextCtrl,
                    openPlaceOfSupply: controller.openPlaceOfSupplyBottomSheet,
                    openDeliveryDatePicker: ({bool? doClear}) {
                      controller.openDeliveryDatePicker(
                          doClear: doClear ?? false);
                    },
                    openExpectedDeliveryDatePicker:
                        controller.openExpectedDeliveryDatePicker,
                    openBillDatePicker: controller.openBillDatePicker,
                    openRefBillDatePicker: ({bool? doClear}) {
                      controller.openReferenceDatePicker(
                          doClear: doClear ?? false);
                    },
                    openDuePeriodBottomSheet: controller.openDuePeriodBottomSheet,
                    openWarehouseBottomSheet: controller.openWarehouseBottomSheet,
                    openSalesPersonBottomSheet: ({bool? doClear}) {
                      controller.openSalesPersonBottomSheet(
                          doClear: doClear ?? false);
                    },
                    openModeOfTransportBottomSheet:
                        controller.openModeOfTransportBottomSheet),
                gapH5,
                PriceItemCountWidget(
                  isLoading: isLoading,
                  isSalesInvoice: false,
                  selectedTaxModel: controller.selectedGstTaxModel,
                  isItemListDisabled: controller.isItemListDisabled,
                  selectedItemCount: controller.selectedItemList.length,
                  onShowItems: controller.onShowItems,
                  openTaxBottomSheet: controller.openIncExcTaxBottomSheet,
                  onViewPriceList: controller.onViewPriceListItem,
                  onRemovePriceList: controller.removePriceList,
                  isPriceListEmpty: controller.priceList.isEmpty,
                  selectedPriceList: controller.selectedPriceList,
                ),
                if (controller.isItemListDisabled)
                  SalesReviewWidget(
                    selectedItemList: controller.selectedItemList,
                    onDeleteItem: controller.onDeleteItem,
                    onViewItem: (i) => controller.onViewItem(true, i),
                  ),
                Column(
                  children: [
                    AppButton.outline(
                      'Add Items',
                      key: Key('add-items'),
                      shimmerEffect: true,
                      isLoading: isLoading,
                      height: 35.h,
                      onPressed: controller.onViewItem,
                      padding: EdgeInsets.all(8),
                      borderColor:
                          isLoading ? AppColors.greyColor : AppColors.blueColor,
                      icon: Icon(Icons.add, size: 20, color: AppColors.blueColor),
                      textStyle: AppTextStyle.blueFS14FW500,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    gapH10,
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Text(
                    "Bill Summary",
                    style: AppTextStyle.blackFS14FW500,
                  ),
                ),
                BillSummary(
                  billSummaryRequest: BillSummaryRequest(
                      isGstRegister: controller.isGstRegister,
                      discountType: controller.discountTypeIndex,
                      adjustmentIndex: controller.selectedAdjustment,
                      totalCost: controller.totalCost,
                      adjustmentText: controller.adjustmentText,
                      discountAppliedText: controller.discountAppliedText,
                      tdsTcsAppliedTxt: controller.tdsTcsAppliedTxt,
                      selectedGstTaxModel: controller.selectedGstTaxModel,
                      selectedItemList: controller.selectedItemList,
                      tdsTcsValueModel: controller.tdsTcsValueModel,
                      selectedTdsTcsModel: controller.selectedTdsTcsModel,
                      hasRoundingOff: controller.billConfig?.hasRoundingOff,
                      isDiscountBeforeTax:
                          controller.billConfig?.isDiscountBeforeTax,
                      taxTextCtrl: controller.taxTextCtrl,
                      roundedTextCtrl: controller.roundedTextCtrl,
                      subTotalTextCtrl: controller.subTotalTextCtrl,
                      adjustAmtTextCtrl: controller.adjustAmtTextCtrl,
                      adjustmentNameTextCtrl: controller.adjustmentNameTextCtrl,
                      tdsTcsAmtTextCtrl: controller.tdsTcsAmtTextCtrl,
                      discountAmtTextCtrl: controller.discountAmtTextCtrl,
                      shippingAmtTextCtrl: controller.shippingAmtTextCtrl,
                      removeTdsTcs: controller.removeTdsTcs,
                      openDiscountAccountBottomSheet:
                          controller.openChartsOfAccountBottomSheet,
                      tdsTcsBottomSheet: controller.tdsTcsBottomSheet,
                      adjustmentBottomSheet: controller.adjustmentBottomSheet,
                      onDiscountBottomSheet: controller.discountBottomSheet,
                      tdsTcsValueBottomSheet: controller.tdsTcsValueBottomSheet,
                      openDiscountDetailBottomSheet:
                          controller.openDiscountDetailBottomSheet,
                      onDiscountChange: controller.discountChange,
                      onAdjustmentChange: controller.adjustmentChange,
                      onShippingCostChange: controller.onShippingCostChange,
                      openGstBreakDownBottomSheet:
                          controller.openGstBreakDownBottomSheet),
                ),
                if (controller.isError)
                  const AppErrorWidget(msg: AppStrings.totalAmtError),
                if (!isLoading)
                  NotesWidget(
                    notesTxtCtrl: controller.noteTextCtrl,
                    termConditionTxtCtrl: controller.termConditionTxtCtrl,
                    isTermsEdit: controller.isTermsEdit,
                    onEdit: controller.onTermsEdit,
                  ),
                gapH45,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
