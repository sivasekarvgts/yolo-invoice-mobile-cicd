import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoloworks_invoice/app/common_widgets/sales_icon_card_widget.dart';
import 'package:yoloworks_invoice/app/constants/images.dart';
import 'package:yoloworks_invoice/app/styles/text_styles.dart';
import 'package:yoloworks_invoice/core/enums/icon_type.dart';
import 'package:yoloworks_invoice/core/extension/color_extension.dart';
import 'package:yoloworks_invoice/core/extension/currency_extension.dart';

import '../../../../../app/constants/app_sizes.dart';
import '../../../../../app/styles/colors.dart';
import '../client_info_controller.dart';

class AnalyticsTab extends ConsumerStatefulWidget {
  const AnalyticsTab({super.key});

  @override
  ConsumerState createState() => _AnalyticsTabState();
}

class _AnalyticsTabState extends ConsumerState<AnalyticsTab> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(clientInfoControllerProvider.notifier);
    final state = ref.watch(clientInfoControllerProvider);
    return Padding(
      padding: EdgeInsets.all(12.h),
      child: Column(
        spacing: 11.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Financial KPIs",
            style: AppTextStyle.blackFS16FW600,
          ),
          Row(
            children: [AnalyticsCard(), gapW10, AnalyticsCard()],
          ),
          Row(
            children: [AnalyticsCard(), gapW10, AnalyticsCard()],
          ),
          Divider(),
          Text(
            "Other Insights",
            style: AppTextStyle.blackFS16FW600,
          ),
          Row(
            children: [AnalyticsCard(), gapW10, AnalyticsCard()],
          ),
          Row(
            children: [AnalyticsCard(), gapW10, AnalyticsCard()],
          ),
        ],
      ),
    );
  }
}

class AnalyticsCard extends StatelessWidget {
  const AnalyticsCard({
    super.key,
    this.icon,
    this.iconType,
    this.flex,
    this.status,
    this.subTitle,
    this.title,
  });

  final int? flex;
  final String? icon;
  final IconType? iconType;
  final String? title;
  final String? subTitle;
  final String? status;
  final bool isUpward = true;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex ?? 1,
      child: Container(
        padding: EdgeInsets.all(11.h),
        color: AppColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SalesIconCardWidget(
                    radius: 5,
                    color2: IconType.customer.color2,
                    color1: IconType.customer.color1,
                    icon: Svgs.person),
                Text(
                  "↑ 8.2%",
                  style: AppTextStyle.darkGrassGreenF11W600,
                )
              ],
            ),
            gapH15,
            Text(
              "CUSTOMER LIFETIME VALUE",
              style: AppTextStyle.greyFS10FW600,
            ),
            gapH2,
            Text(
              12132.0.toCurrencyFormatString(),
              style: AppTextStyle.darkBlackFS16FW700,
            )
          ],
        ),
      ),
    );
  }
}
