import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoloworks_invoice/app/styles/colors.dart';

import '../../styles/text_styles.dart';

class AppTextFieldWidget extends StatelessWidget {
  AppTextFieldWidget({
    super.key,
    this.cursorHeight,
    this.optionalText,
    this.isOptional,
    this.errorText,
    this.errorStyle,
    this.prefixIconConstraints,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.ctrl,
    this.prefix,
    this.readOnly = false,
    this.hintText,
    this.keyboardTextType,
    this.textInputAction = TextInputAction.next,
    this.hintStyle,
    this.style,
    this.textAlign = TextAlign.left,
    this.isEnabled = true,
    this.autoFocus = false,
    this.borderRadius = 4,
    this.textFieldPadding = 5,
    this.contentPadding = const EdgeInsets.all(5),
    this.inputFormatter,
    this.onTap,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.validate,
    this.focusNode,
    this.inputBorder,
    this.label,
    this.isLabel = false,
    this.filled,
    this.fillColor,
    this.autovalidateMode,
    this.maxLength,
    this.maxLines,
    this.constraints,
    this.borderColor,
  });

  AppTextFieldWidget.form({
    super.key,
    this.cursorHeight,
    this.optionalText,
    this.errorText,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    this.prefixIconConstraints,
    this.isOptional,
    this.errorStyle,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.ctrl,
    this.hintText,
    this.prefix,
    this.keyboardTextType,
    this.textInputAction = TextInputAction.next,
    this.hintStyle,
    this.style,
    this.textAlign = TextAlign.left,
    this.isEnabled = true,
    this.autoFocus = false,
    this.borderRadius = 8,
    this.textFieldPadding = 5,
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    this.inputFormatter,
    this.onTap,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.validate,
    this.focusNode,
    this.inputBorder,
    this.label,
    this.isLabel = true,
    this.filled,
    this.fillColor,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.maxLength,
    this.maxLines = 1,
    this.constraints,
    this.borderColor,
  });

  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? prefix;
  final InputBorder? inputBorder;
  final TextEditingController? ctrl;
  final TextInputType? keyboardTextType;
  final TextInputAction textInputAction;
  final BoxConstraints? constraints;
  final String? hintText;
  final String? label;
  final String? errorText;
  final String? optionalText;
  final bool? isOptional;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final TextStyle? errorStyle;
  final TextAlign textAlign;
  final bool isEnabled;
  final bool isLabel;
  final bool readOnly;
  final bool autoFocus;
  final bool? validate;
  final bool? filled;
  final int? maxLength;
  final int? maxLines;
  final Color? fillColor;
  final double borderRadius;
  final Color? borderColor;
  final double? cursorHeight;
  final double textFieldPadding;
  final TextCapitalization textCapitalization;
  final EdgeInsetsGeometry contentPadding;
  final FocusNode? focusNode;
  final AutovalidateMode? autovalidateMode;
  final List<TextInputFormatter>? inputFormatter;
  final Function()? onTap;
  final VoidCallback? onEditingComplete;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final BoxConstraints? prefixIconConstraints;

  @override
  Widget build(BuildContext context) {
    final effectiveHintStyle = hintStyle ??
        AppTextStyle.titleSmall.copyWith(color: AppColors.greyColor);
    final effectiveStyle = style ?? AppTextStyle.titleSmall;

    return Wrap(
      children: [
        if (isLabel)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
            child: Row(
              children: [
                Text(label!, style: AppTextStyle.darkBlackFS12FW500),
                if (isOptional == true)
                  Text('(${optionalText ?? 'Optional'})',
                      style: AppTextStyle.darkBlackFS12FW500.copyWith(
                          color: AppColors.greyColor,
                          fontWeight: fontWeight500))
              ],
            ),
          ),
        Padding(
          padding: isLabel ? EdgeInsets.zero : EdgeInsets.all(textFieldPadding),
          child: TextFormField(
            cursorHeight: cursorHeight,
            maxLength: maxLength,
            maxLines: maxLines,
            readOnly: readOnly,
            textCapitalization: textCapitalization,
            autovalidateMode: autovalidateMode,
            enableInteractiveSelection: true,
            focusNode: focusNode,
            autofocus: autoFocus,
            controller: ctrl,
            enabled: isEnabled,
            onTap: onTap,
            onChanged: onChanged,
            onEditingComplete: onEditingComplete,
            onFieldSubmitted: onFieldSubmitted,
            textAlign: textAlign,
            style: effectiveStyle,
            inputFormatters: inputFormatter,
            keyboardType: keyboardTextType,
            textInputAction: textInputAction,
            validator: validator,
            decoration: InputDecoration(
                errorText: errorText,
                constraints: constraints,
                counterText: '',
                suffixIcon: suffixIcon,
                prefixIcon: prefixIcon,
                prefix: prefix,
                contentPadding: contentPadding,
                hintText: hintText,
                hintStyle: effectiveHintStyle,
                errorMaxLines: 2,
                fillColor: fillColor,
                filled: filled,
                prefixIconConstraints: prefixIconConstraints,
                errorStyle:
                    errorStyle ?? const TextStyle(color: AppColors.redColor),
                enabledBorder: inputBorder ??
                    TextFieldBorder(
                        borderRadius: borderRadius, borderColor: borderColor),
                border: inputBorder ??
                    TextFieldBorder(
                        borderRadius: borderRadius, borderColor: borderColor),
                disabledBorder: inputBorder ??
                    TextFieldBorder(
                        borderRadius: borderRadius, borderColor: borderColor),
                focusedBorder: inputBorder ??
                    TextFieldBorder(
                        borderRadius: borderRadius, borderColor: borderColor),
                focusedErrorBorder: TextFieldBorder(
                    borderRadius: borderRadius,
                    borderColor: AppColors.redColor),
                errorBorder: TextFieldBorder(
                    borderRadius: borderRadius,
                    borderColor: AppColors.redColor)),
          ),
        ),
      ],
    );
  }
}

class TextFieldBorder extends OutlineInputBorder {
  TextFieldBorder({
    required double borderRadius,
    Color? borderColor,
  }) : super(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: borderColor ?? AppColors.greyColor));
}
