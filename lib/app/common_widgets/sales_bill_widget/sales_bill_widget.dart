import 'package:flutter/material.dart';
import 'package:vgts_plugin/form/utils/input_formatter.dart';

import '../../styles/colors.dart';
import '../../styles/text_styles.dart';
import '../app_text_field_widgets/app_text_field_widget.dart';

class SalesBillWidget extends StatelessWidget {
  const SalesBillWidget({
    super.key,
    this.ctrl,
    this.subTitle,
    required this.title,
    this.readOnly = false,
    this.isEnabled = true,
    this.isPercent = false,
    this.price,
    this.focusNode,
    this.onChanged,
    this.onRemoveOverlay,
    this.prefixIcon,
  });

  final String title;
  final String? subTitle;
  final bool readOnly;
  final bool isPercent;
  final bool isEnabled;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final TextEditingController? ctrl;
  final double? price;
  final void Function()? onRemoveOverlay;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyle.darkBlackFS13FW500,
                ),
                if (subTitle != null) SizedBox(height: 4),
                if (subTitle != null)
                  Text(
                    subTitle!,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.vampireGreyFS12FW600,
                  )
              ],
            ),
          ),
          Expanded(
            child: AppTextFieldWidget(
                hintText: '₹0.00',
                inputFormatter: !isPercent
                    ? [
                        AmountInputFormatter(
                            isSymbol: false, maxDigits: 8, price: price)
                      ]
                    : [
                        PercentageNumbersFormatter(
                            isSymbol: false, price: price)
                      ],
                prefixIcon: prefixIcon,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                style: AppTextStyle.darkBlackFS12FW500,
                hintStyle: AppTextStyle.greyFS12FW500,
                textAlign: TextAlign.end,
                borderRadius: 8,
                constraints: BoxConstraints(maxHeight: 30),
                inputBorder: TextFieldBorder(
                    borderColor: !isEnabled || readOnly
                        ? AppColors.greyColor500
                        : AppColors.darkBlackColor,
                    borderRadius: 8),
                fillColor: AppColors.greyColor100,
                ctrl: ctrl,
                filled: isEnabled,
                isEnabled: isEnabled,
                readOnly: readOnly,
                focusNode: focusNode,
                onChanged: onChanged,
                onTap: onRemoveOverlay,
                keyboardTextType: TextInputType.number),
          ),
        ],
      ),
    );
  }
}
