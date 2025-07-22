import 'package:flutter/material.dart';
import 'package:vgts_plugin/form/utils/input_formatter.dart';

import '../../../../../app/common_widgets/app_text_field_widgets/sales_text_field_form_widget.dart';
import '../../../../../app/constants/app_ui_constants.dart';
import '../../../../../app/styles/text_styles.dart';
import '../../models/payment_due_invoice_model.dart';

class InvoiceDueList extends StatelessWidget {
  const InvoiceDueList(
      {super.key,
      required this.dueInvoiceList,
      required this.onInvoiceDueChange});
  final List<PaymentInvoice> dueInvoiceList;
  final void Function(String, int) onInvoiceDueChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppUiConstants.cardDecoration,
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(8),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, i) {
          final item = dueInvoiceList[i];
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('#${item.invoiceNumber}',
                        style: AppTextStyle.darkBlackFS14FW600),
                    Text(item.balanceAmtCurrencyFormat,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.darkBlackFS12FW500),
                  ],
                ),
              ),
              Expanded(
                child: SalesTextFieldFormWidget(
                  maxLength: 14,
                  hintText: '₹0.00',
                  isEnabled: true,
                  isLabel: false,
                  ctrl: item.textCtrlValue,
                  textAlign: TextAlign.end,
                  keyboardTextType: TextInputType.number,
                  onChanged: (value) {
                    onInvoiceDueChange(value, i);
                  },
                  inputFormatter: [AmountInputFormatter(maxDigits: 13)],
                ),
              )
            ],
          );
        },
        separatorBuilder: (_, i) => const Divider(),
        itemCount: dueInvoiceList.length,
      ),
    );
  }
}
