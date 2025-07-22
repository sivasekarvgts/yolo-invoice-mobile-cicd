import 'package:flutter/material.dart';
import 'package:yoloworks_invoice/core/extension/currency_extension.dart';

import '../../../../app/styles/text_styles.dart';

class GstBreakDownSheet extends StatelessWidget {
  const GstBreakDownSheet({super.key, required this.breakDownList});

  final List breakDownList;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (breakDownList.isEmpty)
          const Padding(
            padding: EdgeInsets.all(30.0),
            child: Center(child: Text('No Data Found')),
          )
        else
          Flexible(
            child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: breakDownList.length,
                itemBuilder: (_, i) {
                  final item = breakDownList[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(item['taxName'],
                                style: AppTextStyle.darkBlackFS16FW500),
                            const SizedBox(width: 5),
                            Text('[${item['taxPercent']}%]',
                                style: AppTextStyle.darkBlackFS16FW500)
                          ],
                        ),
                        Text(
                            (item['taxAmt'] as double).toCurrencyFormatString(),
                            style: AppTextStyle.darkBlackFS16FW500)
                      ],
                    ),
                  );
                }),
          ),
      ],
    );
  }
}
