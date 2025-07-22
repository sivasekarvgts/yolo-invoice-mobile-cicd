import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vgts_plugin/form/utils/input_validator.dart';
import 'package:vgts_plugin/form/vgts_form.dart';

import '../../../../app/common_widgets/app_text_field_widgets/app_text_field_widget.dart';
import '../../../../app/styles/colors.dart';
import '../../../../app/styles/text_styles.dart';
import 'new_client_controller.dart';

class GstTreatmentView extends ConsumerStatefulWidget {
  const GstTreatmentView({
    super.key,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GstTreatmentViewState();
}

class _GstTreatmentViewState extends ConsumerState<GstTreatmentView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = ref.read(newClientControllerProvider.notifier);
      controller.fetchGstList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(newClientControllerProvider.notifier);
    ref.watch(newClientControllerProvider);
    return VGTSForm(
      key: controller.gstKey,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Center(
                child: Text('GST Treatment',
                    style: AppTextStyle.titleLarge
                        .copyWith(fontWeight: fontWeight700))),
          ),
          AppTextFieldWidget.form(
              onTap: () => controller.openGSTStatus(),
              readOnly: true,
              label: 'GST Status',
              ctrl: controller.gstStatusTextCtrl,
              hintText: 'Select from option',
              validator: (val) => InputValidator.emptyValidator(val,
                  requiredText: 'GST Status is Required'),
              hintStyle: AppTextStyle.titleSmall,
              suffixIcon: const Icon(Icons.keyboard_arrow_down,
                  color: Colors.black, size: 18)),
          const SizedBox(height: 16),
          AppTextFieldWidget.form(
            ctrl: controller.gstNoTextCtrl,
            label: 'GST Number',
            inputFormatter: [
              _GSTInputFormatter(),
              LengthLimitingTextInputFormatter(15)
            ],
            textCapitalization: TextCapitalization.characters,
            keyboardTextType: TextInputType.text,
            isEnabled: controller.selectedGSTValue.id == 1,
            hintText: 'GST Number',
            validator: (val) => controller.selectedGSTValue.id == 1
                ? gstNumberValidator(val,
                    requiredText: 'GST Status is Required')
                : null,
            inputBorder: controller.selectedGSTValue.id != 1
                ? TextFieldBorder(
                    borderColor: AppColors.greyColor300, borderRadius: 8)
                : null,
            fillColor: controller.selectedGSTValue.id != 1
                ? AppColors.greyColor100
                : null,
            filled: controller.selectedGSTValue.id != 1,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  static String? gstNumberValidator(String? value, {String? requiredText}) {
    if (value?.trim().isEmpty != false) {
      return requiredText ?? "Required !";
    }

    if (value?.trim().length != 15) {
      return requiredText ?? "Invalid GST Number !";
    }

    if (!RegExp(r"\d{2}[A-Z]{5}\d{4}[A-Z]{1}[A-Z\d]{1}[Z]{1}[A-Z\d]{1}")
        .hasMatch(value!)) {
      return "Please enter a valid GST Number";
    }

    return null;
  }
}

class _GSTInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final String filteredValue =
        newValue.text.replaceAll(RegExp(r'[^A-Z0-9]'), '');
    return TextEditingValue(
      text: filteredValue,
      selection: TextSelection.collapsed(offset: filteredValue.length),
    );
  }
}
