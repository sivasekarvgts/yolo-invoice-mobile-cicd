import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vgts_plugin/form/utils/input_validator.dart';

import '../../../../app/common_widgets/app_text_field_widgets/app_text_field_widget.dart';
import '../../../../app/constants/app_sizes.dart';
import '../../../../app/styles/colors.dart';
import '../../../../app/styles/text_styles.dart';

class NotesWidget extends StatelessWidget {
  const NotesWidget(
      {super.key,
      this.onEdit,
      this.isTermsEdit = false,
      required this.notesTxtCtrl,
      required this.termConditionTxtCtrl});
  final TextEditingController notesTxtCtrl;
  final TextEditingController termConditionTxtCtrl;
  final void Function()? onEdit;
  final bool isTermsEdit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        gapH4,
        Row(
          children: [
            Text(
              'Note',
              style: AppTextStyle.darkBlackFS12FW500,
            ),
            const SizedBox(width: 4),
            Text(
              '(Optional)',
              style: AppTextStyle.greyFS10FW600,
            ),
          ],
        ),
        gapH5,
        AppTextFieldWidget(
          hintText: 'Write a note here...',
          ctrl: notesTxtCtrl,
          maxLines: 3,
          borderRadius: 8.r,
          textFieldPadding: 2,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
        gapH15,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Terms & Condition',
              style: AppTextStyle.darkBlackFS12FW500,
            ),
            if (!isTermsEdit)
              InkWell(
                onTap: onEdit,
                child: Text(
                  'Edit',
                  style: AppTextStyle.blueFS12FW500,
                ),
              ),
          ],
        ),
        gapH4,
        AppTextFieldWidget(
          textFieldPadding: 2,
          borderRadius: 8,
          maxLines: 3,
          ctrl: termConditionTxtCtrl,
          readOnly: !isTermsEdit,
          hintText: 'Terms & Condition',
          borderColor:
              !isTermsEdit ? Colors.transparent : AppColors.darkBlackColor,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (val) => InputValidator.emptyValidator(val),
        ),
      ],
    );
  }
}
