import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoloworks_invoice/app/common_widgets/sales_icon_card_widget.dart';
import 'package:yoloworks_invoice/app/constants/app_sizes.dart';
import 'package:yoloworks_invoice/app/constants/app_ui_constants.dart';
import 'package:yoloworks_invoice/app/styles/colors.dart';
import 'package:yoloworks_invoice/app/styles/text_styles.dart';
import 'package:yoloworks_invoice/core/enums/icon_type.dart';
import 'package:yoloworks_invoice/core/extension/color_extension.dart';
import 'package:yoloworks_invoice/core/extension/currency_extension.dart';
import 'package:yoloworks_invoice/core/extension/datetime_extension.dart';

import '../../../../app/common_widgets/tab_bar_widget.dart';
import '../../../../app/constants/images.dart';
import '../../../sales/views/widgets/status_widget.dart';
import '../bill_preview_ctrl.dart';

class SalesTransactionTab extends ConsumerStatefulWidget {
  const SalesTransactionTab({super.key, required this.noOfTabs});

  final int noOfTabs;

  @override
  ConsumerState createState() => _SalesTransactionTabState();
}

class _SalesTransactionTabState extends ConsumerState<SalesTransactionTab>
    with SingleTickerProviderStateMixin {
  late TabController transactionTabController;

  @override
  void initState() {
    super.initState();
    transactionTabController =
        TabController(length: widget.noOfTabs, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(billPreviewCtrlProvider.notifier);
    ref.watch(billPreviewCtrlProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TabBarHeaderWidgetV2(
              tabController: transactionTabController,
              tabs: controller.transactionTabs,
              color: AppColors.greyColor100,
            ),
          ),
        ),
        Expanded(
          child: TabBarBodyWidget(
            tabController: transactionTabController,
            tabs: controller.transactionTabs,
            needScroll: false,
          ),
        ),
      ],
    );
  }
}

class SalesPaymentListTab extends ConsumerStatefulWidget {
  const SalesPaymentListTab({super.key});

  @override
  ConsumerState createState() => _SalesPaymentListTabState();
}

class _SalesPaymentListTabState extends ConsumerState<SalesPaymentListTab> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(billPreviewCtrlProvider.notifier);
    ref.watch(billPreviewCtrlProvider);
    final paymentList = controller.transactionList?.payments ?? [];
    if (paymentList.isEmpty)
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            "No Data",
            style: AppTextStyle.darkBlackFS12FW500,
          ),
        ),
      );
    return ListView.separated(
      shrinkWrap: true,
      itemCount: paymentList.length,
      separatorBuilder: (context, index) => gapH4,
      itemBuilder: (context, index) {
        final payment = paymentList[index];
        return TransactionCardWidget(
          margin: EdgeInsets.symmetric(horizontal: 12.w),
          onTapIcon: () {
            controller.deletePaymentPopup(payment);
          },
          icon: Svgs.receipt,
          iconType: IconType.payIn,
          needDelete: true,
          title: payment.paymentNumber,
          status: payment.paymentModeName,
          subTitle: payment.date.toFormattedYearMonthDate(),
          trailingAmount: payment.amount.toCurrencyFormatString(),
        );
      },
    );
  }
}

class SalesCreditsListTab extends ConsumerStatefulWidget {
  const SalesCreditsListTab({super.key});

  @override
  ConsumerState createState() => _SalesCreditsListTabState();
}

class _SalesCreditsListTabState extends ConsumerState<SalesCreditsListTab> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(billPreviewCtrlProvider.notifier);
    ref.watch(billPreviewCtrlProvider);

    final creditList = controller.transactionList?.credits ?? [];
    if (creditList.isEmpty)
      return Center(
        child: Text(
          "No Data",
          style: AppTextStyle.darkBlackFS12FW500,
        ),
      );
    return ListView.separated(
      shrinkWrap: true,
      itemCount: creditList.length,
      separatorBuilder: (context, index) => gapH4,
      itemBuilder: (context, index) {
        final credit = creditList[index];
        return TransactionCardWidget(
          margin: EdgeInsets.symmetric(horizontal: 12.w),
          onTapIcon: () {
            controller.deleteCreditPopup(credit);
          },
          icon: Svgs.paymentSent,
          iconType: IconType.customer,
          needDelete: true,
          title: credit.creditnoteNumber,
          subTitle: credit.date.toFormattedYearMonthDate(),
          trailingAmount: credit.amount.toCurrencyFormatString(),
        );
      },
    );
  }
}

enum AmountType { credit, debit, none }

class TransactionCardWidget extends StatelessWidget {
  const TransactionCardWidget(
      {super.key,
      this.onTapIcon,
      this.amountType = AmountType.none,
      this.status,
      this.title,
      this.margin,
      required this.icon,
      required this.iconType,
      this.isInOutIcon = false,
      this.needDelete = false,
      this.statusColor,
      this.subTitle,
      this.subTrailing,
      this.onTap,
      this.trailingAmount});

  final String? title;
  final String? subTitle;
  final String? status;
  final String? trailingAmount;
  final String? subTrailing;
  final Color? statusColor;
  final AmountType amountType;
  final String icon;
  final IconType iconType;
  final bool needDelete;
  final bool isInOutIcon;
  final EdgeInsets? margin;
  final void Function()? onTapIcon;
  final void Function()? onTap;

  String? get trailing => switch (amountType) {
        AmountType.credit => "+${trailingAmount ?? 0}",
        AmountType.debit => "-${trailingAmount ?? 0}",
        _ => trailingAmount
      };

  Color? get color => switch (amountType) {
        AmountType.credit => AppColors.greenColor,
        AmountType.debit => AppColors.redColor,
        _ => null
      };

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: margin,
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        decoration: AppUiConstants.salesCardItemDecoration,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // if(isInOutIcon&&amountType==AmountType.credit)  SizedBox(width:40.h,child: Icon(CupertinoIcons.arrow_2_circlepath,color: AppColors.greyColor,)),
            // if(isInOutIcon&&amountType==AmountType.debit)   SizedBox(width:40.h,child: Icon(CupertinoIcons.arrow_2_circlepath,color: AppColors.greyColor,)),
         // if(!isInOutIcon)
           SalesIconCardWidget(
                size: 40.h,
                radius: 6.r,
                icon: icon,
                color2: iconType.color2,
                color1: iconType.color1),
            gapW8,
            Column(
              spacing: needDelete ? 2.h : 4.h,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "#" + (title ?? "N/A"),
                      style: AppTextStyle.darkBlackFS14FW500,
                    ),
                    if (needDelete)
                      StatusWidget(
                        margin: EdgeInsets.only(left: 8.w),
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 1.h),
                        status: status ?? "",
                        color: statusColor ?? AppColors.lightGreenColor,
                        textStyle: AppTextStyle.darkBlackFS10FW700,
                      ),
                  ],
                ),
                Text(
                  subTitle ?? "",
                  style: AppTextStyle.greyFS12FW500,
                ),
              ],
            ),
            Spacer(),
            Column(
              spacing: 1.h,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (status != null && !needDelete)
                  StatusWidget(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 1.h),
                    status: status ?? "",
                    color: statusColor ?? AppColors.lightGreenColor,
                    textStyle:
                        AppTextStyle.darkBlackFS10FW600.copyWith(fontSize: 9.sp),
                  ),
                if (needDelete)
                  Material(
                    child: InkWell(
                        onTap: onTapIcon,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(8.w, 5.h, 0.w, 6.w),
                          child: Icon(
                            CupertinoIcons.delete,
                            color: AppColors.redColor,
                            size: 12.h,
                          ),
                        )),
                  ),
                if (subTrailing == null) gapH5,
                Text(
                  trailing ?? "",
                  style: AppTextStyle.darkBlackFS14FW500.copyWith(color: color),
                ),
                if (subTrailing != null)
                  Text(
                    subTrailing ?? "",
                    style: AppTextStyle.greyFS12FW500,
                  ),
              ],
            )

            // Expanded(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Row(
            //             children: [

            //               gapW8,

            //             ],
            //           ),

            //         ],
            //       ),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [

            //         ],
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
