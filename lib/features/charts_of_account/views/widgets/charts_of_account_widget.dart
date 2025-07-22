import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/common_widgets/empty_widget/app_empty_widget.dart';
import '../../../../app/styles/colors.dart';
import '../../../../app/styles/text_styles.dart';
import '../../../../app/constants/app_sizes.dart';
import '../../models/charts_of_accounts_list_model.dart';

class ChartsOfAccountsWidget extends StatelessWidget {
  const ChartsOfAccountsWidget(
      {super.key,
      required this.chartsOfAccountList,
      required this.onTap,
      required this.onAddAccounts,
      required this.selectedItem});
  final List<ChartsOfAccountListModel> chartsOfAccountList;
  final NodesList? selectedItem;
  final void Function() onAddAccounts;
  final void Function(NodesList? childItem) onTap;

  @override
  Widget build(BuildContext context) {
    if (chartsOfAccountList.isEmpty) return AppEmptyWidget();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 400,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            shrinkWrap: true,
            itemCount: chartsOfAccountList.length,
            itemBuilder: (context, _index) {
              final List<NodesList>? _item =
                  chartsOfAccountList[_index].nodesList;
              return ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: _item?.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, j) {
                    final nodeItem = _item?[j];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (nodeItem?.name != null)
                          Container(
                            decoration:
                                BoxDecoration(color: AppColors.greyColor300),
                            alignment: Alignment.center,
                            child: Text(
                              '${nodeItem?.name}',
                              textAlign: TextAlign.start,
                              style: AppTextStyle.darkBlackFS16FW600,
                            ),
                          ),
                        ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: nodeItem?.nodeListChildren?.length ?? 0,
                            separatorBuilder: (_, i) =>
                                const Divider(height: 1),
                            itemBuilder: (context, _k) {
                              final childItem = nodeItem?.nodeListChildren?[_k];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Material(
                                    color: Colors.white,
                                    child: InkWell(
                                      onTap: () => onTap(childItem),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 14.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                '${childItem?.name}',
                                                style:
                                                    AppTextStyle.blackFS14FW500,
                                              ),
                                            ),
                                            if (selectedItem == childItem)
                                              const Icon(
                                                  Icons
                                                      .radio_button_checked_outlined,
                                                  size: 20,
                                                  color: AppColors.blueColor)
                                            else
                                              const Icon(
                                                  Icons
                                                      .radio_button_off_outlined,
                                                  size: 20)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    padding:
                                        EdgeInsets.only(left: 8.w, bottom: 8.h),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        childItem?.nodeListChildren?.length ??
                                            0,
                                    itemBuilder: (_, w) {
                                      final childNodeItem =
                                          childItem?.nodeListChildren?[w];
                                      return Material(
                                        color: Colors.white,
                                        child: InkWell(
                                          onTap: () => onTap(childNodeItem),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.h),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    '${childNodeItem?.name}',
                                                    style: AppTextStyle
                                                        .blackFS14FW500,
                                                  ),
                                                ),
                                                if (selectedItem ==
                                                    childNodeItem)
                                                  const Icon(
                                                      Icons
                                                          .radio_button_checked_outlined,
                                                      size: 20,
                                                      color:
                                                          AppColors.blueColor)
                                                else
                                                  const Icon(
                                                      Icons
                                                          .radio_button_off_outlined,
                                                      size: 20)
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (_, i) => const Divider(),
                                  )
                                ],
                              );
                            })
                      ],
                    );
                  });
            },
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: EdgeInsets.only(
            left: 12.w,
            right: 12.w,
            bottom: 4.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              gapH4,
              Material(
                color: Colors.white,
                child: InkWell(
                  onTap: onAddAccounts,
                  child: Row(
                    children: [
                      Icon(Icons.add, color: AppColors.blueColor, size: 17),
                      gapW4,
                      Text('Add Accounts', style: AppTextStyle.blueFS14FW500),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ChartsOfAccountsNodeListWidget extends StatelessWidget {
  const ChartsOfAccountsNodeListWidget(
      {super.key,
      required this.accountList,
      required this.onTap,
      required this.onAddAccounts,
      required this.selectedItem});
  final List<NodesList> accountList;
  final NodesList? selectedItem;
  final void Function() onAddAccounts;
  final void Function(NodesList? childItem) onTap;

  @override
  Widget build(BuildContext context) {
    if (accountList.isEmpty) return AppEmptyWidget();
    final item = accountList;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 400,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: item.length,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              itemBuilder: (context, j) {
                final nodeItem = item[j];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (nodeItem.name != null)
                      Container(
                        decoration:
                            BoxDecoration(color: AppColors.greyColor300),
                        alignment: Alignment.center,
                        child: Text(
                          '${nodeItem.name}',
                          textAlign: TextAlign.start,
                          style: AppTextStyle.darkBlackFS16FW600,
                        ),
                      ),
                    ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: nodeItem.nodeListChildren?.length ?? 0,
                        separatorBuilder: (_, i) => const Divider(height: 1),
                        itemBuilder: (context, k) {
                          final childItem = nodeItem.nodeListChildren?[k];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Material(
                                color: Colors.white,
                                child: InkWell(
                                  onTap: () => onTap(childItem),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 14.h),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            '${childItem?.name}',
                                            style: AppTextStyle.blackFS14FW500,
                                          ),
                                        ),
                                        if (selectedItem == childItem)
                                          const Icon(
                                              Icons
                                                  .radio_button_checked_outlined,
                                              size: 20,
                                              color: AppColors.blueColor)
                                        else
                                          const Icon(
                                              Icons.radio_button_off_outlined,
                                              size: 20)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              ListView.separated(
                                shrinkWrap: true,
                                padding:
                                    EdgeInsets.only(left: 8.w, bottom: 8.h),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    childItem?.nodeListChildren?.length ?? 0,
                                itemBuilder: (_, j) {
                                  final childNodeItem =
                                      childItem?.nodeListChildren?[j];

                                  return Material(
                                    color: Colors.white,
                                    child: InkWell(
                                      onTap: () => onTap(childNodeItem),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                '${childNodeItem?.name}',
                                                style:
                                                    AppTextStyle.blackFS14FW500,
                                              ),
                                            ),
                                            if (selectedItem == childNodeItem)
                                              const Icon(
                                                  Icons
                                                      .radio_button_checked_outlined,
                                                  size: 20,
                                                  color: AppColors.blueColor)
                                            else
                                              const Icon(
                                                  Icons
                                                      .radio_button_off_outlined,
                                                  size: 20)
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (_, i) => const Divider(),
                              )
                            ],
                          );
                        })
                  ],
                );
              }),
        ),
        const Divider(height: 1),
        AddButtonWidget(onAddAccounts: onAddAccounts),
      ],
    );
  }
}

class AddButtonWidget extends StatelessWidget {
  const AddButtonWidget({
    super.key,
    required this.onAddAccounts,
  });

  final void Function() onAddAccounts;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 12.w,
        right: 12.w,
        bottom: 4.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          gapH4,
          Material(
            color: Colors.white,
            child: InkWell(
              onTap: onAddAccounts,
              child: Row(
                children: [
                  Icon(Icons.add, color: AppColors.blueColor, size: 17),
                  gapW4,
                  Text('Add Accounts', style: AppTextStyle.blueFS14FW500),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
