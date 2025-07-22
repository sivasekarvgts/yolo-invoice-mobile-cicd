import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vgts_plugin/form/utils/input_formatter.dart';
import 'package:vgts_plugin/form/utils/input_validator.dart';
import 'package:vgts_plugin/form/vgts_form.dart';
import 'package:yoloworks_invoice/app/styles/colors.dart';
import 'package:yoloworks_invoice/locator.dart';

import '../../../../../app/common_widgets/app_text_field_widgets/app_text_field_widget.dart';
import '../../../../../app/constants/app_sizes.dart';
import '../../../../../app/styles/text_styles.dart';
import '../../../../../router.dart';
import '../item_create_controller.dart';

class ItemBasicInfoView extends ConsumerStatefulWidget {
  const ItemBasicInfoView({super.key});

  @override
  ConsumerState createState() => _ItemBasicInfoViewState();
}

class _ItemBasicInfoViewState extends ConsumerState<ItemBasicInfoView> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(itemCreateControllerProvider.notifier);
    final state = ref.watch(itemCreateControllerProvider);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h),
          child: Center(
            child: Text('Basic Info',
                style: AppTextStyle.titleLarge
                    .copyWith(fontWeight: fontWeight700)),
          ),
        ),
        AppTextFieldWidget.form(
            label: 'Product Name',
            hintText: 'Eg: Smart Phone',
            ctrl: controller.productNameCtrl,
            maxLength: 100,
            inputFormatter: [NoLeadingSpaceFormatter()],
            textCapitalization: TextCapitalization.sentences,
            validator: (val) => InputValidator.emptyValidator(val,
                requiredText: 'Product Name is Required!')
        ),
        gapH10,
        AppTextFieldWidget.form(
          onTap: () => controller.openCategoryBottomSheet(),
          readOnly: true,
          ctrl: controller.categoryCtrl,
          label: 'Category Name',
          isOptional: true,
          hintText: 'Select from option',
          // validator: (val) => InputValidator.emptyValidator(val,
          //     requiredText: 'Type is Required'),
          hintStyle: AppTextStyle.titleSmall,
          suffixIcon: (controller.selectedCategory == null)
              ? const Icon(Icons.keyboard_arrow_down, size: 18)
              : InkWell(
                  onTap: controller.clearCategory,
                  child: Icon(
                    Icons.clear,
                    size: 18,
                    color: AppColors.darkJungleBlackColor,
                  ),
                ),
        ),
        gapH10,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 1,
                child: AppTextFieldWidget.form(
                  ctrl: controller.hsnCodeCtrl,
                  keyboardTextType: TextInputType.number,
                  label: 'HSN Code',
                  isOptional: true,
                  hintText: '***789',
                  // validator: (val) => InputValidator.emptyValidator(val,
                  //     requiredText: 'Type is Required'),
                  hintStyle: AppTextStyle.titleSmall,
                  suffixIcon: InkWell(
                      onTap: () async {
                        final res = await navigationService
                            .pushNamed(Routes.selectHsn);
                        if (res == null) return;
                        controller.selectedHsn = res;
                        controller.hsnCodeCtrl.text =
                            controller.selectedHsn?.name ?? "";
                      },
                      child: const Icon(Icons.search, size: 18)),
                )),
            gapW10,
            Expanded(
                flex: 1,
                child: AppTextFieldWidget.form(
                  ctrl: controller.skuBarCodeCtrl,
                  isOptional: true,
                  keyboardTextType: TextInputType.number,
                  label: 'SKU/Bar Code',
                  hintText: '***789',
                  maxLength: 8,
                  hintStyle: AppTextStyle.titleSmall,
                ))
          ],
        ),
        gapH10,
        AppTextFieldWidget.form(
          ctrl: controller.productDescriptionCtrl,
          isOptional: true,
          label: 'Product Description',
          hintText: 'Descriptions here...',
          maxLines: 3,
          hintStyle: AppTextStyle.titleSmall,
        )
      ],
    );
  }
}
