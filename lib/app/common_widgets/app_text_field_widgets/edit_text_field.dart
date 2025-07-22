// ignore_for_file: must_be_immutable, invalid_use_of_protected_member

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vgts_plugin/form/utils/form_field_controller.dart';
import '../../styles/colors.dart';
import '../../styles/text_styles.dart';

TextStyle _errorTextStyle = AppTextStyle.bodyMedium.copyWith(
    color: AppColors.error, fontSize: 13, fontWeight: FontWeight.w500);
TextStyle _bodyTextStyle = AppTextStyle.bodyMedium;
TextStyle _hintTextStyle = AppTextStyle.bodyMedium
    .copyWith(color: const Color(0xffbdc1c6), fontWeight: fontWeight400);

BorderRadius _borderRadius = BorderRadius.circular(12.0);

class EditTextField extends StatefulWidget {
  FormFieldController controller;

  String label;
  TextStyle? textStyle;
  TextAlign textAlign;
  bool? readOnly = false;
  EdgeInsets? margin;
  EdgeInsets? padding;
  TextInputAction textInputAction;
  String? placeholder;
  Widget? prefixIcon;
  Widget? suffixIcon;
  String? prefixText;
  String? counterText;
  bool autoFocus = false;
  bool isPasswordField = false;
  bool enabled = true;
  TextInputType? textInputType;
  int? maxLines;
  int? maxLetters;
  List<TextInputFormatter>? textInputFormatters;
  TextCapitalization? textCapitalization;
  ValueChanged<String>? onChanged = (terms) {};
  ValueChanged<String>? onSubmitted = (terms) {};

  EditTextField(this.label, this.controller,
      {Key? key,
      this.margin = EdgeInsets.zero,
      this.onSubmitted,
      this.onChanged,
      this.readOnly = false,
      this.autoFocus = false,
      this.enabled = true,
      this.prefixText,
      this.placeholder,
      this.prefixIcon,
      this.padding,
      this.textAlign = TextAlign.left,
      this.textStyle,
      this.textInputAction = TextInputAction.next,
      this.suffixIcon,
      this.textCapitalization,
      this.textInputType,
      this.textInputFormatters,
      this.maxLines,
      this.maxLetters,
      this.counterText})
      : super(key: key);

  EditTextField.password(this.label, this.controller,
      {Key? key,
      this.margin = EdgeInsets.zero,
      this.onSubmitted,
      this.onChanged,
      this.enabled = true,
      this.autoFocus = false,
      this.prefixText,
      this.placeholder,
      this.prefixIcon,
      this.padding,
      this.textInputFormatters,
      this.textAlign = TextAlign.left,
      this.textInputAction = TextInputAction.next,
      this.suffixIcon})
      : super(key: key) {
    isPasswordField = true;
  }

  @override
  _EditTextFieldState createState() => _EditTextFieldState();
}

class _EditTextFieldState extends State<EditTextField> {
  bool isVisible = false;
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
  }

  TextInputType get keyboardType {
    if ((widget.controller.textInputType == TextInputType.number ||
            widget.controller.textInputType ==
                TextInputType.numberWithOptions(decimal: true)) &&
        Platform.isIOS) {
      return const TextInputType.numberWithOptions(decimal: true, signed: true);
    }
    return widget.controller.textInputType;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: FormField<String>(
        initialValue: widget.controller.text,
        validator: (value) {
          if (!widget.controller.required && widget.controller.text.isEmpty) {
            return null;
          }
          if ((widget.controller.required ||
                  widget.controller.text.isNotEmpty) &&
              widget.controller.validator != null) {
            return widget.controller.validator!(value);
          }
          return null;
        },
        builder: (FormFieldState state) {
          if (widget.controller.textEditingController.hasListeners) {
            widget.controller.textEditingController.removeListener(() {});
          }

          widget.controller.textEditingController.addListener(() {
            if (mounted) state.reset();
            if (mounted) state.didChange(widget.controller.text);
          });

          return TextField(
              key: widget.controller.fieldKey,
              readOnly: widget.readOnly ?? false,
              autocorrect: false,
              enableInteractiveSelection: widget.isPasswordField ? false : true,
              controller: widget.controller.textEditingController,
              contextMenuBuilder: (context, editableTextState) {
                return AdaptiveTextSelectionToolbar.editableText(
                    editableTextState: editableTextState);
              },
              obscureText: widget.isPasswordField && !isVisible ? true : false,
              textInputAction: widget.textInputAction,
              textAlign: widget.textAlign,
              style: widget.textStyle ??
                  _bodyTextStyle.copyWith(
                      color: !widget.enabled ? AppColors.enabledText : null),
              focusNode: widget.controller.focusNode,
              autofocus: widget.autoFocus,
              cursorColor: AppColors.greyColor,
              cursorWidth: 1.4,
              onChanged: (value) {
                if (mounted) state.reset();
                if (mounted) state.didChange(value);
                if (widget.onChanged != null) {
                  widget.onChanged!(value);
                }
              },
              onSubmitted: (value) {
                if (widget.onSubmitted != null) {
                  widget.onSubmitted!(value);
                }
              },
              enabled: widget.enabled,
              maxLength: widget.maxLetters ?? widget.controller.maxLength,
              maxLines: widget.isPasswordField
                  ? 1
                  : widget.maxLines ?? widget.controller.maxLines,
              minLines: widget.controller.minLines,
              inputFormatters: widget.textInputFormatters ??
                  (widget.isPasswordField ||
                          widget.controller.textInputType ==
                              TextInputType.emailAddress
                      ? [
                          FilteringTextInputFormatter.deny(RegExp('[\\ ]')),
                        ]
                      : widget.controller.inputFormatter),
              decoration: InputDecoration(
                fillColor: !widget.enabled ? AppColors.surface : Colors.white,
                filled: true,
                contentPadding: widget.padding ??
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                alignLabelWithHint: false,
                border: _outlineInputBorder,
                enabledBorder: widget.readOnly == true
                    ? _outlineInputDisabledBorder
                    : _outlineInputBorder,
                disabledBorder: _outlineInputBorder,
                focusedBorder: widget.readOnly == true
                    ? _outlineInputDisabledBorder
                    : _focusedInputBorder,
                focusedErrorBorder: _errorInputBorder,
                errorBorder: _errorInputBorder,
                errorStyle: _errorTextStyle,
                errorText: state.hasError
                    ? state.errorText
                    : widget.controller.overrideErrorText,
                errorMaxLines: 3,
                hintText: widget.placeholder,
                labelText: widget.label,
                labelStyle:
                    AppTextStyle.bodyMedium.copyWith(fontWeight: fontWeight400),
                hintStyle: _hintTextStyle,
                focusColor: AppColors.surface,
                suffixIconConstraints:
                    const BoxConstraints(minWidth: 15, maxHeight: 20),
                prefixIconConstraints:
                    const BoxConstraints(minWidth: 15, maxHeight: 20),
                prefix: widget.prefixText == null
                    ? null
                    : Text(
                        "${widget.prefixText} ",
                        style: _bodyTextStyle,
                      ),
                prefixIcon: widget.prefixIcon,
                suffixIcon: widget.isPasswordField
                    ? _buildPasswordEyeIcon()
                    : widget.suffixIcon,
                counterText: widget.counterText ?? "",
              ),
              keyboardType: widget.textInputType ?? keyboardType,
              textCapitalization: widget.textCapitalization ??
                  widget.controller.textCapitalization);
        },
      ),
    );
  }

  Widget _buildPasswordEyeIcon() {
    return IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          isVisible ? Icons.visibility : Icons.visibility_off,
          size: 20,
          color: AppColors.icon,
        ),
        onPressed: () {
          isVisible = !isVisible;
          setState(() {});
        });
  }

  void dispose() {
    super.dispose();
  }
}

InputBorder _outlineInputBorder = OutlineInputBorder(
  borderRadius: _borderRadius,
  borderSide: BorderSide(
      style: BorderStyle.solid, color: AppColors.greyColor, width: 1),
);

InputBorder _outlineInputDisabledBorder = OutlineInputBorder(
  borderRadius: _borderRadius,
  borderSide: BorderSide(
      style: BorderStyle.solid, color: AppColors.outlineGreyColor, width: 1),
);

InputBorder _focusedInputBorder = OutlineInputBorder(
  borderRadius: _borderRadius,
  borderSide: const BorderSide(
    style: BorderStyle.solid,
    color: AppColors.darkBlackColor,
    width: 1,
  ),
);

InputBorder _errorInputBorder = OutlineInputBorder(
  borderRadius: _borderRadius,
  borderSide: const BorderSide(
      style: BorderStyle.solid, color: AppColors.error, width: 1),
);
