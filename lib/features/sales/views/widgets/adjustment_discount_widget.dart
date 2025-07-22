import 'package:flutter/material.dart';
import 'package:yoloworks_invoice/app/constants/app_sizes.dart';

import '../../../../app/styles/colors.dart';
import '../../../../app/styles/text_styles.dart';
import '../../models/master_model/gst_tax_model.dart';
import '../../models/master_model/tax_model.dart';

class AdjustmentDiscountWidget extends StatelessWidget {
  const AdjustmentDiscountWidget(
      {super.key,
      this.isDiscount = false,
      this.isSalesInvoice = false,
      this.adjustmentIndex,
      this.discountAmtIndex,
      required this.adjustmentDiscountModel,
      required this.onTap});

  final int? adjustmentIndex;
  final int? discountAmtIndex;
  final bool isDiscount;
  final bool isSalesInvoice;
  final Function(int value) onTap;
  final List<AdjustmentDiscountModel> adjustmentDiscountModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: adjustmentDiscountModel.length,
            separatorBuilder: (_, i) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final item = adjustmentDiscountModel[i];
              return InkWell(
                onTap: () => onTap(item.id),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(item.iconData, size: 15),
                          const SizedBox(width: 10),
                          Text(item.title,
                              style: AppTextStyle.darkBlackFS16FW500)
                        ],
                      ),
                      if (isDiscount
                          ? item.id == discountAmtIndex
                          : item.id == adjustmentIndex)
                        const Icon(Icons.radio_button_checked_outlined,
                            size: 20, color: AppColors.blueColor)
                      else
                        const Icon(Icons.radio_button_off_outlined, size: 20)
                    ],
                  ),
                ),
              );
            }),
      ],
    );
  }
}

class TdsTcsBottomSheet extends StatelessWidget {
  const TdsTcsBottomSheet(
      {super.key,
      this.selectedTdsTcsModel,
      required this.tdsTcsModel,
      required this.onTap});
  final List<TdsTcsModel> tdsTcsModel;
  final TdsTcsModel? selectedTdsTcsModel;
  final void Function(TdsTcsModel tdsTcsModel) onTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: tdsTcsModel.length,
            separatorBuilder: (_, i) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final item = tdsTcsModel[i];
              return InkWell(
                onTap: () => onTap(item),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.title, style: AppTextStyle.darkBlackFS16FW500),
                      if (item.id == selectedTdsTcsModel?.id)
                        const Icon(Icons.radio_button_checked_outlined,
                            size: 20, color: AppColors.blueColor)
                      else
                        const Icon(Icons.radio_button_off_outlined, size: 20)
                    ],
                  ),
                ),
              );
            }),
      ],
    );
  }
}

class TdsTcsValueBottomSheet extends StatelessWidget {
  const TdsTcsValueBottomSheet({
    super.key,
    required this.onTap,
    required this.onAddTdsTcs,
    required this.tdsTcsList,
    required this.tdsTcsModel,
    required this.selectedTdsTcsModel,
  });
  final TaxModel? tdsTcsModel;
  final TdsTcsModel selectedTdsTcsModel;
  final List<TaxModel> tdsTcsList;
  final void Function() onAddTdsTcs;
  final void Function(TaxModel tdsTcsModel) onTap;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: tdsTcsList.length,
                separatorBuilder: (_, i) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final item = tdsTcsList[i];
                  return Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () => onTap(item),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(item.name ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.darkBlackFS16FW500),
                            ),
                            if (item.id == tdsTcsModel?.id)
                              const Icon(Icons.radio_button_checked_outlined,
                                  size: 20, color: AppColors.blueColor)
                            else
                              const Icon(Icons.radio_button_off_outlined,
                                  size: 20)
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Material(
              color: Colors.white,
              child: InkWell(
                onTap: () => onAddTdsTcs(),
                child: Row(
                  children: [
                    Icon(Icons.add, color: AppColors.blueColor, size: 17),
                    gapW4,
                    Text('ADD ${selectedTdsTcsModel.title}',
                        style: AppTextStyle.blueFS14FW500),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
