import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vgts_plugin/form/utils/input_formatter.dart';
import 'package:vgts_plugin/form/utils/input_validator.dart';
import 'package:vgts_plugin/form/vgts_form.dart';

import '../../../../app/common_widgets/app_bar_widget.dart';
import '../../../../app/common_widgets/app_text_field_widgets/app_text_field_widget.dart';
import '../../../../app/common_widgets/button.dart';
import '../../../../app/constants/app_sizes.dart';
import '../../../../app/styles/colors.dart';
import '../../../../app/styles/text_styles.dart';
import 'add_tds_tcs_ctrl.dart';

class AddTdsTcsSection extends ConsumerStatefulWidget {
  const AddTdsTcsSection({super.key, this.input});
  final Map? input;
  @override
  ConsumerState<AddTdsTcsSection> createState() => _AddTdsTcsSectionState();
}

class _AddTdsTcsSectionState extends ConsumerState<AddTdsTcsSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = ref.read(addTdsTcsCtrlProvider.notifier);
      await controller.onInit(widget.input);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(addTdsTcsCtrlProvider.notifier);
    final state = ref.watch(addTdsTcsCtrlProvider);

    final isLoading = state.isLoading;

    return Scaffold(
        appBar: AppBarWidget.empty(
          title: 'Add ${controller.tdsTcsModel?.id == 0 ? 'TDS' : 'TCS'}',
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(0), child: Divider(height: 1)),
        ),
        bottomNavigationBar: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AppButton('Save',
                    key: Key('save-tds-tcs'),
                    height: 45,
                    textStyle: AppTextStyle.whiteFS14FW500,
                    isLoading: isLoading,
                    borderColor: AppColors.blueColor,
                    color: AppColors.blueColor,
                    borderRadius: BorderRadius.circular(8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10), onPressed: () {
                  if (isLoading) return;
                  controller.saveTdsTcs();
                }),
              ),
            ],
          ),
        ),
        body: VGTSForm(
            key: controller.formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextFieldWidget.form(
                    label: 'Tax Name',
                    inputFormatter: [NoLeadingSpaceFormatter()],
                    maxLength: 100,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.sentences,
                    ctrl: controller.taxNameCtrl,
                    validator: (val) => InputValidator.emptyValidator(val,
                        requiredText: 'Tax Name is Required'),
                  ),
                  gapH10,
                  AppTextFieldWidget.form(
                    label: 'Tax Rate',
                    textInputAction: TextInputAction.next,
                    inputFormatter: [AmountInputFormatter(maxDigits: 8)],
                    ctrl: controller.taxRateCtrl,
                    keyboardTextType: TextInputType.number,
                    validator: (val) => InputValidator.emptyValidator(val,
                        requiredText: 'Tax Rate is Required'),
                  ),
                  gapH10,
                  AppTextFieldWidget.form(
                    label: 'Tax Type',
                    readOnly: true,
                    textInputAction: TextInputAction.next,
                    ctrl: controller.taxTypeCtrl,
                    suffixIcon:
                        Icon(Icons.keyboard_arrow_down, color: Colors.black),
                    onTap: () => controller.tdsTcsBottomSheet(),
                    validator: (val) => InputValidator.emptyValidator(val,
                        requiredText: 'Tax Type is Required'),
                  ),
                  gapH10,
                  AppTextFieldWidget.form(
                    label: 'Tax Description',
                    isOptional: true,
                    ctrl: controller.taxDescriptionCtrl,
                    maxLines: 3,
                    maxLength: 200,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ],
              ),
            )));
  }
}
