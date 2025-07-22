import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vgts_plugin/form/vgts_form.dart';
import 'package:yoloworks_invoice/app/common_widgets/app_outside_focus_remover.dart';
import 'package:yoloworks_invoice/core/extension/address_extenstion.dart';
import 'package:yoloworks_invoice/services/sales_purchase_master_services/sales_purchase_master_services.dart';

import '../../../../../app/common_widgets/button.dart';
import '../../../../../app/common_widgets/app_bar_widget.dart';
import '../../../../../app/common_widgets/app_error_widget.dart';
import '../../../../../app/common_widgets/app_loading_widget.dart';

import '../../../../../app/constants/strings.dart';
import '../../../../../app/constants/app_sizes.dart';

import '../../../../../app/styles/colors.dart';
import '../../../../../app/styles/text_styles.dart';

import '../../../models/sales_params_request_model/sales_params_request_model.dart';

import '../../widgets/bill_summary.dart';
import '../../widgets/notes_widget.dart';

import '../../widgets/sales_review_widget.dart';
import '../../widgets/customer_info_widget.dart';
import '../../widgets/price_item_count_widget.dart';

import 'sales_invoice_ctrl.dart';
import '../../sales_info/sales_info.dart';

class SalesInvoiceScreen extends ConsumerStatefulWidget {
  const SalesInvoiceScreen({super.key, required this.data});
  final SalesParamsRequestModel? data;

  @override
  ConsumerState<SalesInvoiceScreen> createState() => _SalesInvoiceScreenState();
}

class _SalesInvoiceScreenState extends ConsumerState<SalesInvoiceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = ref.read(salesInvoiceCtrlProvider.notifier);
      await controller.onInit(
        widget.data,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(salesInvoiceCtrlProvider.notifier);
    final state = ref.watch(salesInvoiceCtrlProvider);

    final isLoading = state.isLoading;
    return VGTSForm(
      key: controller.unFocusKey,
      child: AppOverlayLoaderWidget(
        isLoading: controller.salesInvoiceLoading,
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          appBar: AppBarWidget.empty(
            title: "Invoice: #${controller.billNo ?? ''}",
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: Divider(height: 1.h),
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
                                  key: Key("save_as_draft"),
                                  'Save As Draft',
                                  textStyle: AppTextStyle.blueFS14FW500,
                                  height: 35.h,
                                  borderRadius: BorderRadius.circular(8.r),
                                  onPressed: () =>
                                      controller.saveInvoice(isDraft: true),
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
                                onPressed: () => controller.saveInvoice(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          body: SafeArea(
            child: SingleChildScrollView(
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
                      billNo: controller.billNo,
                      billDateTextCtrl: controller.billDateTextCtrl,
                      dueDateTextCtrl: controller.dueDateTextCtrl,
                      warehouseTextCtrl: controller.warehouseTextCtrl,
                      isInventoryEnabled: controller.isInventoryEnabled,
                      referenceBillNo: controller.referenceBillNoTextCtrl,
                      paymentTermTextCtrl: controller.paymentTermTextCtrl,
                      salesPersonTextCtrl: controller.salesPersonTextCtrl,
                      deliveryDateTextCtrl: controller.deliveryDateTextCtrl,
                      placeOfSupplyTextCtrl: controller.placeOfSupplyTextCtrl,
                      modeOfTransportTextCtrl:
                          controller.modeOfTransportTextCtrl,
                      openPlaceOfSupply:
                          controller.openPlaceOfSupplyBottomSheet,
                      openDuePeriodBottomSheet:
                          controller.openDuePeriodBottomSheet,
                      openDueDatePicker: controller.openDueDatePicker,
                      openBillDatePicker: controller.openBillDatePicker,
                      openWarehouseBottomSheet:
                          controller.openWarehouseBottomSheet,
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
                        height: 35.h,
                        isLoading: isLoading,
                        shimmerEffect: true,
                        loadingIndicatorColor: AppColors.primary,
                        padding:
                            isLoading ? EdgeInsets.zero : EdgeInsets.all(8),
                        borderColor: isLoading
                            ? AppColors.greyColor300
                            : AppColors.blueColor,
                        onPressed: () => controller.onViewItem(),
                        icon: Icon(Icons.add,
                            size: 20, color: AppColors.blueColor),
                        textStyle: AppTextStyle.blueFS14FW500,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: BillSummary(
                      billSummaryRequest: BillSummaryRequest(
                        totalCost: controller.totalCost,
                        hasRoundingOff: controller.billConfig?.hasRoundingOff,
                        isDiscountBeforeTax:
                            controller.billConfig?.isDiscountBeforeTax,
                        isGstRegister: controller.isGstRegister,
                        taxTextCtrl: controller.taxTextCtrl,
                        roundedTextCtrl: controller.roundedTextCtrl,
                        subTotalTextCtrl: controller.subTotalTextCtrl,
                        adjustAmtTextCtrl: controller.adjustAmtTextCtrl,
                        tdsTcsAmtTextCtrl: controller.tdsTcsAmtTextCtrl,
                        discountAmtTextCtrl: controller.discountAmtTextCtrl,
                        shippingAmtTextCtrl: controller.shippingAmtTextCtrl,
                        adjustmentNameTextCtrl:
                            controller.adjustmentNameTextCtrl,
                        adjustmentText: controller.adjustmentText,
                        adjustmentIndex: controller.selectedAdjustment,
                        discountType: controller.discountTypeIndex,
                        tdsTcsAppliedTxt: controller.tdsTcsAppliedTxt,
                        discountAppliedText: controller.discountAppliedText,
                        selectedItemList: controller.selectedItemList,
                        tdsTcsValueModel: controller.tdsTcsValueModel,
                        selectedGstTaxModel: controller.selectedGstTaxModel,
                        selectedTdsTcsModel: controller.selectedTdsTcsModel,
                        tdsTcsBottomSheet: controller.tdsTcsBottomSheet,
                        adjustmentBottomSheet: controller.adjustmentBottomSheet,
                        onDiscountBottomSheet: controller.discountBottomSheet,
                        removeTdsTcs: controller.removeTdsTcs,
                        tdsTcsValueBottomSheet:
                            controller.tdsTcsValueBottomSheet,
                        openDiscountDetailBottomSheet:
                            controller.openDiscountDetailBottomSheet,
                        onDiscountChange: controller.discountChange,
                        onAdjustmentChange: controller.adjustmentChange,
                        onShippingCostChange: controller.onShippingCostChange,
                        openGstBreakDownBottomSheet:
                            controller.openGstBreakDownBottomSheet,
                      ),
                    ),
                  ),
                  if (controller.isError)
                    const AppErrorWidget(msg: AppStrings.totalAmtError),
                  if (!isLoading)
                    NotesWidget(
                      onEdit: controller.onTermsEdit,
                      isTermsEdit: controller.isTermsEdit,
                      notesTxtCtrl: controller.noteTextCtrl,
                      termConditionTxtCtrl: controller.termConditionTxtCtrl,
                    ),
                  gapH45,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
