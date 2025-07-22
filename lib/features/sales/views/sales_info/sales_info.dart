import 'package:flutter/material.dart';

import 'package:yoloworks_invoice/app/constants/app_sizes.dart';
import 'package:yoloworks_invoice/app/styles/colors.dart';

import '../../../../app/styles/text_styles.dart';

import '../../../../app/common_widgets/shimmer_widget/shimmer_effect.dart';
import '../../../../app/common_widgets/app_text_field_widgets/sales_text_field_form_widget.dart';

class SalesInfoWidget extends StatelessWidget {
  const SalesInfoWidget(
      {super.key,
      this.billNo,
      this.isOrder = false,
      this.isPurchaseOrder = false,
      required this.isInventoryEnabled ,
      this.dueDateTextCtrl,
      this.billDateTextCtrl,
      required this.warehouseTextCtrl,
      required this.paymentTermTextCtrl,
      this.salesPersonTextCtrl,
      this.deliveryDateTextCtrl,
      this.expectedDeliveryDateTextCtrl,
      required this.placeOfSupplyTextCtrl,
      this.modeOfTransportTextCtrl,
      this.openDueDatePicker,
      this.openBillDatePicker,
      this.referenceBillNo,
      this.referenceBillDateCtrl,
      this.openRefBillDatePicker,
      this.openExpectedDeliveryDatePicker,
      required this.openPlaceOfSupply,
      this.openDeliveryDatePicker,
      required this.openDuePeriodBottomSheet,
      required this.openWarehouseBottomSheet,
      this.openSalesPersonBottomSheet,
      this.openModeOfTransportBottomSheet});

  final bool isOrder;
  final String? billNo;
  final bool isPurchaseOrder;
  final bool isInventoryEnabled;

  final TextEditingController? dueDateTextCtrl;
  final TextEditingController? billDateTextCtrl;
  final TextEditingController? referenceBillNo;
  final TextEditingController warehouseTextCtrl;
  final TextEditingController placeOfSupplyTextCtrl;
  final TextEditingController? paymentTermTextCtrl;
  final TextEditingController? salesPersonTextCtrl;
  final TextEditingController? deliveryDateTextCtrl;
  final TextEditingController? referenceBillDateCtrl;
  final TextEditingController? modeOfTransportTextCtrl;
  final TextEditingController? expectedDeliveryDateTextCtrl;

  final void Function() openPlaceOfSupply;
  final void Function() openDuePeriodBottomSheet;
  final void Function() openWarehouseBottomSheet;
  final void Function()? openModeOfTransportBottomSheet;

  final void Function()? openDueDatePicker;
  final void Function()? openBillDatePicker;
  final void Function()? openExpectedDeliveryDatePicker;
  final void Function({bool? doClear})? openRefBillDatePicker;
  final void Function({bool? doClear})? openDeliveryDatePicker;
  final void Function({bool? doClear})? openSalesPersonBottomSheet;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: SalesTextFieldFormWidget(
                label: isOrder ? "Order No" : 'Bill No',
                isEnabled: true,
                readOnly: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                ctrl: TextEditingController(text: billNo),
              ),
            ),
            if (isOrder && !isPurchaseOrder) gapW16,
            if (isOrder && !isPurchaseOrder)
              Expanded(
                child: SalesTextFieldFormWidget(
                  label: isOrder ? "So Date" : 'Bill Date',
                  isEnabled: true,
                  readOnly: true,
                  suffixIcon: const Icon(Icons.keyboard_arrow_down,
                      color: AppColors.fuscousGreyColor, size: 18),
                  onTap: openBillDatePicker,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  ctrl: billDateTextCtrl,
                ),
              ),
          ],
        ),
        if(isInventoryEnabled) gapH8,
        if(isInventoryEnabled)  SalesTextFieldFormWidget(
          onTap: openWarehouseBottomSheet,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          ctrl: warehouseTextCtrl,
          readOnly: true,
          label: 'Warehouse',
          suffixIcon: const Icon(Icons.keyboard_arrow_down,
              color: AppColors.fuscousGreyColor, size: 18),
        ),
        gapH8,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!isPurchaseOrder)
              Expanded(
                child: SalesTextFieldFormWidget(
                  label: isOrder ? 'Payment Term' : 'Due Period',
                  isEnabled: true,
                  readOnly: true,
                  suffixIcon: const Icon(Icons.keyboard_arrow_down,
                      color: AppColors.fuscousGreyColor, size: 18),
                  onTap: openDuePeriodBottomSheet,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  ctrl: paymentTermTextCtrl,
                ),
              ),
            if (!isPurchaseOrder) gapW16,
            Expanded(
                child: SalesTextFieldFormWidget(
                    onTap: openPlaceOfSupply,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    ctrl: placeOfSupplyTextCtrl,
                    readOnly: true,
                    label: 'Place Of Supply',
                    suffixIcon: const Icon(Icons.keyboard_arrow_down,
                        color: AppColors.fuscousGreyColor, size: 18)))
          ],
        ),
        gapH8,
        if (isOrder && !isPurchaseOrder)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SalesTextFieldFormWidget(
                  label: 'Delivery Date',
                  isOptional: true,
                  readOnly: true,
                  suffixIcon: deliveryDateTextCtrl?.text.isNotEmpty == true
                      ? InkWell(
                          onTap: openDeliveryDatePicker == null
                              ? null
                              : () {
                                  openDeliveryDatePicker!(doClear: true);
                                },
                          child: Icon(Icons.close,
                              color: AppColors.fuscousGreyColor, size: 16),
                        )
                      : Icon(Icons.keyboard_arrow_down,
                          color: AppColors.fuscousGreyColor, size: 18),
                  onTap: openDeliveryDatePicker == null
                      ? null
                      : openDeliveryDatePicker,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  ctrl: deliveryDateTextCtrl,
                ),
              ),
              gapW16,
              Expanded(
                child: SalesTextFieldFormWidget(
                  label: 'Expected Delivery Date',
                  isEnabled: true,
                  readOnly: true,
                  suffixIcon: const Icon(Icons.keyboard_arrow_down,
                      color: AppColors.fuscousGreyColor, size: 18),
                  onTap: openExpectedDeliveryDatePicker,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  ctrl: expectedDeliveryDateTextCtrl,
                ),
              ),
            ],
          ),
        if (!isOrder || isPurchaseOrder)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SalesTextFieldFormWidget(
                  label: isPurchaseOrder ? "Po Date" : 'Bill Date',
                  isEnabled: true,
                  readOnly: true,
                  suffixIcon: const Icon(Icons.keyboard_arrow_down,
                      color: AppColors.fuscousGreyColor, size: 18),
                  onTap: openBillDatePicker,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  ctrl: billDateTextCtrl,
                ),
              ),
              gapW16,
              if (isPurchaseOrder)
                Expanded(
                  child: SalesTextFieldFormWidget(
                    label: 'Delivery Date',
                    readOnly: true,
                    suffixIcon: deliveryDateTextCtrl?.text.isNotEmpty == true
                        ? InkWell(
                            onTap: openDeliveryDatePicker == null
                                ? null
                                : () {
                                    openDeliveryDatePicker!(doClear: true);
                                  },
                            child: Icon(Icons.close,
                                color: AppColors.fuscousGreyColor, size: 16),
                          )
                        : Icon(Icons.keyboard_arrow_down,
                            color: AppColors.fuscousGreyColor, size: 18),
                    onTap: openDeliveryDatePicker == null
                        ? null
                        : openDeliveryDatePicker,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    ctrl: deliveryDateTextCtrl,
                  ),
                ),
              if (!isPurchaseOrder)
                Expanded(
                  child: SalesTextFieldFormWidget(
                    label: 'Due Date',
                    isEnabled: true,
                    readOnly: true,
                    suffixIcon: const Icon(Icons.keyboard_arrow_down,
                        color: AppColors.fuscousGreyColor, size: 18),
                    onTap: openDueDatePicker,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    ctrl: dueDateTextCtrl,
                  ),
                ),
            ],
          ),
        if (isOrder)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SalesTextFieldFormWidget(
                    label: 'Mode Of Transport',
                    isEnabled: true,
                    readOnly: true,
                    suffixIcon: const Icon(Icons.keyboard_arrow_down,
                        color: AppColors.fuscousGreyColor, size: 18),
                    onTap: openModeOfTransportBottomSheet,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    ctrl: modeOfTransportTextCtrl,
                    keyboardTextType: TextInputType.number),
              ),
              if (!isPurchaseOrder) gapW16,
              if (!isPurchaseOrder)
                Expanded(
                    child: SalesTextFieldFormWidget(
                        onTap: openSalesPersonBottomSheet,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        ctrl: salesPersonTextCtrl,
                        readOnly: true,
                        isOptional: true,
                        label: 'Sales Person',
                        suffixIcon: salesPersonTextCtrl?.text.isNotEmpty == true
                            ? InkWell(
                                onTap: openSalesPersonBottomSheet == null
                                    ? null
                                    : () {
                                        openSalesPersonBottomSheet!(
                                            doClear: true);
                                      },
                                child: Icon(Icons.close,
                                    color: AppColors.fuscousGreyColor,
                                    size: 16),
                              )
                            : const Icon(Icons.keyboard_arrow_down,
                                color: AppColors.fuscousGreyColor, size: 18)))
            ],
          ),
        if (isOrder) gapH8,
        if (isOrder)
          Row(
            children: [
              Expanded(
                child: SalesTextFieldFormWidget(
                  label: 'Ref No',
                  isOptional: true,
                  isEnabled: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  ctrl: referenceBillNo,
                ),
              ),
              if (!isPurchaseOrder) gapW16,
              if (!isPurchaseOrder)
                Expanded(
                  child: SalesTextFieldFormWidget(
                    label: 'Ref Date',
                    isEnabled: true,
                    isOptional: true,
                    readOnly: true,
                    suffixIcon: referenceBillDateCtrl?.text.isNotEmpty == true
                        ? InkWell(
                            onTap: () {
                              openRefBillDatePicker!(doClear: true);
                            },
                            child: Icon(Icons.close,
                                color: AppColors.fuscousGreyColor, size: 16),
                          )
                        : const Icon(Icons.keyboard_arrow_down,
                            color: AppColors.fuscousGreyColor, size: 18),
                    onTap: openRefBillDatePicker,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    ctrl: referenceBillDateCtrl,
                  ),
                ),
            ],
          ),
        gapH8,
      ],
    );
  }
}

class SalesInfoWidgetLoading extends StatelessWidget {
  const SalesInfoWidgetLoading();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < 6; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerWidget.text(height: 25, width: 120),
                ShimmerWidget.circular(
                  height: 40,
                  width: 140,
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                )
              ],
            ),
          ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerWidget.text(height: 25, width: 120),
            ShimmerWidget.circular(
              height: 40,
              width: 140,
              shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            )
          ],
        )
      ],
    );
  }
}

class BillDueDateWidget extends StatelessWidget {
  const BillDueDateWidget(
      {super.key,
      required this.title,
      required this.value,
      this.onTap,
      this.isIcon = false});
  final String title;
  final String value;
  final bool isIcon;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap != null ? () => onTap!() : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: AppTextStyle.greyFS10FW600),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: isIcon
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.start,
            children: [
              Text(value, style: AppTextStyle.darkBlackFS14FW500),
              if (isIcon) const Icon(Icons.calendar_month_outlined, size: 20)
            ],
          ),
        ],
      ),
    );
  }
}
