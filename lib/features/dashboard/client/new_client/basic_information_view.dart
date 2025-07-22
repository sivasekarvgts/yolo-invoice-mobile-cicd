import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vgts_plugin/form/utils/input_formatter.dart';
import 'package:vgts_plugin/form/utils/input_validator.dart';
import 'package:vgts_plugin/form/vgts_form.dart';
import '../../../../app/common_widgets/app_text_field_widgets/app_text_field_widget.dart';
import '../../../../app/common_widgets/app_text_prefix_widget.dart';
import '../../../../app/styles/colors.dart';
import '../../../../app/styles/text_styles.dart';
import 'new_client_controller.dart';

class BasicInformationView extends ConsumerStatefulWidget {
  const BasicInformationView({
    super.key,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BasicInformationViewState();
}

class _BasicInformationViewState extends ConsumerState<BasicInformationView> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(newClientControllerProvider.notifier);
    ref.watch(newClientControllerProvider);
    return VGTSForm(
      key: controller.basicInfoKey,
      child: Column(
        children: [
          if (controller.clientType == 2)
            AppTextFieldWidget.form(
                label: 'Name',
                hintText: 'Eg: Krishna',
                ctrl: controller.orgNameCtrl,
                maxLength: 100,
                prefixIcon: TextFieldPrefixWidget(
                    onTap: () {
                      controller.openSalutationWidget();
                    },
                    text: controller.selectedSalutationValue.name ?? "Mr."),
                inputFormatter: [NoLeadingSpaceFormatter()],
                textCapitalization: TextCapitalization.sentences,
                validator: (val) => InputValidator.emptyValidator(val,
                    requiredText: 'Name is Required!'))
          else
            AppTextFieldWidget.form(
                label: 'Organization Name',
                hintText: 'Eg: Krishna Sweets',
                ctrl: controller.orgNameCtrl,
                maxLength: 100,
                inputFormatter: [NoLeadingSpaceFormatter()],
                textCapitalization: TextCapitalization.sentences,
                validator: (val) => InputValidator.emptyValidator(val,
                    requiredText: 'Name is Required!')),
          if (controller.clientType != 2) const SizedBox(height: 10),
          if (controller.clientType != 2)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 1,
                    child: AppTextFieldWidget.form(
                      onTap: () => controller.openBusinessType(),
                      readOnly: true,
                      ctrl: controller.businessTypeCtrl,
                      label: 'Business Type',
                      hintText: 'Select from option',
                      validator: (val) => InputValidator.emptyValidator(val,
                          requiredText: 'Type is Required'),
                      hintStyle: AppTextStyle.titleSmall,
                      suffixIcon:
                          const Icon(Icons.keyboard_arrow_down, size: 18),
                    )),
                const SizedBox(width: 10),
                Expanded(
                    flex: 1,
                    child: AppTextFieldWidget.form(
                      onTap: () => controller.openBusinessCategory(),
                      readOnly: true,
                      ctrl: controller.businessCategoryCtrl,
                      label: 'Business Category',
                      hintText: 'Select from option',
                      validator: (val) => InputValidator.emptyValidator(val,
                          requiredText: 'Category is Required'),
                      hintStyle: AppTextStyle.titleSmall,
                      suffixIcon:
                          const Icon(Icons.keyboard_arrow_down, size: 18),
                    ))
              ],
            ),
          const SizedBox(height: 16),
          AppTextFieldWidget.form(
              ctrl: controller.openingBalanceCtrl,
              textInputAction: TextInputAction.next,
              keyboardTextType: TextInputType.number,
              validator: (val) => controller.openingBalanceOptional
                  ? InputValidator.amountValidator(val,
                      isOptional: false, isZeroAmt: true)
                  : null,
              isOptional: true,
              prefixIcon:
                  TextFieldPrefixWidget(onTap: () => null, text: 'Debit'),
              onChanged: controller.balanceOnChange,
              inputFormatter: [CurrencyInputFormatter()],
              label: 'Opening Balance',
              hintText: '₹0'),
          const SizedBox(height: 16),
          if (controller.clientType != 2)
            AppTextFieldWidget.form(
                prefixIcon: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text('🇮🇳'))
                    ]),
                inputBorder: TextFieldBorder(
                    borderColor: AppColors.greyColor300, borderRadius: 8),
                fillColor: AppColors.greyColor100,
                filled: true,
                isEnabled: false,
                hintStyle: AppTextStyle.titleSmall,
                label: 'Business Location',
                hintText: 'India'),
        ],
      ),
    );
  }
}
