import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoloworks_invoice/core/extension/currency_extension.dart';

import '../../../../app/constants/app_sizes.dart';
import '../../../../app/styles/text_styles.dart';
import '../../models/bill_preview_model.dart';
import '../bill_preview_ctrl.dart';

class BillSummaryTab extends ConsumerWidget {
  const BillSummaryTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(billPreviewCtrlProvider.notifier);
    ref.watch(billPreviewCtrlProvider);

    final billPreviewModel = controller.billPreviewModel;

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 3),
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: [
        gapH5,
        _BillSummaryWidget(
          isGstTaxHide: controller.isGstTaxHide,
          onOpenTax: controller.onOpenTax,
          gstBreakDownList: billPreviewModel?.breakdown ?? [],
          total: billPreviewModel?.total.toCurrencyFormatString() ?? '',
          taxAmt: billPreviewModel?.taxAmount.toCurrencyFormatString() ?? '',
          summaryList: controller.summaryList,
          dueAmount:
              billPreviewModel?.balanceDue?.toCurrencyFormatString() ?? "-",
        ),
        _NotesWidget(
          notes: billPreviewModel?.notes,
          terms: billPreviewModel?.terms,
        ),
      ],
    );
  }
}

class _BillSummaryWidget extends StatelessWidget {
  const _BillSummaryWidget(
      {required this.isGstTaxHide,
      required this.onOpenTax,
      required this.total,
      required this.gstBreakDownList,
      required this.dueAmount,
      required this.summaryList,
      required this.taxAmt});

  final String total;
  final String taxAmt;
  final String dueAmount;
  final bool isGstTaxHide;
  final void Function() onOpenTax;
  final List summaryList;
  final List<Breakdown> gstBreakDownList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: summaryList.length,
              physics: const ClampingScrollPhysics(),
              separatorBuilder: (context, index) => Divider(height: 10.h),
              itemBuilder: (context, i) {
                final item = summaryList[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item['title'].toString(),
                          style: AppTextStyle.darkBlackFS14FW500),
                      Text(item['price'].toString(),
                          style: AppTextStyle.darkBlackFS14FW500),
                    ],
                  ),
                );
              }),
          Divider(height: 10.h),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: onOpenTax,
                  child: Row(
                    children: [
                      Text('Total Tax', style: AppTextStyle.darkBlackFS14FW500),
                      Icon(
                          isGstTaxHide
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 20),
                    ],
                  ),
                ),
                Text(taxAmt, style: AppTextStyle.darkBlackFS14FW500),
              ],
            ),
          ),
          if (isGstTaxHide)
            ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: gstBreakDownList.length,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, i) {
                  final item = gstBreakDownList[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${item.taxType} (${item.taxValue})',
                            style: AppTextStyle.darkBlackFS14FW500),
                        Text(item.taxAmount.toCurrencyFormatString() ?? '',
                            style: AppTextStyle.darkBlackFS14FW500),
                      ],
                    ),
                  );
                }),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: AppTextStyle.darkBlackFS16FW700),
              Text(total, style: AppTextStyle.darkBlackFS16FW700),
            ],
          ),
          gapH4,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Due Amount', style: AppTextStyle.darkBlackFS12FW500),
              Text(dueAmount, style: AppTextStyle.darkBlackFS12FW500),
            ],
          ),
        ],
      ),
    );
  }
}

class _NotesWidget extends StatelessWidget {
  const _NotesWidget({required this.notes, required this.terms});

  final String? notes;
  final String? terms;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          gapH4,
          Text(
            'Notes',
            style: AppTextStyle.darkBlackFS12FW500,
          ),
          gapH5,
          Text(
            notes ?? '-',
            style: AppTextStyle.darkBlackFS14FW500,
          ),
          gapH15,
          Text(
            'Terms & Condition',
            style: AppTextStyle.darkBlackFS12FW500,
          ),
          gapH4,
          Text(
            terms ?? '',
            style: AppTextStyle.darkBlackFS14FW500,
          ),
          gapH25,
        ],
      ),
    );
  }
}
