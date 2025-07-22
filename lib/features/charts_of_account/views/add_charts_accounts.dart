import 'package:flutter/material.dart';
import 'package:vgts_plugin/form/vgts_form.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/constants/app_sizes.dart';
import '../../../app/common_widgets/button.dart';
import '../../../app/common_widgets/app_bar_widget.dart';
import '../../../app/common_widgets/app_loading_widget.dart';
import '../../../app/common_widgets/app_text_field_widgets/app_text_field_widget.dart';
import '../../../app/common_widgets/app_text_field_widgets/sales_text_field_form_widget.dart';

import '../../../app/styles/colors.dart';
import '../../../app/styles/text_styles.dart';
import '../../../app/constants/app_ui_constants.dart';
import 'add_charts_accounts_ctrl.dart';

class AddChartsAccounts extends ConsumerStatefulWidget {
  const AddChartsAccounts({super.key, required this.id});
  final List<int> id;

  @override
  ConsumerState<AddChartsAccounts> createState() => _AddChartsAccountsState();
}

class _AddChartsAccountsState extends ConsumerState<AddChartsAccounts> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ctrl = ref.read(addChartsAccountsCtrlProvider.notifier);
      ctrl.onInit(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(addChartsAccountsCtrlProvider.notifier);
    final state = ref.watch(addChartsAccountsCtrlProvider);

    return VGTSForm(
      key: controller.accountsFormKey,
      child: AppOverlayLoaderWidget(
        isLoading: controller.isLoading,
        child: Scaffold(
          appBar: AppBarWidget.empty(
            title: "Create New Account",
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: Divider(height: 1.h),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(height: 1),
                Padding(
                  padding: EdgeInsets.only(
                      left: 16.w, right: 16.w, top: 10.h, bottom: 0.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppButton.outline(
                          key: Key("clear"),
                          'Clear',
                          textStyle: AppTextStyle.blueFS14FW500,
                          height: 35.h,
                          borderRadius: BorderRadius.circular(8.r),
                          onPressed: controller.onClear,
                        ),
                      ),
                      gapW20,
                      Expanded(
                        child: AppButton(
                          key: Key("save"),
                          'Save',
                          height: 35.h,
                          borderRadius: BorderRadius.circular(8.r),
                          onPressed: controller.saveAccount,
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
                SalesTextFieldFormWidget(
                  readOnly: true,
                  label: 'Account Type',
                  hintText: 'Select Account Type',
                  onTap: controller.openAccountTypeBottomSheet,
                  ctrl: controller.accountTypeTextCtrl,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  suffixIcon: const Icon(Icons.keyboard_arrow_down,
                      color: AppColors.fuscousGreyColor, size: 18),
                ),
                gapH8,
                SalesTextFieldFormWidget(
                  isEnabled: true,
                  label: 'Account Name',
                  hintText: 'Enter Account Name',
                  ctrl: controller.accountNameTextCtrl,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                if (controller.accountTypeTextCtrl.text.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      gapH4,
                      InkWell(
                        onTap: controller.makeAsDefaultAccount,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 4.w),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: AppUiConstants.checkBoxDecoration(
                                    controller.markAsDefault
                                        ? AppColors.blueColor
                                        : Colors.white),
                                child: SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: !controller.markAsDefault
                                        ? const SizedBox()
                                        : const Icon(Icons.check,
                                            size: 15, color: Colors.white)),
                              ),
                              gapW10,
                              Text('Make this a sub-account',
                                  style: AppTextStyle.darkBlackFS12FW500)
                            ],
                          ),
                        ),
                      ),
                      if (controller.markAsDefault)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            gapH3,
                            SalesTextFieldFormWidget(
                              readOnly: true,
                              label: 'Parent Account',
                              hintText: 'Select Parent Type',
                              onTap: controller.openParentTypeBottomSheet,
                              ctrl: controller.parentAccountTextCtrl,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              suffixIcon: const Icon(Icons.keyboard_arrow_down,
                                  color: AppColors.fuscousGreyColor, size: 18),
                            ),
                          ],
                        ),
                    ],
                  ),
                gapH8,
                AppTextFieldWidget.form(
                  maxLines: 5,
                  isEnabled: true,
                  isOptional: true,
                  style: AppTextStyle.darkBlackFS12FW500,
                  hintStyle: AppTextStyle.greyFS12FW500,
                  label: 'Account Description ',
                  hintText: 'Enter Account Description',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  ctrl: TextEditingController(text: ''),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
