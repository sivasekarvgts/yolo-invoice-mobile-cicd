import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yoloworks_invoice/core/extension/address_extenstion.dart';

import '../../../../app/common_widgets/app_bar_widget.dart';
import '../../../../app/common_widgets/app_loading_widget.dart';
import '../../../../app/common_widgets/app_popup_menu_button_widget.dart';
import '../../../../app/common_widgets/app_tag_widget.dart';
import '../../../../app/common_widgets/badge_count_widget.dart';
import '../../../../app/constants/app_sizes.dart';
import '../../../../app/styles/colors.dart';
import '../../../../app/styles/text_styles.dart';
import '../../../bill_preview/views/widgets/store_widget.dart';
import '../../../sales/views/sales_info/sales_info.dart';
import 'payment_detail_ctrl.dart';
import 'widgets/payment_invoice_item_widget.dart';

class PaymentDetailScreen extends ConsumerStatefulWidget {
  const PaymentDetailScreen({super.key, this.data});

  final Map? data;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends ConsumerState<PaymentDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = ref.read(paymentDetailCtrlProvider.notifier);
      await controller.onInit(widget.data);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(paymentDetailCtrlProvider.notifier);
    final state = ref.watch(paymentDetailCtrlProvider);
    final isLoading = state.isLoading;

    final paymentDetailModel = controller.paymentDetailModel;
    return AppOverlayLoaderWidget(
      isLoading: controller.loading,
      child: Scaffold(
        appBar: AppBarWidget.empty(
          title: 'Bill Details',
          actions: [
            AppPopupMenuButtonWidget(
                menuItems: [
                  PopupMenuItem(
                    value: "delete",
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Delete",
                          style: AppTextStyle.blackFS14FW500,
                        ),
                        Icon(
                          CupertinoIcons.delete,
                          size: 20,
                          color: AppColors.redColor,
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: "edit",
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Edit",
                          style: AppTextStyle.blackFS14FW500,
                        ),
                        Icon(
                          Icons.edit_outlined,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: "preview",
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Preview",
                          style: AppTextStyle.blackFS14FW500,
                        ),
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) async {
                  if (value == 'delete') {
                    controller.deleteOrderPopup();
                    return;
                  }
                  if (value == 'edit') {
                    controller.editPayment();
                    return;
                  }
                  if (value == 'preview') {
                    return;
                  }
                }),
            gapW12,
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: Divider(height: 1),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StoreListTitleWidget(
                isLoading: isLoading,
                url: paymentDetailModel?.image,
                contentPadding: EdgeInsets.zero,
                title: controller.isReceipt
                    ? paymentDetailModel?.client ?? ""
                    : paymentDetailModel?.vendor ?? '',
                subTitle: paymentDetailModel?.addressDetail
                        ?.inFullAddress(isShipping: controller.isReceipt) ??
                    '',
              ),
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4), child: Divider()),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(paymentDetailModel?.paymentNumber ?? 'N/A',
                          style: AppTextStyle.darkBlackFS16FW600),
                      AppTagWidget(
                          title: paymentDetailModel?.paymentModeName
                                  ?.toUpperCase() ??
                              'N/A',
                          textStyle: AppTextStyle.darkBlackFS12FW400,
                          color: AppColors.lightBrownColor)
                    ],
                  ),
                  gapH4,
                  Text(paymentDetailModel?.billDate ?? '',
                      style: AppTextStyle.darkBlackFS10FW600),
                ],
              ),
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4), child: Divider()),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: BillDueDateWidget(
                            title: 'Amount received',
                            value: paymentDetailModel?.receivedAmt ?? '')),
                    const VerticalDivider(),
                    Expanded(
                        child: BillDueDateWidget(
                            title: 'Excess Amount',
                            value: paymentDetailModel?.excessAmt ?? '')),
                  ],
                ),
              ),
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: AppColors.outlineGreyColor)),
              InkWell(
                onTap: controller.openItem,
                child: Row(
                  children: [
                    Text('Linked bills',
                        style: AppTextStyle.darkBlackFS16FW500),
                    gapW4,
                    BadgeCountWidget(
                        count: paymentDetailModel?.invoiceDetails?.length ?? 0),
                    const Spacer(),
                    Icon(
                        controller.isItemOpen
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 20),
                    gapW6
                  ],
                ),
              ),
              if (controller.isItemOpen)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PaymentInvoiceItemWidget(
                        dueInvoiceList:
                            (paymentDetailModel?.invoiceDetails ?? []),
                        padding: const EdgeInsets.symmetric(vertical: 4)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Amount Paid',
                                  style: AppTextStyle.darkBlackFS14FW500),
                              Text(paymentDetailModel?.receivedAmt ?? '-',
                                  style: AppTextStyle.darkBlackFS14FW500),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Amount used for payments',
                                  style: AppTextStyle.darkBlackFS14FW500),
                              Text(paymentDetailModel?.usedAmt ?? '-',
                                  style: AppTextStyle.greyFS14FW500),
                            ],
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Divider()),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Excess Amount',
                                  style: AppTextStyle.darkBlackFS16FW500),
                              Text(paymentDetailModel?.excessAmt ?? '-',
                                  style: AppTextStyle.darkBlackFS16FW500),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(color: AppColors.outlineGreyColor)),
            ],
          ),
        ),
      ),
    );
  }
}
