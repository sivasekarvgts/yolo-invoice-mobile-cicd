import 'package:flutter/material.dart';

import '../../../../app/styles/colors.dart';
import '../../../../app/styles/text_styles.dart';
import '../../models/master_model/due_period_list_model.dart';

class ChipListWidget extends StatelessWidget {
  final DuePeriodListModel selectedItem;
  final List<DuePeriodListModel> typeModelList;
  final void Function(DuePeriodListModel item) onChange;

  const ChipListWidget(
      {super.key,
      required this.typeModelList,
      required this.selectedItem,
      required this.onChange});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: typeModelList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) {
          final item = typeModelList[i];
          bool isSelected = selectedItem.id == item.id;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: () => onChange(item),
              borderRadius: BorderRadius.circular(50),
              child: Chip(
                side: BorderSide(
                    color: !isSelected
                        ? AppColors.outlineGreyColor
                        : Colors.black),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                backgroundColor:
                    isSelected ? AppColors.dividerGreyColor : Colors.white,
                label: Text(
                  item.name == 'custom' ? 'Custom' : 'Due in ${item.name}',
                  style: AppTextStyle.darkBlackFS14FW500,
                ),
                labelPadding:
                    const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
              ),
            ),
          );
        });
  }
}
