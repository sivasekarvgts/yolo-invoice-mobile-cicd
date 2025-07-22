import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/common_widgets/button.dart';
import '../../../../app/common_widgets/shimmer_widget/shimmer_effect.dart';

import '../../../../app/constants/app_sizes.dart';

import '../../../../app/styles/colors.dart';
import '../../../../app/styles/text_styles.dart';

import '../../models/master_model/gst_tax_model.dart';
import '../../models/master_model/price_list_model.dart';

class PriceItemCountWidget extends StatelessWidget {
  const PriceItemCountWidget({
    super.key,
    this.selectedItemCount,
    this.isLoading = false,
    this.isPriceListEmpty = false,
    this.selectedTaxModel,
    required this.onShowItems,
    required this.isSalesInvoice,
    this.selectedPriceList,
    this.onViewPriceList,
    this.onRemovePriceList,
    required this.openTaxBottomSheet,
    required this.isItemListDisabled,
  });

  final bool isLoading;
  final bool isSalesInvoice;
  final bool isItemListDisabled;
  final int? selectedItemCount;
  final bool isPriceListEmpty;
  final PriceListModel? selectedPriceList;
  final GstTaxModel? selectedTaxModel;
  final void Function()? onViewPriceList;
  final void Function()? onRemovePriceList;
  final void Function() onShowItems;
  final void Function() openTaxBottomSheet;

  @override
  Widget build(BuildContext context) {
    final isItemMoreThanOne = selectedItemCount! > 1;
    final priceListAdded = selectedPriceList?.name != null;
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            InkWell(
              onTap: onShowItems,
              child: Row(
                children: [
                  Text(
                      '${isItemMoreThanOne ? '$selectedItemCount Items' : selectedItemCount == 0 ? 'Item' : '$selectedItemCount Item'}',
                      style: AppTextStyle.blackFS16FW600),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Icon(
                      !isItemListDisabled
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 18,
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                if (onViewPriceList != null && !isPriceListEmpty)
                  AppButton.outline(
                    selectedPriceList?.name ?? 'Price List',
                    key: Key('price-list'),
                    onPressed: onViewPriceList!,
                    height: 28.h,
                    fullSize: false,
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    textStyle: AppTextStyle.darkBlackFS12FW400,
                    borderColor: AppColors.greyColor300,
                    borderRadius: BorderRadius.circular(11),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: InkWell(
                        onTap: priceListAdded ? onRemovePriceList : null,
                        child: Icon(priceListAdded ? Icons.close : Icons.add,
                            color: AppColors.fuscousGreyColor, size: 16),
                      ),
                    ),
                  ),
                gapW8,
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: openTaxBottomSheet,
                    child: Container(
                      height: 30.h,
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(color: AppColors.greyColor300),
                          borderRadius: BorderRadius.circular(11)),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        children: [
                          Text(
                            selectedTaxModel?.title ?? 'Excluding Tax',
                            style: AppTextStyle.darkBlackFS12FW400,
                          ),
                          gapW4,
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 18,
                            color: AppColors.fuscousGreyColor,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                gapW4,
              ],
            ),
          ]),
          gapH5,
        ],
      ),
    );
  }
}

class PriceItemLoadingWidget extends StatelessWidget {
  const PriceItemLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ShimmerWidget.text(height: 15, width: 100),
        Row(children: [
          ShimmerWidget.circular(
            height: 35,
            width: 100,
            shapeBorder:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          gapW10,
          ShimmerWidget.circular(
            height: 35,
            width: 100,
            shapeBorder:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          )
        ]),
      ],
    );
  }
}
