import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vgts_plugin/form/utils/input_formatter.dart';
import 'package:vgts_plugin/form/utils/input_validator.dart';
import 'package:vgts_plugin/form/vgts_form.dart';
import 'package:yoloworks_invoice/app/common_widgets/app_bar_widget.dart';
import 'package:yoloworks_invoice/app/common_widgets/app_outside_focus_remover.dart';
import 'package:yoloworks_invoice/app/constants/app_sizes.dart';
import 'package:yoloworks_invoice/features/item/model/inventory_item_details_model.dart';
import '../../../../../app/common_widgets/app_loading_widget.dart';
import '../../../../../app/common_widgets/app_text_field_widgets/app_text_field_widget.dart';
import '../../../../../app/common_widgets/button.dart';
import '../../../../../app/styles/colors.dart';
import '../../../../../app/styles/text_styles.dart';
import 'item_edit_controller.dart';



enum ItemEditType{basic,stockDetail,taxPreference,accountDetail}


class ItemEditView extends ConsumerStatefulWidget {
  const ItemEditView({super.key,this.editDetails});
  final InventoryItemDetailsModel? editDetails;

  @override
  ConsumerState createState() => _ItemEditViewState();
}

class _ItemEditViewState extends ConsumerState<ItemEditView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = ref.read(itemEditControllerProvider.notifier);
      controller.onInit(widget.editDetails);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(itemEditControllerProvider.notifier);
    final state = ref.watch(itemEditControllerProvider);
    return AppOverlayLoaderWidget(
      isLoading: state.isLoading,
      child: Scaffold(
        appBar: AppBarWidget.empty(
          title: "Edit Tax Preference",
        ),
        bottomNavigationBar: state.isLoading
            ? null
            : SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(height: 1),
              Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child:  AppButton(
                    key: Key("update_item_"),
                    iconAlignment: Alignment.centerRight,
                   'Update',
                    height: 40.h,
                    width: MediaQuery.of(context).size.width * .5,
                    icon: const Icon(Icons.arrow_forward,
                        color: Colors.white, size: 18),
                    isLoading: state.isLoading, onPressed: controller.onUpdate),
              ),
            ],
          ),
        ),
        body: AppOutsideFocusRemover(
          child: Builder(
              builder: (context) {
            switch (controller.itemEditType) {
              case ItemEditType.stockDetail:
                return const _StockDetailEdit();
              case ItemEditType.taxPreference:
                return const _TaxPreferenceEditWidget();
              case ItemEditType.accountDetail:
                return const _AccountDetailEdit();
              case ItemEditType.basic:
              default:
                return const SizedBox();
            }
          }),
        ),
      ));
  }
}

class _StockDetailEdit extends ConsumerWidget {
  const _StockDetailEdit({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(itemEditControllerProvider.notifier);
    final state = ref.watch(itemEditControllerProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          AppTextFieldWidget.form(
              ctrl: controller.minStockReminderCtrl,
              keyboardTextType: TextInputType.number,
              isOptional: true,
              label: 'Min Stock Reminder',
              autoFocus: true,
              // validator: (val) => InputValidator.emptyValidator(val,
              //     requiredText: 'Type is Required'),
              inputFormatter: InputFormatter.numberFormatter,
              hintStyle: AppTextStyle.titleSmall,
              suffixIcon: SizedBox(
                width: 30,
                child: Center(
                  child: Text(
                    controller.editDetailsData?.itemUnits?.first.baseUnit??controller.editDetailsData?.itemUnits?.first.unit,
                    style: AppTextStyle.greyFS14FW500,
                  ),
                ),
              )),
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
                        suffixIcon:
                        const Icon(Icons.keyboard_arrow_down, size: 18),
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
        ],
      ),
    );
  }
}
class _TaxPreferenceEditWidget extends ConsumerWidget {
  const _TaxPreferenceEditWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(itemEditControllerProvider.notifier);
    final state = ref.watch(itemEditControllerProvider);
    return VGTSForm(
      key:controller.taxPrefsKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
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
                          ),                              hintStyle: AppTextStyle.titleSmall,
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
          ],
        ),
      ),
    );
  }
}


class _AccountDetailEdit extends ConsumerWidget {
  const _AccountDetailEdit({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(itemEditControllerProvider.notifier);
    final state = ref.watch(itemEditControllerProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
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
      ),
    );
  }
}
