import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yoloworks_invoice/app/styles/text_styles.dart';

import '../styles/colors.dart';

class EditDeletePopUpMenuWidget extends StatelessWidget {
  const EditDeletePopUpMenuWidget(
      {super.key,
      this.isShowDelete = false,
      this.iconSize = 18,
      this.isItemList,
      this.onSelected});
  final bool isShowDelete;
  final double? iconSize;
  final Function(String)? onSelected;
  final List<PopUpItemModel>? isItemList;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        color: Colors.white,
        itemBuilder: (isItemList?.isNotEmpty == true)
            ? (context) => [
                  for (final item in isItemList!)
                    PopupMenuItem(
                        value: item.value,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.name,
                              style: AppTextStyle.labelSmall,
                            ),
                            Icon(item.iconData, size: 20, color: item.iconColor)
                          ],
                        ))
                ]
            : (context) => [
                  PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Edit",
                            style: AppTextStyle.labelSmall,
                          ),
                          const Icon(Icons.edit_outlined, size: 20)
                        ],
                      )),
                  if (!isShowDelete)
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Delete",
                              style: AppTextStyle.labelSmall
                                  .copyWith(color: AppColors.redColor)),
                          Icon(CupertinoIcons.delete,
                              size: 18, color: AppColors.redColor)
                        ],
                      ),
                    ),
                ],
        onSelected: (value) => onSelected != null ? onSelected!(value) : null,
        child: Icon(Icons.more_vert, size: iconSize));
  }
}

class PopUpItemModel {
  final String name;
  final String value;
  final Color iconColor;
  final IconData iconData;

  PopUpItemModel(
      {required this.name,
      this.iconColor = Colors.black,
      required this.value,
      required this.iconData});
}
