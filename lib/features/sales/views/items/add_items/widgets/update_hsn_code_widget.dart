import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vgts_plugin/form/vgts_form.dart';

import '../../../../../../app/common_widgets/app_text_field_widgets/app_text_field_widget.dart';
import '../../../../../../app/common_widgets/button.dart';
import '../../../../../../app/constants/app_sizes.dart';
import '../add_items_ctrl.dart';

class UpdateHsnCodeWidget extends ConsumerWidget {
  const UpdateHsnCodeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(addItemCtrlProvider.notifier);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: VGTSForm(
        key: controller.hsnCodeFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextFieldWidget(
              ctrl: controller.hsnCodeCtrl,
              maxLength: 8,
              hintText: 'Hsn code',
              borderRadius: 8.r,
              constraints: BoxConstraints(maxHeight: 40.h),
              textFieldPadding: 0,
            ),
            gapH16,
            AppButton(
              key: Key("save_hsn_code"),
              'Update',
              height: 35.h,
              onPressed: controller.updateHsnCode,
              isLoading: controller.isHsnCodeLoading,
              borderRadius: BorderRadius.circular(8.r),
            ),
            gapH16
          ],
        ),
      ),
    );
  }
}
