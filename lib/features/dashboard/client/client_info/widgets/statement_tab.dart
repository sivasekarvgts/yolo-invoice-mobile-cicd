import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoloworks_invoice/app/common_widgets/hide_floating.dart';
import 'package:yoloworks_invoice/app/constants/app_sizes.dart';
import 'package:yoloworks_invoice/app/constants/app_ui_constants.dart';
import 'package:yoloworks_invoice/app/styles/text_styles.dart';
import 'package:yoloworks_invoice/core/extension/currency_extension.dart';
import 'package:yoloworks_invoice/core/extension/datetime_extension.dart';

import '../../../../../app/common_widgets/app_filter_widget.dart';
import '../../../../../app/common_widgets/floating_button.dart';
import '../../../../../app/common_widgets/tab_bar_widget.dart';
import '../../../../../app/styles/colors.dart';
import '../client_info_controller.dart';

class StatementTab extends ConsumerStatefulWidget {
  const StatementTab({super.key});

  @override
  ConsumerState createState() => _StatementTabState();
}

class _StatementTabState extends ConsumerState<StatementTab>
    with TickerProviderStateMixin {
  late TabController? analyticsTabController;

  @override
  void initState() {
    super.initState();
    analyticsTabController = TabController(length: 3, vsync: this);
    analyticsTabController?.addListener(() {
      final controller = ref.watch(clientInfoControllerProvider.notifier);
      controller.index = analyticsTabController?.index ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(clientInfoControllerProvider.notifier);
    final state = ref.watch(clientInfoControllerProvider);

    return NestedScrollView(
      controller: controller.scrollController,
      physics: ClampingScrollPhysics(),
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverList(
            delegate:
            SliverChildBuilderDelegate(childCount: 1, (context, index) {
              return Container(
                margin: EdgeInsets.fromLTRB(
                  11.h,
                  11.h,
                  11.h,
                  5.h,
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: AppUiConstants.salesCardItemDecoration,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Due Amount",
                              style: AppTextStyle.darkBlackFS12FW600,
                            ),
                            if(controller.transactionData?.transactionDetail?.isNotEmpty==true)
                              Text(
                              "LAST PAYMENT: ${(DateFormates.dayMonthYearsFormat
                                  .tryParse(
                                  controller.transactionData?.transactionDetail
                                      ?.last.issuedOn ?? "")
                                  .toTimeAgoLabel()) ?? "N/A"}",
                              style: AppTextStyle.greyFS10FW600,
                            ),
                          ],
                        ),
                        Text(
                          controller.transactionData?.balance
                              .toCurrencyFormatString() ??
                              "",
                          style: AppTextStyle.blackFS16FW600
                              .copyWith(color: AppColors.redColor),
                        )
                      ],
                    ),
                    gapH8,
                    Divider(
                      height: 1,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(spacing: 5,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Advance Amount",
                                style: AppTextStyle.greyFS12FW600,
                              ),
                              Text(
                                controller.transactionData?.advance
                                    .toCurrencyFormatString() ??
                                    "0",
                                style: AppTextStyle.darkBlackFS12FW600.copyWith(fontSize: 13.sp),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(8.h),
                          width: 1,
                          height: 40.h,
                          color: AppColors.dividerGreyColor,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Column(
                                spacing: 5,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Closing Balance",
                                    style: AppTextStyle.greyFS12FW600,
                                  ),
                                  Text(
                                    '${controller.transactionData
                                        ?.closingBalance
                                        .toCurrencyFormatString() ?? "0"}',
                                    style: AppTextStyle.darkBlackFS12FW600.copyWith(fontSize: 13.sp),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),Container(
                          margin: EdgeInsets.all(8.h),
                          width: 1,
                          height: 40.h,
                          color: AppColors.dividerGreyColor,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Pending Cheque",
                                    style: AppTextStyle.greyFS12FW600,
                                  ),
                                  Text(
                                    '${controller.transactionData
                                        ?.chequePendingAmount
                                        .toCurrencyFormatString() ?? "0"}',
                                    style: AppTextStyle.darkBlackFS12FW600.copyWith(fontSize: 13.sp),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }),
          ),
        ];
      },
      body: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
     floatingActionButton:    SafeArea(
          child: FloatingButton(
              label: "New ${controller.analyticsTabs[controller.index].title}",
              onTap: () {
                controller.showDialog();
              },
              visibilityOfFloating: true),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TabBarHeaderWidgetV2(
                    tabController: analyticsTabController,
                    tabs: controller.analyticsTabs,
                  ),
                  AppFilterWidget(
                    onTap: controller.showFilter,
                    count: controller.selectedDateRange != null ? 1 : null,
                  )
                ],
              ),
            ),
            Expanded(
              child: TabBarBodyWidget(
                tabController: analyticsTabController,
                tabs: controller.analyticsTabs,
                needScroll: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
