import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yoloworks_invoice/app/common_widgets/app_text_field_widgets/sales_text_field_form_widget.dart';
import 'package:yoloworks_invoice/app/constants/images.dart';
import 'package:yoloworks_invoice/app/styles/colors.dart';
import 'package:yoloworks_invoice/app/styles/text_styles.dart';
import 'package:yoloworks_invoice/core/extension/datetime_extension.dart';

import '../../services/date_picker_service.dart';

class AppFilterWidget extends StatelessWidget {
  const AppFilterWidget(
      {super.key,
      this.size,
      this.count,
      this.padding,
      this.margin,
      this.onTap});

  final double? size;
  final int? count;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Badge(
        backgroundColor: AppColors.dividerGreyColor,
        smallSize: 8,
        isLabelVisible: count != null,
        label: Text(
          count.toString(),
          style: AppTextStyle.darkBlackFS10FW700,
        ),
        child: Container(
          padding: padding ?? EdgeInsets.all(3.h),
          margin: margin ?? EdgeInsets.all(3.h),
          // decoration: AppUiConstants.filterCardDecoration,
          child: SvgPicture.asset(
            Svgs.tune,
          ),
        ),
      ),
    );
  }
}

class showFilterWidget extends StatefulWidget {
  showFilterWidget(
      {super.key,
      required this.selectedDateRange,
      required this.onDateRangePicked});

  DateTimeRange? selectedDateRange;
  final void Function(DateTimeRange?) onDateRangePicked;

  @override
  State<showFilterWidget> createState() => _showFilterWidgetState();
}

class _showFilterWidgetState extends State<showFilterWidget> {
  final fromDateCtrl = TextEditingController();
  final toDateCtrl = TextEditingController();

  Future onDateFilter() async {
    final dateRange =
        await DatePickerService.pickDateRange(widget.selectedDateRange);
    if (dateRange == null) return;
    widget.selectedDateRange = dateRange;
    fromDateCtrl.text = widget.selectedDateRange.toDDMMYYFromDate() ?? "";
    toDateCtrl.text = widget.selectedDateRange.toDDMMYYToDate() ?? '';
    widget.onDateRangePicked(widget.selectedDateRange);
  }

  void onClearDateFilter() async {
    widget.selectedDateRange = null;
    fromDateCtrl.clear();
    toDateCtrl.clear();
    widget.onDateRangePicked(widget.selectedDateRange);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fromDateCtrl.text = widget.selectedDateRange.toDDMMYYFromDate() ?? "";
    toDateCtrl.text = widget.selectedDateRange.toDDMMYYToDate() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Due Date",
                  style: AppTextStyle.darkBlackFS14FW600,
                ),
                InkWell(
                  onTap: onClearDateFilter,
                  child: Text(
                    "Clear",
                    style: AppTextStyle.blueFS14FW500,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: SalesTextFieldFormWidget(
                ctrl: fromDateCtrl,
                label: "From Date",
                hintText: "Select Date",
                readOnly: true,
                onTap: () async {
                  await onDateFilter();
                },
                suffixIcon: Padding(
                  padding: EdgeInsets.all(7.h),
                  child: SvgPicture.asset(
                    Svgs.calendar,
                    color: Colors.grey,
                  ),
                ),
              )),
              Padding(
                padding: EdgeInsets.only(top: 30.h),
                child: Icon(
                  CupertinoIcons.arrow_right,
                  size: 15,
                ),
              ),
              Expanded(
                  child: SalesTextFieldFormWidget(
                ctrl: toDateCtrl,
                readOnly: true,
                hintText: "Select Date",
                label: "To Date",
                onTap: () async {
                  await onDateFilter();
                },
                suffixIcon: Padding(
                  padding: EdgeInsets.all(7.h),
                  child: SvgPicture.asset(
                    Svgs.calendar,
                    color: Colors.grey,
                  ),
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }
}
