import 'package:flutter/material.dart';

import '../../../../../app/styles/colors.dart';
import '../../../../../app/styles/text_styles.dart';
import '../../models/payment_mode_list.dart';

class PaymentModeWidget extends StatelessWidget {
  const PaymentModeWidget(
      {super.key,
      required this.title,
      required this.onTap,
      required this.typeModelList,
      required this.selectedId});
  final String title;
  final int selectedId;
  final List<PaymentModeList> typeModelList;
  final void Function(PaymentModeList value) onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (typeModelList.isEmpty)
          const Center(
              child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No Data'),
          ))
        else
          Flexible(
            child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                itemCount: typeModelList.length,
                separatorBuilder: (_, i) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final item = typeModelList[i];
                  return Material(
                    child: InkWell(
                      onTap: () => onTap(item),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item.name.toString(),
                                style: AppTextStyle.darkBlackFS14FW500),
                            if (selectedId == item.id)
                              const Icon(Icons.radio_button_checked_outlined,
                                  size: 20, color: AppColors.blueColor)
                            else
                              const Icon(Icons.radio_button_off_outlined,
                                  size: 20)
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
      ],
    );
  }
}
