import 'package:flutter/material.dart';
import 'package:yoloworks_invoice/app/common_widgets/shimmer_widget/shimmer_effect.dart';
import 'package:yoloworks_invoice/app/constants/app_sizes.dart';
import 'package:yoloworks_invoice/app/styles/colors.dart';
import 'package:yoloworks_invoice/locator.dart';

import '../../../../app/common_widgets/button.dart';

class SalesBottomWidget extends StatelessWidget {
  const SalesBottomWidget(
      {super.key,
      this.isShowDropDown = true,
      this.isLoading = false,
      required this.saveText,
      required this.routePrefixTxt,
      required this.onSave,
      required this.duePeroid,
      required this.onViewBill});
  final Function onSave;
  final Function onViewBill;
  final bool isShowDropDown;
  final bool isLoading;
  final String duePeroid;
  final String saveText;
  final String routePrefixTxt;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16,8,16,16),
            child: isLoading
                ? _BottomLoading()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        // Flexible(
                        //   child: Material(
                        //     color: Colors.white,
                        //     child: InkWell(
                        //       onTap: () => onViewBill(),
                        //       child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Text(routePrefixTxt,
                        //               style: AppTextStyle.darkBlackFS16FW600),
                        //           const SizedBox(height: 2),
                        //           Row(
                        //             children: [
                        //               Text(duePeroid,
                        //                   style:
                        //                       AppTextStyle.darkBlackFS12FW500),
                        //               const SizedBox(width: 8),
                        //               if (isShowDropDown)
                        //                 const Icon(Icons.keyboard_arrow_down,
                        //                     size: 18)
                        //             ],
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Expanded(
                            child: AppButton(
                          'Back',
                          height: 38,
                          color: AppColors.redColor,
                          borderColor: AppColors.redColor,
                          key: Key('cancel_$saveText'),
                          onPressed: () => onSave(),
                          padding: const EdgeInsets.all(5),
                          borderRadius: BorderRadius.circular(12),
                        )
                        ),gapW12,
                       Expanded(
                            child: AppButton(
                          'Create $saveText',
                          height: 38,
                          key: Key('create_$saveText'),
                          onPressed: () => navigationService.pop(),
                          padding: const EdgeInsets.all(5),
                          borderRadius: BorderRadius.circular(12),
                        )
                        )
                      ]),
          ),
        ],
      ),
    );
  }
}

class _BottomLoading extends StatelessWidget {
  const _BottomLoading();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerWidget.text(
              height: 15,
              width: 100,
            ),
            gapH5,
            ShimmerWidget.text(
              height: 10,
              width: 100,
            ),
          ],
        ),
        ShimmerWidget.rectangular(height: 45, width: 150)
      ],
    );
  }
}
