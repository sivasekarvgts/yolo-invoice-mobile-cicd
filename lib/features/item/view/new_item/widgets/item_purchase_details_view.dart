import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vgts_plugin/form/utils/input_formatter.dart';
import 'package:vgts_plugin/form/utils/input_validator.dart';
import 'package:vgts_plugin/form/vgts_form.dart';
import 'package:yoloworks_invoice/app/styles/colors.dart';

import '../../../../../app/common_widgets/app_text_field_widgets/app_text_field_widget.dart';
import '../../../../../app/common_widgets/app_text_prefix_widget.dart';
import '../../../../../app/constants/app_sizes.dart';
import '../../../../../app/styles/text_styles.dart';
import '../item_create_controller.dart';

class ItemPurchaseDetailsView extends ConsumerStatefulWidget {
  const ItemPurchaseDetailsView({super.key});

  @override
  ConsumerState createState() => _ItemPurchaseDetailsViewState();
}

class _ItemPurchaseDetailsViewState
    extends ConsumerState<ItemPurchaseDetailsView> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(itemCreateControllerProvider.notifier);
    final state = ref.watch(itemCreateControllerProvider);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Center(
            child: Text('Purchase Details',
                style: AppTextStyle.titleLarge
                    .copyWith(fontWeight: fontWeight700)),
          ),
        ),
        InkWell(
          onTap: controller.toggleOpeningStock,
          child: Row(
            children: [
              if (controller.haveOpeningStock)
                Icon(
                  Icons.check_box,
                  color: AppColors.primary,
                )
              else
                Icon(
                  Icons.check_box_outline_blank,
                  color: AppColors.greyColor,
                ),
              gapW5,
              Text(
                "Have opening stock? Check the box.",
                style: AppTextStyle.blackFS14FW500,
              )
            ],
          ),
        ),
        gapH10,
        AppTextFieldWidget.form(
            ctrl: controller.openingStockCtrl,
            keyboardTextType: TextInputType.number,
            label: 'Opening Stock',
            isEnabled: controller.haveOpeningStock,
            validator: (val) =>
                InputValidator.emptyValidator(val, requiredText: 'Required!'),
            inputFormatter: controller.haveOpeningStock
                ? InputFormatter.numberFormatter
                : null,
            suffixIcon: SizedBox(
              width: 30,
              child: Center(
                child: Text(
                  controller.unitOfMeasureCtrl.text,
                  style: AppTextStyle.greyFS14FW500,
                ),
              ),
            )),
        gapH10,
        AppTextFieldWidget.form(
            ctrl: controller.minStockReminderCtrl,
            keyboardTextType: TextInputType.number,
            isOptional: true,
            isEnabled: controller.haveOpeningStock,
            label: 'Min Stock Reminder',
            // validator: (val) => InputValidator.emptyValidator(val,
            //     requiredText: 'Type is Required'),
            inputFormatter: InputFormatter.numberFormatter,
            hintStyle: AppTextStyle.titleSmall,
            suffixIcon: SizedBox(
              width: 30,
              child: Center(
                child: Text(
                  controller.unitOfMeasureCtrl.text,
                  style: AppTextStyle.greyFS14FW500,
                ),
              ),
            )),
        AppTextFieldWidget.form(
          ctrl: controller.costPerPcsCtrl,
          keyboardTextType: TextInputType.number,
          label: 'Cost per pcs',
          validator: (val) => InputValidator.amountValidator(val,
              isEqualTo: true,
              isOptional: false,
              requiredText: 'Cost per pcs is Required'),
          inputFormatter: [
            AmountInputFormatter(
              maxDigits: 7,
              decimalRange: 2,
            )
          ],
          suffixIcon: InkWell(
              onTap: () =>
                  controller.openSalesPurchaseIncExcTaxBottomSheet(true),
              child: TextFieldSuffixWidget(
                title: controller.selectedPurchaseIncExcTax.title ,
              )),
        ),
        gapH10,
        AppTextFieldWidget.form(
          ctrl: controller.purchaseAccountCtrl,
          onTap: controller.openPurchaseAccountBottomSheet,
          isEnabled: true,
          readOnly: true,
          label: 'Purchase Account',
          validator: (val) => InputValidator.emptyValidator(val,
              requiredText: 'Purchase Account is Required'),
          hintStyle: AppTextStyle.titleSmall,
          suffixIcon: const Icon(Icons.keyboard_arrow_down, size: 18),
        ),
        gapH10,
        AppTextFieldWidget.form(
          ctrl: controller.inventoryAccountCtrl,
          onTap: controller.openInventoryAccountBottomSheet,
          isEnabled: true,
          readOnly: true,
          label: 'Inventory Account',
          validator: (val) => InputValidator.emptyValidator(val,
              requiredText: 'Inventory Account is Required'),
          hintStyle: AppTextStyle.titleSmall,
          suffixIcon: const Icon(Icons.keyboard_arrow_down, size: 18),
        ),
      ],
    );
  }
}
