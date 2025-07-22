import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vgts_plugin/form/utils/input_formatter.dart';
import 'package:vgts_plugin/form/utils/input_validator.dart';
import 'package:vgts_plugin/form/vgts_form.dart';
import 'package:yoloworks_invoice/app/constants/app_sizes.dart';
import 'package:yoloworks_invoice/app/styles/colors.dart';

import '../../../../../app/common_widgets/app_text_field_widgets/app_text_field_widget.dart';
import '../../../../../app/common_widgets/app_text_prefix_widget.dart';
import '../../../../../app/styles/text_styles.dart';
import '../../../model/inventory_item_create_request_model.dart';
import '../item_create_controller.dart';

class ItemSaleDetailsView extends ConsumerStatefulWidget {
  const ItemSaleDetailsView({super.key});

  @override
  ConsumerState createState() => _ItemSaleDetailsViewState();
}

class _ItemSaleDetailsViewState extends ConsumerState<ItemSaleDetailsView> {
  @override
  Widget build(BuildContext context) {

    final controller = ref.watch(itemCreateControllerProvider.notifier);
    final state = ref.watch(itemCreateControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Center(
            child: Text('Sale Details',
                style: AppTextStyle.titleLarge
                    .copyWith(fontWeight: fontWeight700)),
          ),
        ),
        AppTextFieldWidget.form(
          ctrl: controller.unitOfMeasureCtrl,
          readOnly: true,
          onTap: () => controller.openUnitOfMeasureBottomSheet(),
          label: 'Unit of Measure',
          hintText: 'Select from options',
          validator: (val) => InputValidator.emptyValidator(val,
              requiredText: 'UOM is Required'),
          hintStyle: AppTextStyle.titleSmall,
          suffixIcon: InkWell(
              onTap: controller.openCategoryBottomSheet,
              child: const Icon(Icons.keyboard_arrow_down, size: 18)),
        ),
        gapH10,
        AppTextFieldWidget.form(
          ctrl: controller.salePricePerUnitCtrl,
          keyboardTextType: TextInputType.number,
          suffixIcon: InkWell(
              onTap: () => controller.openSalesPurchaseIncExcTaxBottomSheet(),
              child: TextFieldSuffixWidget(
                title: controller.selectedSalesIncExcTax.title,
              )),
          onChanged: controller.onChangePrice,
          label: 'Sale Price Per Unit',
          hintText: '₹0.00',
          validator: (val) => InputValidator.amountValidator(val,
              isEqualTo: true,
              isOptional: false,
              requiredText: 'Price is Required'),
          inputFormatter: [
            AmountInputFormatter(maxDigits: 11),
          ],
          hintStyle: AppTextStyle.titleSmall,
        ),
        gapH10,
        if (controller.addUomListCtrl.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Unit of Measure",
                    style: AppTextStyle.darkBlackFS12FW500,
                  ),
                ),
                Expanded(
                  child: Text(
                    "Quantity",
                    style: AppTextStyle.darkBlackFS12FW500,
                  ),
                ),
                Expanded(
                  child: Text(
                    "Sales Price",
                    style: AppTextStyle.darkBlackFS12FW500,
                  ),
                ),
                gapW10,
              ],
            ),
          ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: controller.addUomListCtrl.length,
          itemBuilder: (context, index) {
            final item = controller.addUomListCtrl[index];
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppTextFieldWidget.form(
                    isLabel: false,
                    ctrl: item.uomListCtrl,
                    readOnly: true,
                    onTap: () =>
                        controller.openUnitOfMeasureBottomSheet(index: index),
                    validator: (val) => InputValidator.emptyValidator(val,
                        requiredText: 'Required'),
                    suffixIcon: Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                    ),
                    hintText: 'Select from options',
                    hintStyle: AppTextStyle.titleSmall,
                  ),
                ),
                Expanded(
                  child: AppTextFieldWidget.form(
                    isLabel: false,
                    ctrl: item.quantityListCtrl,
                    onChanged: controller.onChangePrice,
                    validator: (val) => InputValidator.amountValidator(val,
                        isEqualTo: true,
                        isOptional: false,
                        requiredText: 'Required'),
                    keyboardTextType: TextInputType.number,
                    inputFormatter: [
                      AmountInputFormatter(
                        maxDigits: 7,
                        decimalRange: 2,
                        isSymbol: false,
                      )
                    ],
                    suffixIcon: SizedBox(
                      width: 30.w,
                      child: Center(
                        child: Text(
                          controller.unitOfMeasureCtrl.text,
                          style: AppTextStyle.greyFS14FW500,
                        ),
                      ),
                    ),
                    hintStyle: AppTextStyle.titleSmall,
                  ),
                ),
                Expanded(
                  child: AppTextFieldWidget.form(
                    isLabel: false,
                    ctrl: item.salesPriceListCtrl,
                    hintStyle: AppTextStyle.titleSmall,
                    hintText: '₹0.00',
                    keyboardTextType: TextInputType.number,
                    validator: (val) => InputValidator.amountValidator(val,
                        isEqualTo: true,
                        isOptional: false,
                        requiredText: 'Required'),
                    onChanged: (v) {
                      controller.onManualChangeAddUOM(index);
                    },
                    inputFormatter: [
                      AmountInputFormatter(maxDigits: 11),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    controller.addUomListCtrl.removeAt(index);
                    controller.setState;
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Icon(
                      Icons.clear,
                      color: AppColors.redColor,
                      size: 22.w,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        InkWell(
          onTap: () {
            controller.addUomListCtrl.add(AddUnitModel(
              // uomListCtrl: TextEditingController(),
              // quantityListCtrl: TextEditingController(),
              // salesPriceListCtrl: TextEditingController(),
            ));
            controller.setState;
          },
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Text(
              "+ Add UOM",
              style: AppTextStyle.blueFS14FW500,
            ),
          ),
        ),
        AppTextFieldWidget.form(
          onTap: () => controller.openTaxPreferenceBottomSheet(),
          readOnly: true,
          ctrl: controller.taxPreferenceCtrl,
          label: 'Tax Preference',
          hintText: 'Select from option',
          // validator: (val) => InputValidator.emptyValidator(val,
          //     requiredText: 'Type is Required'),
          hintStyle: AppTextStyle.titleSmall,
          suffixIcon: const Icon(Icons.keyboard_arrow_down, size: 18),
        ),
        if (controller.selectedTaxPreference?.code == 1)
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 1,
                    child: AppTextFieldWidget.form(
                      readOnly: true,
                      label: 'Gst Rate',
                      hintText: 'Select from options',
                      ctrl: controller.gstRateCtrl,
                      onTap: controller.openGstRateBottomSheet,
                      validator: (val) => InputValidator.emptyValidator(val,
                          requiredText: 'GST Rate is Required'),
                      hintStyle: AppTextStyle.titleSmall,
                      suffixIcon:
                          const Icon(Icons.keyboard_arrow_down, size: 18),
                    )),
                const SizedBox(width: 10),
                Expanded(
                    flex: 1,
                    child: AppTextFieldWidget.form(
                      ctrl: controller.cessRateCtrl,
                      readOnly: true,
                      isOptional: true,
                      label: 'CESS Rate',
                      hintText: 'Select from options',
                      onTap: controller.openCessBottomSheet,
                      suffixIcon: (controller.selectedCess == null)
                          ? const Icon(Icons.keyboard_arrow_down, size: 18)
                          : InkWell(
                        onTap: controller.clearCESS,
                        child: Icon(
                          Icons.clear,
                          size: 18,
                          color: AppColors.darkJungleBlackColor,
                        ),
                      ),
                      hintStyle: AppTextStyle.titleSmall,
                    ))
              ],
            ),
          ),
        if (controller.selectedTaxPreference?.code == 2)
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: AppTextFieldWidget.form(
              onTap: controller.openExemptionReasonBottomSheet,
              ctrl: controller.exemptionReasonCtrl,
              readOnly: true,
              validator: (val) => InputValidator.emptyValidator(val,
                  requiredText: 'Reason is Required'),
              label: 'Exemption Reason',
              hintText: 'Select from options',
              suffixIcon: const Icon(Icons.keyboard_arrow_down, size: 18),
              hintStyle: AppTextStyle.titleSmall,
            ),
          ),
        gapH10,
        AppTextFieldWidget.form(
          ctrl: controller.salesAccountCtrl,
          readOnly: true,
          onTap: controller.openSalesAccountBottomSheet,
          validator: (val) => InputValidator.emptyValidator(val,
              requiredText: 'Sales Account is Required'),
          label: 'Sales Account',
          hintText: 'Select from options',
          suffixIcon: const Icon(Icons.keyboard_arrow_down, size: 18),
          hintStyle: AppTextStyle.titleSmall,
        )
      ],
    );
  }
}
