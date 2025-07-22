import 'package:flutter/material.dart';
import 'package:yoloworks_invoice/app/styles/text_styles.dart';

import '../styles/colors.dart';
import 'app_text_field_widgets/app_text_field_widget.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget(
      {super.key,
      this.showSuffixIcon = true,
      this.showCancelButton = true,
      this.onClear,
      this.onCancel,
      this.focusNode,
      this.textCtrl,
      this.constraints,
      this.hintText,
      this.onEditingComplete,
      this.onChanged});
  final Function()? onClear;
  final Function()? onCancel;
  final Function()? onEditingComplete;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final String? hintText;
  final TextEditingController? textCtrl;
  final bool showSuffixIcon;
  final bool showCancelButton;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      curve: Curves.bounceInOut,
      child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 6, bottom: 5),
          child: Row(
            children: [
              Expanded(
                child: AppTextFieldWidget(
                    autoFocus: true,
                    focusNode: focusNode,
                    hintStyle: AppTextStyle.titleSmall,
                    ctrl: textCtrl,
                    style: AppTextStyle.titleMedium,
                    hintText: hintText,
                    borderRadius: 8,
                    constraints:constraints ,
                    maxLines: 1,
                    onEditingComplete: onEditingComplete,
                    onChanged: onChanged,
                    suffixIcon: showSuffixIcon
                        ? InkWell(
                            onTap: onClear,
                            child: const Icon(Icons.close,
                                color: AppColors.greyColor),
                          )
                        : null,
                    prefixIcon:
                        const Icon(Icons.search, color: AppColors.greyColor)),
              ),
              if (showCancelButton)
                TextButton(
                    onPressed: onCancel,
                    child: Text('Cancel',
                        style: AppTextStyle.titleSmall
                            .copyWith(color: AppColors.greyColor)))
            ],
          )),
    );
  }
}
