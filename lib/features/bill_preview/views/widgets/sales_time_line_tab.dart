import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoloworks_invoice/app/styles/colors.dart';
import 'package:yoloworks_invoice/core/extension/datetime_extension.dart';

import '../../../../app/styles/text_styles.dart';
import '../../models/bill_transaction_statement_list_model.dart';
import '../bill_preview_ctrl.dart';

class SalesTimeLineTab extends ConsumerWidget {
  const SalesTimeLineTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(billPreviewCtrlProvider.notifier);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TimelinePlus(
        items: controller.timelineList,
      ),
    );
  }
}

class TimelinePlus extends StatelessWidget {
  final List<BillTransactionStatementListModel>? items;
  final Color dotColor;
  final Color lineColor;
  final double dotRadius;
  final double lineWidth;

  const TimelinePlus({
    super.key,
    required this.items,
    this.dotColor = AppColors.primary,
    this.lineColor = AppColors.greyColor300,
    this.dotRadius = 6.0,
    this.lineWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    if (items?.isNotEmpty == false)
      return Center(
        child: Text(
          "No Data",
          style: AppTextStyle.darkBlackFS12FW500,
        ),
      );
    return ListView.builder(
      itemCount: items?.length ?? 0,
      itemBuilder: (context, index) {
        final item = items?[index];
        final isLast = index == items!.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline dot and line
            SizedBox(
              width: 20,
              child: Column(
                children: [
                  Container(
                    width: lineWidth,
                    height: 10, // Adjust height based on your needs
                    color: index == 0 ? null : lineColor,
                  ),
                  Container(
                    width: dotRadius * 2,
                    height: dotRadius * 2,
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (!isLast)
                    Container(
                      width: lineWidth,
                      height: 40.h, // Adjust height based on your needs
                      color: lineColor,
                    ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item?.description ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item?.date.toFormattedDateAndTime() ?? "",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
