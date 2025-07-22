import 'package:flutter/material.dart';
import 'package:yoloworks_invoice/core/extension/string_extension.dart';

import '../../../../app/constants/app_sizes.dart';
import '../../../../app/styles/text_styles.dart';

// ignore: must_be_immutable
class ProductDetailsWidget extends StatelessWidget {
  String name;
  String? skuCode;
  String? hsnCode;
  bool isSKU;
  bool isHSN;
  bool isShowNameOnly;
  String? gstValue;
  ProductDetailsWidget(
      {super.key,
        this.isSKU = true,
        this.isShowNameOnly = true,
        this.isHSN = true,
        required this.name,
        this.skuCode,
        this.hsnCode,
        this.gstValue});

  @override
  Widget build(BuildContext context) {
    if (isShowNameOnly) {
      return Text(
        name.capitalizeFirst.toString(),
        style: AppTextStyle.darkBlackFS14FW600,
        overflow: TextOverflow.ellipsis,
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.capitalizeFirst.toString(),
                  style: AppTextStyle.darkBlackFS14FW600,
                ),
                gapH4,
                Row(
                  children: [
                    if (isSKU)
                      Text(
                        'SKU - ${skuCode ?? "N/A"}',
                        style: AppTextStyle.greyFS12FW500,
                      ),
                    if (isSKU && isHSN) Text(" | "),
                    if (isHSN)
                      Text(
                        'HSN - ${hsnCode}',
                        style: AppTextStyle.greyFS12FW500,
                      ),
                  ],
                )
              ],
            ))
      ],
    );
  }
}
