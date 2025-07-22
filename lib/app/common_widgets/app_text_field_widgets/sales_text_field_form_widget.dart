import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../styles/colors.dart';
import '../../styles/text_styles.dart';
import 'app_text_field_widget.dart';

class SalesTextFieldFormWidget extends StatelessWidget {
  final String? hintText;
  final String? label;
  final int? maxLength;
  final int? maxLines;
  final bool? isEnabled;
  final bool? isOptional;
  final bool isLabel;
  final bool? readOnly;
  final Color? borderColor;
  final Function(String)? onChanged;
  final void Function()? onTap;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatter;
  final AutovalidateMode? autovalidateMode;
  final TextStyle? style;
  final TextCapitalization textCapitalization;
  final TextStyle? hintStyle;
  final TextAlign? textAlign;
  final double? borderRadius;
  final BoxConstraints? constraints;
  final TextFieldBorder? inputBorder;
  final TextEditingController? ctrl;
  final TextInputType? keyboardTextType;
  final FocusNode? focusNode;
  final bool autoFocus ;

  const SalesTextFieldFormWidget(
      {super.key,
      this.focusNode,
      this.autoFocus = false,
      this.hintText,
      this.maxLength,
      this.textCapitalization = TextCapitalization.none,
      this.label,
      this.isOptional,
      this.isLabel = true,
      this.isEnabled,
      this.readOnly,
      this.onChanged,
      this.onTap,
      this.validator,
      this.suffixIcon,
      this.inputFormatter,
      this.autovalidateMode,
      this.style,
      this.hintStyle,
      this.textAlign,
      this.borderRadius,
      this.constraints = const BoxConstraints(maxHeight: 40),
      this.inputBorder,
      this.ctrl,
      this.borderColor,
      this.keyboardTextType,
      this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return AppTextFieldWidget.form(
      focusNode: focusNode,
      maxLength: maxLength,
      autoFocus: autoFocus,
      hintText: hintText,
      maxLines: maxLines,
      isOptional: isOptional,
      label: label,
      isLabel: isLabel,
      suffixIcon: suffixIcon,
      onTap: onTap ?? () {},
      isEnabled: isEnabled ?? true,
      readOnly: readOnly ?? false,
      onChanged: onChanged ?? (value) {},
      validator: validator,
      inputFormatter: inputFormatter,
      textCapitalization: textCapitalization,
      autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
      style: AppTextStyle.darkBlackFS12FW500,
      hintStyle: AppTextStyle.greyFS12FW500,
      textAlign: textAlign ?? TextAlign.start,
      borderRadius: borderRadius ?? 8.r,
      constraints: constraints,
      inputBorder: TextFieldBorder(
          borderColor: borderColor ?? AppColors.greyColor, borderRadius: 8.r),
      ctrl: ctrl ?? TextEditingController(),
      fillColor: AppColors.greyColor100,
      keyboardTextType: keyboardTextType ?? TextInputType.text,
    );
  }
}
