import 'package:flutter/material.dart';
import 'package:yoloworks_invoice/app/styles/text_styles.dart';

import '../../../../../app/common_widgets/app_tag_widget.dart';
import '../../../../../app/constants/app_ui_constants.dart';
import '../../../../../app/styles/colors.dart';
import '../../../../sales/views/widgets/app_qty_unit_price_widget.dart';
import '../../models/payment_detail_model.dart';

class PaymentInvoiceItemWidget extends StatelessWidget {
  const PaymentInvoiceItemWidget(
      {super.key, required this.dueInvoiceList, this.padding});
  final List<InvoiceDetail> dueInvoiceList;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: dueInvoiceList.length,
        itemBuilder: (_, i) {
          final item = dueInvoiceList[i];

          return Container(
            decoration: AppUiConstants.salesCardDecoration,
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${item.invoiceNumber}',
                        style: AppTextStyle.darkBlackFS16FW600),
                    Text(item.billDateFormat,
                        style: AppTextStyle.greyFS14FW500),
                  ],
                ),
                if (item.dueDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: AppTagWidget(
                        title: item.dueDateFormat,
                        textStyle: AppTextStyle.darkBlackFS14FW500,
                        color: AppColors.lightBrownColor),
                  ),
                const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        QtyUnitPriceWidget(
                            title: 'Due Amount', value: item.balanceDueAmt),
                        const Spacer(),
                        Row(
                          children: [
                            const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: VerticalDivider()),
                            QtyUnitPriceWidget(
                                title: 'Payment Received',
                                value: item.receivedAmt)
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
