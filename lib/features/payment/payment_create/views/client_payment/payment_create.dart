import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vgts_plugin/form/utils/input_formatter.dart';
import 'package:vgts_plugin/form/vgts_form.dart';
import 'package:yoloworks_invoice/app/common_widgets/button.dart';
import 'package:yoloworks_invoice/app/common_widgets/floating_button.dart';
import 'package:yoloworks_invoice/core/extension/address_extenstion.dart';
import 'package:yoloworks_invoice/locator.dart';

import '../../../../../app/common_widgets/app_bar_widget.dart';
import '../../../../../app/common_widgets/app_loading_widget.dart';
import '../../../../../app/common_widgets/app_text_field_widgets/sales_text_field_form_widget.dart';

import '../../../../../app/common_widgets/empty_widget/error_text_widget.dart';
import '../../../../../app/constants/app_sizes.dart';
import '../../../../../app/constants/app_ui_constants.dart';
import '../../../../../app/styles/colors.dart';
import '../../../../../app/styles/text_styles.dart';
import '../../../../sales/views/widgets/customer_info_widget.dart';
import '../../models/payment_params_request_model.dart';
import 'payment_create_ctrl.dart';
import '../widgets/invoices_due_widget.dart';
import '../widgets/payment_bill_summary_widget.dart';

class PaymentCreate extends ConsumerStatefulWidget {
  const PaymentCreate({super.key, this.input});

  final PaymentParamsRequestModel? input;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PaymentCreateState();
}

class _PaymentCreateState extends ConsumerState<PaymentCreate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = ref.read(paymentCreateCtrlProvider.notifier);
      await controller.onInit( widget.input);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(paymentCreateCtrlProvider.notifier);
    final state = ref.watch(paymentCreateCtrlProvider);
    final isLoading = state.isLoading;
    return AppOverlayLoaderWidget(
      isLoading: controller.paymentLoading,
      child: Scaffold(
        appBar: AppBarWidget.empty(
          automaticallyImplyLeading: false,
          title: 'Receipt: #${controller.billNo ?? ''}',
          actions: [
            IconButton(
                onPressed: () => navigationService.pop(),
                iconSize: 20,
                color: AppColors.darkBlackColor,
                padding: const EdgeInsets.all(3),
                icon: const Icon(Icons.close)),
            gapW12,
          ],
          bottom: PreferredSize(
            preferredSize: Size.zero,
            child: Divider(height: 1),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(height: 1),
              Padding(
                padding: EdgeInsets.only(
                    left: 16.w, right: 16.w, top: 10.h, bottom: 0.h),
                child: Row(
                  children: [
                    if (!controller.isEdit)
                      Expanded(
                        child: AppButton.outline(
                          key: Key("cancel_payment"),
                          'Back',
                          textStyle: AppTextStyle.blueFS14FW500,
                          height: 35.h,
                          borderRadius: BorderRadius.circular(8.r),
                          onPressed: () =>
                              navigationService.pop(),
                        ),
                      ),
                    if (!controller.isEdit) gapW20,
                    Expanded(
                      child: AppButton(
                        key: controller.isEdit ? Key("update_payment_") : Key("save_payment_"),
    controller.isEdit ? 'Update Payment' : 'Create Payment',
                        height: 35.h,
                        borderRadius: BorderRadius.circular(8.r),
                        onPressed: () => controller.createPayment(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: VGTSForm(
          key: controller.paymentFormKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomerInfoWidget(
                  isLoading: isLoading,
                  name: controller.customerData?.displayName ?? '-',
                  image: controller.customerData?.logo ?? '',
                  address: controller.customerData?.addressDetail
                          ?.toCityAddressOne() ??
                      '-',
                  isEnabled: !controller.isEdit,
                  onChange: controller.onChangeClient,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SalesTextFieldFormWidget(
                        maxLength: 20,
                        ctrl: controller.referenceNoTextEditing,
                        label: 'Reference No (optional)',
                        hintText: 'Reference No',
                      ),
                    ),
                    gapW8,
                    Expanded(
                      child: SalesTextFieldFormWidget(
                        onTap: controller.onChangeBillDate,
                        readOnly: true,
                        ctrl: controller.billDateTextEditing,
                        label: 'Bill Date',
                        hintText: 'Date',
                        borderColor: controller.billDateError != null
                            ? AppColors.redColor
                            : null,
                        suffixIcon: const Icon(Icons.keyboard_arrow_down,
                            color: Colors.black, size: 18),
                      ),
                    ),
                  ],
                ),
                if (controller.billDateError != null)
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: ErrorTextWidget(errorText: ''),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: ErrorTextWidget(
                              errorText: controller.billDateError),
                        ),
                      ),
                    ],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SalesTextFieldFormWidget(
                          hintText: '₹0.00',
                          label: 'Received Amount',
                          isEnabled: !controller.isPayFullAmt,
                          readOnly: controller.isPayFullAmt,
                          borderColor: controller.receivedAmtError != null
                              ? AppColors.redColor
                              : null,
                          onChanged: controller.onReceivedFieldChange,
                          inputFormatter: [
                            AmountInputFormatter(maxDigits: 11),
                          ],
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          ctrl: controller.receivedTextEditing,
                          keyboardTextType: TextInputType.number),
                    ),
                    gapW8,
                    Expanded(
                      child: SalesTextFieldFormWidget(
                        onTap: controller.selectPaymentModeBottomSheet,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        ctrl: controller.paymentModeTextEditing,
                        readOnly: true,
                        borderColor: controller.paymentModeError != null
                            ? AppColors.redColor
                            : null,
                        label: 'Payment Mode',
                        suffixIcon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: ErrorTextWidget(
                            errorText: controller.receivedAmtError),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: ErrorTextWidget(
                            errorText: controller.paymentModeError),
                      ),
                    ),
                  ],
                ),
                if (controller.selectPaymentMode.id == 3)
                  SalesTextFieldFormWidget(
                    maxLength: 20,
                    ctrl: controller.transferIdTextEditing,
                    label: 'Transfer Id (optional)',
                    hintText: '',
                  ),
                if (controller.selectPaymentMode.id == 2)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Column(
                        children: [
                          SalesTextFieldFormWidget(
                            maxLength: 20,
                            ctrl: controller.chequeNoTextEditing,
                            label: 'Cheque Number',
                            hintText: 'Cheque Number',
                            onChanged: controller.onPaymentChange,
                            borderColor: controller.chequeNoError != null
                                ? AppColors.redColor
                                : null,
                          ),
                          ErrorTextWidget(errorText: controller.chequeNoError),
                        ],
                      )),
                      gapW8,
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SalesTextFieldFormWidget(
                            onTap: controller.onChangeChequeData,
                            readOnly: true,
                            ctrl: controller.chequeDateTextEditing,
                            label: 'Cheque Date',
                            hintText: 'Date',
                            borderColor: controller.chequeDateError != null
                                ? AppColors.redColor
                                : null,
                            suffixIcon: const Icon(Icons.keyboard_arrow_down,
                                color: Colors.black, size: 18),
                          ),
                          ErrorTextWidget(
                              errorText: controller.chequeDateError),
                        ],
                      )),
                    ],
                  ),
                if (controller.billDetail != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                        'Due amount for this bill ${controller.billDetail?.balanceDue ?? 0}',
                        style: AppTextStyle.greyFS12FW500),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                        'Due amount from ${controller.paymentDueInvoiceList.length} bills ${controller.totalPayableAmt}',
                        style: AppTextStyle.greyFS12FW500),
                  ),
                if (!controller.isEdit)
                  InkWell(
                    onTap: controller.changePayFullAmt,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: AppUiConstants.checkBoxDecoration(
                                controller.isPayFullAmt
                                    ? AppColors.blueColor
                                    : Colors.white),
                            child: SizedBox(
                                height: 16,
                                width: 16,
                                child: !controller.isPayFullAmt
                                    ? const SizedBox()
                                    : const Icon(Icons.check,
                                        size: 15, color: Colors.white)),
                          ),
                          const SizedBox(width: 10),
                          Text('Pay full amount',
                              style: AppTextStyle.darkBlackFS12FW500)
                        ],
                      ),
                    ),
                  ),

                if (!controller.isVendor)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SalesTextFieldFormWidget(
                        onTap: controller.openChartsOfAccountBottomSheet,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        ctrl: controller.accountsTextCtrl,
                        readOnly: true,
                        borderColor: controller.accountsError != null
                            ? AppColors.redColor
                            : null,
                        label: 'Receipt Account',
                        suffixIcon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black,
                          size: 18,
                        ),
                      ),
                      ErrorTextWidget(errorText: controller.accountsError),
                    ],
                  ),
                if (controller.paymentDueInvoiceList.isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
                    child: InkWell(
                      onTap: controller.openInvoices,
                      child: Row(
                        children: [
                          Text('View Payment Breakdown',
                              style: AppTextStyle.darkBlackFS12H16FW500),
                          Icon(
                              !controller.isOpenInvoices
                                  ? Icons.keyboard_arrow_down_outlined
                                  : Icons.keyboard_arrow_up_outlined,
                              size: 20)
                        ],
                      ),
                    ),
                  ),
                if (controller.isOpenInvoices &&
                    controller.paymentDueInvoiceList.isNotEmpty)
                  InvoiceDueList(
                    dueInvoiceList: controller.paymentDueInvoiceList,
                    onInvoiceDueChange: controller.onInvoiceDueChange,
                  ),
                PaymentBillSummaryWidget(
                  isEnabled: true,
                  totalCost: controller.receivedTextEditing.text,
                  notesTextCtrl: controller.notesTextEditing,
                  amtUsedTextCtrl: controller.amtUsedTextEditing,
                  amtExcessTextCtrl: controller.excessAmtTextEditing,
                  amtReceivedTextCtrl: controller.receivedTextEditing,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
