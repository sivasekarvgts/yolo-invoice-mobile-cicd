import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vgts_plugin/form/utils/input_formatter.dart';

import '../../../../app/common_widgets/app_text_field_widgets/app_text_field_widget.dart';
import '../../../../app/constants/app_sizes.dart';
import '../../../../app/styles/colors.dart';
import '../../../../app/styles/text_styles.dart';

class SummaryItemWidget extends StatelessWidget {
  const SummaryItemWidget(
      {super.key,
      required this.title,
      this.titleText,
      this.hintText,
      this.subTitle,
      this.onTap,
      this.onInfoTap,
      this.isSubtract = false,
      this.readOnly = false,
      this.isPercent = false,
      this.isDropDown = false,
      required this.isEnabled,
      required this.ctrl,
      this.adjustmentCtrl,
      this.onChanged,
      this.focusNode,
      this.validator,
      this.constraints,
      this.isShowInfoTap = false,
      this.isAdjustmentField});

  final String title;
  final String? subTitle;
  final String? hintText;
  final String? titleText;
  final BoxConstraints? constraints;
  final bool isDropDown;
  final bool isPercent;
  final bool readOnly;
  final bool isSubtract;
  final bool isEnabled;
  final bool isShowInfoTap;
  final bool? isAdjustmentField;
  final FocusNode? focusNode;
  final TextEditingController ctrl;
  final TextEditingController? adjustmentCtrl;
  final Function()? onTap;
  final Function()? onInfoTap;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isAdjustmentField == true)
                Row(
                  children: [
                    SizedBox(
                      width: 80.w,
                      child: AppTextFieldWidget(
                          hintText: 'Adjustment',
                          validator: validator,
                          textFieldPadding: 0,
                          maxLines: 1,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          style: AppTextStyle.darkBlackFS12FW500,
                          hintStyle: AppTextStyle.darkBlackFS12FW500,
                          constraints:
                              constraints ?? BoxConstraints(maxHeight: 30.h),
                          borderRadius: 6.r,
                          inputBorder: TextFieldBorder(
                              borderColor: !isEnabled || readOnly
                                  ? AppColors.greyColor300
                                  : AppColors.darkBlackColor,
                              borderRadius: 6.r),
                          fillColor: AppColors.greyColor100,
                          ctrl: adjustmentCtrl,
                          filled: isEnabled,
                          isEnabled: isEnabled,
                          readOnly: readOnly,
                          focusNode: focusNode,
                          maxLength: 50,
                          keyboardTextType: TextInputType.text),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: onTap,
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              const VerticalDivider(color: Colors.black),
                              Row(
                                children: [
                                  Text('$titleText',
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyle.darkBlackFS12FW500),
                                  gapW5,
                                  const Icon(Icons.keyboard_arrow_down,
                                      size: 19)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              else
                InkWell(
                  onTap: onTap,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: (isShowInfoTap)
                            ? InkWell(
                                onTap: onInfoTap,
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text(title,
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                              AppTextStyle.darkBlackFS12FW500),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 4),
                                      child: Icon(Icons.info_outline_rounded,
                                          size: 18),
                                    ),
                                  ],
                                ),
                              )
                            : Text(title,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.darkBlackFS12FW500),
                      ),
                      if (titleText != null)
                        Flexible(
                          child: IntrinsicHeight(
                            child: Row(
                              children: [
                                const VerticalDivider(color: Colors.black),
                                Row(
                                  children: [
                                    Text('$titleText',
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyle.darkBlackFS12FW500),
                                    gapW5,
                                    const Icon(Icons.keyboard_arrow_down,
                                        size: 19)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              if (subTitle != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    gapH4,
                    Text(subTitle!, style: AppTextStyle.greyFS10FW600),
                  ],
                ),
            ],
          )),
          gapW15,
          Expanded(
            child: AppTextFieldWidget(
                hintText: hintText ?? '₹0.00',
                validator: validator,
                inputFormatter: !isPercent
                    ? [AmountInputFormatter(maxDigits: 8)]
                    : [PercentageNumbersFormatter()],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                style: AppTextStyle.darkBlackFS12FW500,
                hintStyle: AppTextStyle.darkBlackFS12FW500,
                textAlign: TextAlign.end,
                constraints: constraints ?? BoxConstraints(maxHeight: 35),
                borderRadius: 8.r,
                inputBorder: TextFieldBorder(
                    borderColor: !isEnabled || readOnly
                        ? AppColors.greyColor300
                        : AppColors.darkBlackColor,
                    borderRadius: 8.r),
                fillColor: AppColors.greyColor100,
                ctrl: ctrl,
                filled: isEnabled,
                isEnabled: isEnabled,
                readOnly: readOnly,
                focusNode: focusNode,
                onChanged: onChanged,
                keyboardTextType: TextInputType.number),
          )
        ],
      ),
    );
  }
}

class DiscountAccountWidget extends StatelessWidget {
  const DiscountAccountWidget(
      {super.key,
      required this.title,
      required this.readOnly,
      required this.isEnabled,
      required this.ctrl,
      this.onTap,
      this.onRemoveTap,
      this.validator});
  final String title;
  final bool readOnly;
  final bool isEnabled;
  final TextEditingController ctrl;
  final Function()? onTap;
  final Function()? onRemoveTap;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Text(title,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.darkBlackFS12FW500),
          ),
          gapW15,
          Expanded(
              child: AppTextFieldWidget(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: AppTextStyle.darkBlackFS12FW500,
            hintStyle: AppTextStyle.darkBlackFS12FW500,
            textAlign: TextAlign.start,
            borderRadius: 8.r,
            maxLines: 1,
            contentPadding: EdgeInsets.only(left: 8.w),
            constraints: BoxConstraints(maxHeight: 35.h),
            inputBorder: TextFieldBorder(
                borderColor: !isEnabled || readOnly
                    ? AppColors.greyColor300
                    : AppColors.darkBlackColor,
                borderRadius: 8.r),
            suffixIcon: ctrl.text.isEmpty
                ? Icon(
                    Icons.keyboard_arrow_down,
                    size: 15,
                    color: AppColors.darkBlackColor,
                  )
                : InkWell(
                    onTap: onRemoveTap,
                    child: Icon(
                      Icons.clear,
                      size: 15,
                      color: AppColors.darkBlackColor,
                    ),
                  ),
            fillColor: AppColors.greyColor100,
            ctrl: ctrl,
            onTap: onTap,
            validator: validator,
            filled: isEnabled,
            isEnabled: isEnabled,
            readOnly: readOnly,
            keyboardTextType: TextInputType.number,
          )),
        ],
      ),
    );
  }
}

class TdsTcsSummary extends StatelessWidget {
  const TdsTcsSummary(
      {super.key,
      required this.onRemoveTap,
      required this.title1,
      this.title2,
      this.hintText,
      this.subTitle,
      this.onTap,
      this.onInfoTap,
      this.readOnly = false,
      this.isPercent = false,
      required this.isEnabled,
      required this.ctrl,
      this.onChanged,
      this.focusNode,
      this.validator,
      this.isShowInfoTap = false,
      this.constraints});

  final String title1;
  final String? title2;
  final String? subTitle;
  final String? hintText;
  final bool isPercent;
  final BoxConstraints? constraints;

  final bool readOnly;
  final bool isEnabled;
  final bool isShowInfoTap;
  final FocusNode? focusNode;
  final TextEditingController ctrl;
  final void Function()? onTap;
  final void Function()? onInfoTap;
  final void Function() onRemoveTap;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: InkWell(
                      onTap: onInfoTap,
                      child: Row(
                        children: [
                          Text(title1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.darkBlackFS12FW500),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Icon(Icons.keyboard_arrow_down, size: 19),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: InkWell(
                      onTap: onTap,
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(title2 ?? 'Select $title1',
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.darkBlackFS12FW500),
                          ),
                          gapW5,
                          title2 != null
                              ? InkWell(
                                  onTap: onRemoveTap,
                                  child: Icon(Icons.clear, size: 15))
                              : const Icon(Icons.keyboard_arrow_down, size: 19)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (subTitle != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    gapH4,
                    Text(subTitle!, style: AppTextStyle.greyFS12FW500),
                  ],
                ),
            ],
          )),
          gapW15,
          Expanded(
            child: AppTextFieldWidget(
                hintText: hintText ?? '₹0.00',
                validator: validator,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                style: AppTextStyle.darkBlackFS12FW500,
                hintStyle: AppTextStyle.darkBlackFS12FW500,
                textAlign: TextAlign.end,
                borderRadius: 8.r,
                constraints: constraints ?? BoxConstraints(maxHeight: 35.h),
                inputBorder: TextFieldBorder(
                    borderColor: !isEnabled || readOnly
                        ? AppColors.greyColor300
                        : AppColors.darkBlackColor,
                    borderRadius: 8.r),
                fillColor: AppColors.greyColor100,
                ctrl: ctrl,
                filled: isEnabled,
                isEnabled: isEnabled,
                readOnly: readOnly,
                focusNode: focusNode,
                onChanged: onChanged,
                keyboardTextType: TextInputType.number),
          )
        ],
      ),
    );
  }
}
