import 'package:flutter/material.dart';
import 'package:yoloworks_invoice/app/constants/app_sizes.dart';
import 'package:yoloworks_invoice/core/extension/currency_extension.dart';

import '../../models/master_model/tax_model.dart';
import '../../models/master_model/gst_tax_model.dart';
import '../../models/item_model/sales_line_item.dart';
import 'summary_item_widget.dart';

import '../../../../app/styles/text_styles.dart';

class BillSummary extends StatelessWidget {
  const BillSummary({super.key, required this.billSummaryRequest});
  final BillSummaryRequest billSummaryRequest;

  @override
  Widget build(BuildContext context) {
    final salesMasterInfoCtrl = billSummaryRequest;
    final isBeforeTax = (salesMasterInfoCtrl.isDiscountBeforeTax == true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gapH10,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pricing Summary',
              style: AppTextStyle.darkBlackFS14FW600,
            ),
            if (salesMasterInfoCtrl.openBeforeAfterTaxBottomSheet != null)
              InkWell(
                onTap: salesMasterInfoCtrl.openBeforeAfterTaxBottomSheet,
                child: Row(
                  children: [
                    Text(
                      isBeforeTax
                          ? 'Discount Before Tax'
                          : 'Discount After Tax',
                      style: AppTextStyle.darkBlackFS12FW500,
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                    )
                  ],
                ),
              ),
          ],
        ),
        gapH8,
        SummaryItemWidget(
            readOnly: true,
            isEnabled: salesMasterInfoCtrl.selectedItemList.isNotEmpty,
            ctrl: salesMasterInfoCtrl.subTotalTextCtrl,
            title:
                'Subtotal of ${salesMasterInfoCtrl.selectedItemList.length} ${salesMasterInfoCtrl.selectedItemList.length > 1 ? 'Items' : 'Item'}',
            subTitle: salesMasterInfoCtrl.isGstRegister
                ? '(${salesMasterInfoCtrl.selectedGstTaxModel.id == 1 ? 'Tax Exclusive' : 'Tax Inclusive'})'
                : null),
        if (isBeforeTax)
          SummaryItemWidget(
            title: 'Discount',
            isDropDown: true,
            isShowInfoTap: true,
            ctrl: salesMasterInfoCtrl.discountAmtTextCtrl,
            isPercent: salesMasterInfoCtrl.discountType == 1,
            isEnabled: salesMasterInfoCtrl.selectedItemList.isNotEmpty,
            titleText: salesMasterInfoCtrl.discountType == 2 ? '₹' : '%',
            subTitle:
                'Discount applied on: ${salesMasterInfoCtrl.discountAppliedText}',
            hintText: salesMasterInfoCtrl.discountType == 2 ? '₹0.00' : '0.00%',
            onChanged: salesMasterInfoCtrl.onDiscountChange,
            onTap: salesMasterInfoCtrl.onDiscountBottomSheet,
            onInfoTap: salesMasterInfoCtrl.openDiscountDetailBottomSheet,
          ),
        if (salesMasterInfoCtrl.isGstRegister)
          SummaryItemWidget(
            readOnly: true,
            isShowInfoTap: true,
            title: 'Tax Amount',
            isEnabled: salesMasterInfoCtrl.selectedItemList.isNotEmpty,
            ctrl: salesMasterInfoCtrl.taxTextCtrl,
            onTap: salesMasterInfoCtrl.openGstBreakDownBottomSheet,
          ),
        if (!isBeforeTax)
          SummaryItemWidget(
            title: 'Discount',
            isDropDown: true,
            isShowInfoTap: true,
            ctrl: salesMasterInfoCtrl.discountAmtTextCtrl,
            isPercent: salesMasterInfoCtrl.discountType == 1,
            isEnabled: salesMasterInfoCtrl.selectedItemList.isNotEmpty,
            titleText: salesMasterInfoCtrl.discountType == 2 ? '₹' : '%',
            subTitle:
                'Discount applied on: ${salesMasterInfoCtrl.discountAppliedText}',
            hintText: salesMasterInfoCtrl.discountType == 2 ? '₹0.00' : '0.00%',
            onChanged: salesMasterInfoCtrl.onDiscountChange,
            onTap: salesMasterInfoCtrl.onDiscountBottomSheet,
            onInfoTap: salesMasterInfoCtrl.openDiscountDetailBottomSheet,
          ),
        if ((salesMasterInfoCtrl.isDiscountAdded ||
                salesMasterInfoCtrl.isLineDiscountApplied == true) &&
            salesMasterInfoCtrl.accountsTextCtrl != null)
          DiscountAccountWidget(
            readOnly: true,
            title: 'Discount Account',
            ctrl: salesMasterInfoCtrl.accountsTextCtrl!,
            onRemoveTap: salesMasterInfoCtrl.removeDiscountAccount,
            onTap: salesMasterInfoCtrl.openDiscountAccountBottomSheet,
            isEnabled: salesMasterInfoCtrl.selectedItemList.isNotEmpty,
          ),
        SummaryItemWidget(
          title: 'Shipping Cost',
          ctrl: salesMasterInfoCtrl.shippingAmtTextCtrl,
          onChanged: salesMasterInfoCtrl.onShippingCostChange,
          isEnabled: salesMasterInfoCtrl.selectedItemList.isNotEmpty,
        ),
        TdsTcsSummary(
          readOnly: true,
          title2: salesMasterInfoCtrl.tdsTcsValueModel?.name,
          title1: '${salesMasterInfoCtrl.selectedTdsTcsModel?.title}',
          ctrl: salesMasterInfoCtrl.tdsTcsAmtTextCtrl,
          subTitle: salesMasterInfoCtrl.tdsTcsAppliedTxt,
          onInfoTap: salesMasterInfoCtrl.tdsTcsBottomSheet,
          onTap: salesMasterInfoCtrl.tdsTcsValueBottomSheet,
          isEnabled: salesMasterInfoCtrl.selectedItemList.isNotEmpty,
          onRemoveTap: salesMasterInfoCtrl.removeTdsTcs,
        ),
        const Divider(),
        SummaryItemWidget(
            isEnabled: salesMasterInfoCtrl.selectedItemList.isNotEmpty,
            ctrl: salesMasterInfoCtrl.adjustAmtTextCtrl,
            adjustmentCtrl: salesMasterInfoCtrl.adjustmentNameTextCtrl,
            title: 'Adjustment',
            isAdjustmentField: true,
            titleText:
                salesMasterInfoCtrl.adjustmentIndex == adjustmentModel.first
                    ? '- (Sub)'
                    : '+ (Add)',
            subTitle: 'Adjustment: ${salesMasterInfoCtrl.adjustmentText}',
            isPercent: false,
            hintText:
                salesMasterInfoCtrl.adjustmentIndex == adjustmentModel.first
                    ? '- ₹0.00'
                    : '₹0.00',
            isDropDown: true,
            onChanged: salesMasterInfoCtrl.onAdjustmentChange,
            onTap: salesMasterInfoCtrl.adjustmentBottomSheet),
        if (salesMasterInfoCtrl.isGstRegister &&
            salesMasterInfoCtrl.hasRoundingOff == true)
          SummaryItemWidget(
            readOnly: true,
            title: 'Round Off',
            hintText: '₹0.00',
            ctrl: salesMasterInfoCtrl.roundedTextCtrl,
            isEnabled: salesMasterInfoCtrl.selectedItemList.isNotEmpty,
          ),
        const Divider(),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: AppTextStyle.darkBlackFS16FW700),
                Expanded(
                    child: Text(
                  salesMasterInfoCtrl.totalCost.toCurrencyFormatString(),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.darkBlackFS16FW700,
                )),
              ],
            )),
      ],
    );
  }
}

class BillSummaryRequest {
  final bool isGstRegister;
  final int discountType;
  final AdjustmentDiscountModel adjustmentIndex;

  final double totalCost;
  final String adjustmentText;
  final String? tdsTcsAppliedTxt;
  final String discountAppliedText;
  final bool? hasRoundingOff;
  final bool isDiscountAdded;
  final bool? isDiscountBeforeTax;
  final bool? isLineDiscountApplied;
  final GstTaxModel selectedGstTaxModel;
  final List<SalesLineItem> selectedItemList;

  final TaxModel? tdsTcsValueModel;
  final TdsTcsModel? selectedTdsTcsModel;

  final TextEditingController taxTextCtrl;
  final TextEditingController roundedTextCtrl;
  final TextEditingController subTotalTextCtrl;
  final TextEditingController adjustAmtTextCtrl;
  final TextEditingController? accountsTextCtrl;
  final TextEditingController adjustmentNameTextCtrl;
  final TextEditingController tdsTcsAmtTextCtrl;
  final TextEditingController discountAmtTextCtrl;
  final TextEditingController shippingAmtTextCtrl;

  final void Function() tdsTcsBottomSheet;
  final void Function() adjustmentBottomSheet;
  final void Function() onDiscountBottomSheet;
  final void Function() removeTdsTcs;
  final void Function() tdsTcsValueBottomSheet;
  final void Function(String)? onDiscountChange;
  final void Function(String)? onAdjustmentChange;
  final void Function(String)? onShippingCostChange;
  final void Function()? removeDiscountAccount;
  final void Function() openGstBreakDownBottomSheet;
  final void Function()? openDiscountAccountBottomSheet;
  final void Function() openDiscountDetailBottomSheet;
  final void Function()? openBeforeAfterTaxBottomSheet;

  BillSummaryRequest(
      {required this.isGstRegister,
      required this.discountType,
      required this.adjustmentIndex,
      required this.hasRoundingOff,
      required this.totalCost,
      required this.adjustmentText,
      required this.discountAppliedText,
      required this.tdsTcsAppliedTxt,
      required this.selectedGstTaxModel,
      required this.selectedItemList,
      required this.tdsTcsValueModel,
      required this.selectedTdsTcsModel,
      required this.isDiscountBeforeTax,
      required this.taxTextCtrl,
      required this.removeTdsTcs,
      this.accountsTextCtrl,
      this.isDiscountAdded = false,
      this.isLineDiscountApplied,
      required this.roundedTextCtrl,
      required this.subTotalTextCtrl,
      required this.adjustAmtTextCtrl,
      required this.adjustmentNameTextCtrl,
      required this.tdsTcsAmtTextCtrl,
      required this.discountAmtTextCtrl,
      required this.shippingAmtTextCtrl,
      required this.tdsTcsBottomSheet,
      required this.adjustmentBottomSheet,
      required this.onDiscountBottomSheet,
      required this.tdsTcsValueBottomSheet,
      required this.openDiscountDetailBottomSheet,
      this.openBeforeAfterTaxBottomSheet,
      this.openDiscountAccountBottomSheet,
      this.removeDiscountAccount,
      required this.onDiscountChange,
      required this.onAdjustmentChange,
      required this.onShippingCostChange,
      required this.openGstBreakDownBottomSheet});
}
