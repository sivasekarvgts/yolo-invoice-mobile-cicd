import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:yoloworks_invoice/app/common_widgets/dash_line_widget.dart';
import 'package:yoloworks_invoice/app/common_widgets/network_image_loader.dart';
import 'package:yoloworks_invoice/app/common_widgets/shimmer_widget/shimmer_effect.dart';
import 'package:yoloworks_invoice/app/constants/app_sizes.dart';
import 'package:yoloworks_invoice/app/constants/images.dart';
import 'package:yoloworks_invoice/app/constants/strings.dart';
import 'package:yoloworks_invoice/app/styles/colors.dart';
import 'package:yoloworks_invoice/app/styles/dark_theme.dart';
import 'package:yoloworks_invoice/app/styles/text_styles.dart';
import 'package:yoloworks_invoice/core/extension/color_extension.dart';
import 'package:yoloworks_invoice/features/dashboard/models/sales_purchase_model.dart';
import 'package:yoloworks_invoice/features/dashboard/view/dashboard_controller.dart';
import 'package:yoloworks_invoice/features/dashboard/view/widgets/customizable_card_widget.dart';
import 'package:yoloworks_invoice/features/dashboard/view/widgets/customizable_links_page.dart';
import 'package:yoloworks_invoice/locator.dart';
import 'package:yoloworks_invoice/router.dart';

class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = ref.read(dashboardControllerProvider.notifier);
      controller.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(dashboardControllerProvider.notifier);
    final state = ref.watch(dashboardControllerProvider);

    return PopScope(
        canPop: true,
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 70,
              elevation: 0,
              shadowColor: AppColors.primary,
              backgroundColor: AppColors.primary,
              leading: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: CircleAvatar(
                  child: NetworkImageLoader(
                      image: controller.org?.logo ??
                          businessIndividualImages.randomBusinessImage),
                ),
              ),
              title: InkWell(
                onTap: () {
                  navigationService.pushNamed(Routes.manageOrganization);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.org?.name ?? "Unknown",
                      style: AppStrings.dashboardTitle.textStyle,
                      maxLines: AppStrings.dashboardTitle.maxLines,
                    ),
                    Row(
                      children: [
                        Text(
                          "GST: ${controller.org?.gstNum ?? "Un Registered"}",
                          style: AppStrings.dashboardSubTitle.textStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: InkWell(
                      onTap: () {
                        navigationService.pushNamed(Routes.manageOrganization);
                      },
                      child: SizedBox(
                        width: 20,
                        child: Icon(
                          CupertinoIcons.forward,
                          color: AppColors.white,
                        ),
                      )),
                ),
              ],
            ),
            body: EasyRefresh.builder(
              header: CupertinoHeader(),
              footer: CupertinoFooter(),
              triggerAxis: Axis.vertical,
              onRefresh: () async {
                return await controller.fetchReceivablesPayable();
              },
              childBuilder: (context, physics) => SingleChildScrollView(
                physics: physics,
                child: Column(
                  children: [
                    Container(
                      color: AppColors.primary,
                      child: Column(
                        children: [
                          gapW20,
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColors.containerColor,
                                  borderRadius: BorderRadius.circular(16.r)),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppStrings.receivables.text
                                              .toUpperCase(),
                                          style:
                                              AppStrings.receivables.textStyle,
                                        ),
                                        gapW5,
                                        Icon(
                                          CupertinoIcons.forward,
                                          color: AppColors.white,
                                          size: 12.h,
                                        )
                                      ],
                                    ),
                                    gapH5,
                                    if (state.isLoading)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 6.0),
                                        child: ShimmerWidget.text(
                                          height: 20.sp,
                                        ),
                                      )
                                    else
                                      Text(
                                        controller.receivableAmt,
                                        style: AppStrings.titleAmount.textStyle,
                                      ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12.h),
                                      child: DarkTheme.customDivider,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          AppStrings.payables.text
                                              .toUpperCase(),
                                          style: AppStrings.payables.textStyle,
                                        ),
                                        gapW5,
                                        Icon(
                                          CupertinoIcons.forward,
                                          color: AppColors.white,
                                          size: 12.h,
                                        )
                                      ],
                                    ),
                                    gapH5,
                                    if (state.isLoading)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 6.0),
                                        child: ShimmerWidget.text(
                                          height: 20.sp,
                                        ),
                                      )
                                    else
                                      Text(
                                        controller.payableAmt,
                                        style: AppStrings.titleAmount.textStyle,
                                      )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      color: AppColors.scaffoldBackground,
                      child: Column(
                        children: [
                          gapH20,
                          Row(
                            children: [
                              gapW24,
                              SvgPicture.asset(Svgs.quickLink),
                              gapW12,
                              Text(
                                AppStrings.quickLink.text,
                                style: AppStrings.quickLink.textStyle,
                              ),Spacer(),
                              InkWell(
                                  onTap: () async {
                                    await  dialogService.showBottomSheet(
                                        isDivider: false,
                                        showCloseIcon: false,
                                        dismissable: true,
                                        showActionBar: false,
                                        child:CustomizableLinksPage()
                                    );
                                    setState(() {});
                                  },
                                  child: SvgPicture.asset(Svgs.tune)),gapW20,
                            ],
                          ),
                          gapH20,
                          CustomizableCardWidget(),
                          gapH30,
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                      color: AppColors.boarderWhite)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .38,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SvgPicture.asset(
                                                Svgs.billTag,
                                                height: 16,
                                                width: 16,
                                              ),
                                              Text(
                                                AppStrings
                                                    .incomeAndExpense.text,
                                                style: AppStrings
                                                    .incomeAndExpense.textStyle,
                                              ),
                                            ],
                                          ),
                                          DashLineWidget()
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0, right: 12, bottom: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            controller.showFilters();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                    color:
                                                        AppColors.greyColor)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5.0,
                                                      vertical: 5),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    controller.selectedFilter
                                                            ?.text ??
                                                        "",
                                                    style: AppTextStyle
                                                        .labelSmall
                                                        .copyWith(
                                                            color: AppColors
                                                                .greyColor),
                                                  ),
                                                  gapW5,
                                                  Icon(
                                                    Icons
                                                        .calendar_month_outlined,
                                                    size: 15,
                                                    color: AppColors.greyColor,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            controller.cashAccruelChange();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 4.0,
                                                      vertical: 4.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      if (!controller
                                                          .isCashSelected)
                                                        controller
                                                            .cashAccruelChange();
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: controller
                                                                .isCashSelected
                                                            ? AppColors.primary
                                                                .withOpacity(
                                                                    0.2)
                                                            : Colors
                                                                .transparent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 4.0,
                                                                vertical: 3),
                                                        child: Text(
                                                          AppStrings.cash.text,
                                                          style: AppStrings
                                                              .cash.textStyle
                                                              .copyWith(
                                                            color: AppColors
                                                                .primary,
                                                            fontWeight: controller
                                                                    .isCashSelected
                                                                ? fontWeight700
                                                                : fontWeight600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(1.0),
                                                  child: Container(
                                                    height: 20,
                                                    color: AppColors.primary,
                                                    width: 1,
                                                  ),
                                                ),
                                                // "Accrual" Text
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 4.0,
                                                      vertical: 4.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      if (controller
                                                          .isCashSelected)
                                                        controller
                                                            .cashAccruelChange();
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: !controller
                                                                .isCashSelected
                                                            ? AppColors.primary
                                                                .withOpacityValue(
                                                                    0.2)
                                                            : Colors
                                                                .transparent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 4.0,
                                                                vertical: 3),
                                                        child: Text(
                                                          AppStrings
                                                              .accrual.text,
                                                          style: AppStrings
                                                              .accrual.textStyle
                                                              .copyWith(
                                                            color: AppColors
                                                                .primary,
                                                            fontWeight: !controller
                                                                    .isCashSelected
                                                                ? fontWeight700
                                                                : fontWeight600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  if (state.isLoading)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0,
                                          right: 20.0,
                                          bottom: 35,
                                          top: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          ShimmerWidget.circular(
                                            height: 150,
                                            width: 20,
                                            shapeBorder: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(0)),
                                          ),
                                          ShimmerWidget.circular(
                                            height: 100,
                                            width: 20,
                                            shapeBorder: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(0)),
                                          ),
                                          ShimmerWidget.circular(
                                            height: 50,
                                            width: 20,
                                            shapeBorder: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(0)),
                                          ),
                                          ShimmerWidget.circular(
                                            height: 150,
                                            width: 20,
                                            shapeBorder: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(0)),
                                          ),
                                          ShimmerWidget.circular(
                                            height: 130,
                                            width: 20,
                                            shapeBorder: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(0)),
                                          ),
                                          ShimmerWidget.circular(
                                            height: 100,
                                            width: 20,
                                            shapeBorder: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(0)),
                                          ),
                                          ShimmerWidget.circular(
                                            height: 50,
                                            width: 20,
                                            shapeBorder: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(0)),
                                          ),
                                          ShimmerWidget.circular(
                                            height: 150,
                                            width: 20,
                                            shapeBorder: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(0)),
                                          ),
                                          ShimmerWidget.circular(
                                            height: 130,
                                            width: 20,
                                            shapeBorder: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(0)),
                                          ),
                                        ],
                                      ),
                                    )
                                  else
                                    SizedBox(
                                      height: 200,
                                      child: SfCartesianChart(
                                        plotAreaBorderWidth: 0,
                                        primaryXAxis: CategoryAxis(
                                            // minorTicksPerInterval: 1,
                                            // minorGridLines:
                                            //     MinorGridLines(width: 0),
                                            // minorTickLines: MinorTickLines(
                                            //   size: 4,
                                            //   width: 1,
                                            //   color: AppColors.graphBaseLine,
                                            // ),
                                            tickPosition: TickPosition.outside,
                                            majorTickLines: MajorTickLines(
                                              size: 0,
                                            ),
                                            labelRotation: -50,
                                            labelStyle:
                                                AppStrings.graphLabel.textStyle,
                                            axisLine: AxisLine(
                                                color: AppColors.graphBaseLine,
                                                width: 1),
                                            majorGridLines:
                                                MajorGridLines(width: 0),
                                            borderWidth: 0),
                                        primaryYAxis: NumericAxis(
                                            autoScrollingMode:
                                                AutoScrollingMode.start,
                                            majorTickLines: MajorTickLines(
                                                width: 0, size: 0),
                                            axisLine: AxisLine(width: 0),
                                            labelStyle:
                                                AppStrings.graphLabel.textStyle,
                                            numberFormat:
                                                NumberFormat.compactCurrency(
                                              name: "INR",
                                              locale: 'en_IN',
                                              decimalDigits: 0,
                                              symbol: '',
                                            ),
                                            rangePadding:
                                                ChartRangePadding.round,
                                            borderWidth: 0,
                                            majorGridLines: MajorGridLines(
                                              width: .1,
                                            )),
                                        series: <CartesianSeries>[
                                          ColumnSeries<MonthlyDatum, String>(
                                            dataSource: controller.incomeData,
                                            xValueMapper:
                                                (MonthlyDatum data, _) =>
                                                    data.period,
                                            yValueMapper:
                                                (MonthlyDatum data, _) =>
                                                    data.amount,
                                            name: 'Total Income',
                                            color: AppColors.primary,
                                          ),
                                          ColumnSeries<MonthlyDatum, String>(
                                            dataSource: controller.expenseData,
                                            xValueMapper:
                                                (MonthlyDatum data, _) =>
                                                    data.period,
                                            yValueMapper:
                                                (MonthlyDatum data, _) =>
                                                    data.amount,
                                            name: 'Total Expense',
                                            color: AppColors.graphYellow,
                                          ),
                                        ],
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0, right: 12.0, bottom: 14),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  controller.totalIncome,
                                                  style: AppTextStyle.titleSmall
                                                      .copyWith(
                                                          fontWeight:
                                                              fontWeight600),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 5,
                                                      height: 10,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              AppColors.primary,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                    ),
                                                    gapWcustom(2),
                                                    Text(
                                                        AppStrings
                                                            .totalIncome.text,
                                                        style: AppStrings
                                                            .totalIncome
                                                            .textStyle)
                                                  ],
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                              child: Container(
                                                color: AppColors.boarderWhite,
                                                width: .5,
                                                height: 20,
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  controller.totalExpense,
                                                  style: AppTextStyle.titleSmall
                                                      .copyWith(
                                                          fontWeight:
                                                              fontWeight600),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 5,
                                                      height: 10,
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .graphYellow,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                    ),
                                                    gapWcustom(2),
                                                    Text(
                                                        AppStrings
                                                            .totalExpense.text,
                                                        style: AppStrings
                                                            .totalExpense
                                                            .textStyle)
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          gapH64,
                          gapH64,
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            )));
  }
}
