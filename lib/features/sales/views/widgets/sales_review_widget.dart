import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vgts_plugin/form/utils/input_formatter.dart';

import '../../../../app/common_widgets/empty_widget/error_text_widget.dart';
import '../../../../app/constants/app_sizes.dart';
import '../../../../app/styles/colors.dart';
import '../../../../app/styles/text_styles.dart';
import '../../models/item_model/sales_line_item.dart';

class SalesReviewWidget extends StatelessWidget {
  const SalesReviewWidget({
    super.key,
    required this.selectedItemList,
    required this.onDeleteItem,
    required this.onViewItem,
  });

  final List<SalesLineItem> selectedItemList;
  final void Function(int index) onViewItem;
  final void Function(int index) onDeleteItem;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(bottom: 12.h, top: 4.h),
      itemBuilder: (_, i) {
        final salesItem = selectedItemList[i];
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: InkWell(
            onTap: () => onViewItem(i),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${salesItem.itemName}',
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.darkBlackFS12FW600,
                          ),
                          if (salesItem.hsnCode != null ||
                              salesItem.skuCode != null)
                            gapH3,
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                if (salesItem.hsnCode != null)
                                  Text(
                                    'HSN -${salesItem.hsnCode}',
                                    style: AppTextStyle.darkBlackFS10FW500,
                                  ),
                                if (salesItem.hsnCode != null &&
                                    salesItem.skuCode != null)
                                  const VerticalDivider(),
                                if (salesItem.skuCode != null)
                                  Text(
                                    '${salesItem.skuCode}',
                                    style: AppTextStyle.darkBlackFS10FW500,
                                  ),
                              ],
                            ),
                          ),
                          gapH4,
                          RichText(
                            text: TextSpan(
                              text:
                                  '${salesItem.qtyFormattedValue} ${salesItem.unitName?.toUpperCase()}',
                              style: AppTextStyle.darkBlackFS12FW500,
                              children: [
                                TextSpan(
                                  text: ' x ',
                                  style: AppTextStyle.darkBlackFS11FW500,
                                ),
                                TextSpan(
                                  text: '${salesItem.formattedPrice}',
                                  style: AppTextStyle.darkBlackFS12FW500,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: Row(
                        children: [
                          Text(
                            '${salesItem.formattedSubTotal}',
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.darkBlackFS12FW600,
                          ),
                          gapW3,
                          InkWell(
                            onTap: () => onDeleteItem(i),
                            child: Icon(
                              Icons.clear,
                              color: AppColors.redColor,
                              size: 18,
                            ),
                          ),
                          gapW3,
                        ],
                      ),
                    ),
                  ],
                ),
                if (salesItem.errorMsg != null)
                  Row(
                    children: [
                      ErrorTextWidget(errorText: salesItem.errorMsg),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (_, i) => const Divider(),
      itemCount: selectedItemList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}

class AfterTaxAmount extends StatelessWidget {
  const AfterTaxAmount({super.key, this.value, this.onChanged});
  final TextEditingController? value;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Color(0xFFF0EFF2),
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: CupertinoTextField(
                keyboardType: TextInputType.number,
                controller: value,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey,
                    )),
                maxLength: 10,
                inputFormatters: [AmountInputFormatter(isSymbol: false)],
                onChanged: onChanged,
                style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.black,
                ),
                placeholder: "Add After Tax Disc Amount")),
      ),
    );
  }
}
