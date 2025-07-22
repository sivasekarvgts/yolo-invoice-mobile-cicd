import 'package:flutter/material.dart';

import '../../../../../app/common_widgets/app_text_field_widgets/sales_text_field_form_widget.dart';
import '../../../../../app/common_widgets/sales_bill_widget/sales_bill_widget.dart';
import '../../../../../app/styles/text_styles.dart';

class PaymentBillSummaryWidget extends StatelessWidget {
  const PaymentBillSummaryWidget({
    super.key,
    this.isEnabled = true,
    required this.totalCost,
    this.notesTextCtrl,
    this.amtUsedTextCtrl,
    this.amtExcessTextCtrl,
    this.amtReceivedTextCtrl,
  });
  final String totalCost;
  final bool isEnabled;

  final TextEditingController? notesTextCtrl;
  final TextEditingController? amtUsedTextCtrl;
  final TextEditingController? amtExcessTextCtrl;
  final TextEditingController? amtReceivedTextCtrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bill Summary',
            style: AppTextStyle.darkBlackFS14FW500,
          ),
          SalesBillWidget(
            title: 'Amount Received',
            ctrl: amtReceivedTextCtrl,
            readOnly: true,
          ),
          const Divider(),
          SalesBillWidget(
            title: 'Amount used for \npayments',
            ctrl: amtUsedTextCtrl,
            readOnly: true,
          ),
          const Divider(),
          SalesBillWidget(
            title: 'Excess Amount',
            ctrl: amtExcessTextCtrl,
            readOnly: true,
          ),
          const Divider(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTextStyle.darkBlackFS16FW700,
              ),
              Text(totalCost.isEmpty ? '0' : totalCost,
                  style: AppTextStyle.darkBlackFS16FW700),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(),
          SalesTextFieldFormWidget(
            maxLines: 5,
            maxLength: 100,
            ctrl: notesTextCtrl,
            constraints: BoxConstraints(),
            label: 'Notes (optional)',
            hintText: '',
          ),
        ],
      ),
    );
  }
}
