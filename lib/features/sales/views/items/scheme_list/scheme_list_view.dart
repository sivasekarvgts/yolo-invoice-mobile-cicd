import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoloworks_invoice/core/extension/color_extension.dart';
import 'package:yoloworks_invoice/core/extension/string_extension.dart';

import '../../../../../app/common_widgets/button.dart';
import '../../../../../app/common_widgets/app_bar_widget.dart';
import '../../../../../app/common_widgets/shimmer_widget/shimmer_effect.dart';

import '../../../../../app/constants/app_sizes.dart';
import '../../../../../app/styles/colors.dart';
import '../../../../../app/styles/text_styles.dart';
import '../../../models/master_model/scheme_list_model.dart';
import 'scheme_list_ctrl.dart';

class SchemeListView extends ConsumerStatefulWidget {
  const SchemeListView({super.key, this.input});
  final Map? input;
  @override
  ConsumerState<SchemeListView> createState() => _SchemeListViewState();
}

class _SchemeListViewState extends ConsumerState<SchemeListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = ref.read(schemeListCtrlProvider.notifier);
      await controller.onInit(widget.input!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(schemeListCtrlProvider.notifier);
    final state = ref.watch(schemeListCtrlProvider);

    final isLoading = state.isLoading;
    final schemeList = controller.schemeListModel?.schemes;

    return Scaffold(
      appBar: AppBarWidget.empty(
        title: 'Select FOC Item',
        bottom: PreferredSize(preferredSize: Size.zero, child: Divider()),
      ),
      bottomNavigationBar: isLoading
          ? null
          : SafeArea(
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Divider(),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
                      child: AppButton(
                        'Claim FOC',
                        key: Key('Claim FOC'),
                        height: 35.h,
                        borderRadius: BorderRadius.circular(12.r),
                        onPressed: controller.onApplyFoc,
                      ),
                    ),
                    gapH12,
                  ],
                ),
              ),
            ),
      body: Center(
        child: isLoading
            ? const SchemeListLoading()
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: schemeList?.length ?? 0,
                itemBuilder: (_, i) {
                  final itemList = schemeList?[i];
                  final isCombineWith = itemList?.combineWithId == 1;

                  if (isCombineWith) {
                    final rulesList = itemList?.rules;
                    final isSelected = controller.schemeList
                            .where((e) =>
                                rulesList?.where((r) => r.id == e).isNotEmpty ==
                                true)
                            .isNotEmpty ==
                        true;
                    return _ContainerWrapWidget(
                      isSelected: isSelected,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isSelected)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text('Selected',
                                  style: AppTextStyle.blueFS10FW700),
                            ),
                          ListView.separated(
                              itemCount: rulesList?.length ?? 0,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemBuilder: (_, j) {
                                final item = rulesList?[j];
                                return InkWell(
                                    onTap: () => controller.onSelectedFoc(
                                        rulesList!
                                            .map((e) => e.toJson())
                                            .toList()),
                                    child: ItemWidget(
                                        item: item!,
                                        isShowImage: true,
                                        isSelected: false));
                              }),
                        ],
                      ),
                    );
                  }

                  final rulesList = itemList?.rules;

                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: rulesList?.length ?? 0,
                      itemBuilder: (context, index) {
                        final ruleItem = rulesList?[index];
                        final isSelected = controller.schemeList
                                .where((e) => ruleItem?.id == e)
                                .isNotEmpty ==
                            true;
                        return _ContainerWrapWidget(
                          isSelected: isSelected,
                          child: InkWell(
                              onTap: () =>
                                  controller.onSelectedFoc([ruleItem.toJson()]),
                              child: ItemWidget(
                                  item: ruleItem!,
                                  isShowImage: true,
                                  isSelected: isSelected)),
                        );
                      });
                }),
      ),
    );
  }
}

class SchemeListLoading extends StatelessWidget {
  const SchemeListLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return SchemeItemLoading();
      },
    );
  }
}

class SchemeItemLoading extends StatelessWidget {
  const SchemeItemLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return _ContainerWrapWidget(
      isSelected: false,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerWidget.text(
              height: 15,
              width: 150,
            ),
            gapH5,
            ShimmerWidget.text(
              height: 15,
              width: 200,
            ),
          ],
        )
      ]),
    );
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget(
      {super.key,
      required this.item,
      required this.isSelected,
      this.height = 100,
      this.width = 70,
      this.isShowImage = false,
      this.isLoading = false,
      this.isBillDetials = false});
  final Rule item;
  final bool isBillDetials;
  final bool isLoading;
  final bool isShowImage;
  final double height;
  final double width;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isSelected)
          Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text('Selected', style: AppTextStyle.blueFS10FW700)),
        Text(item.item.capitalizeFirst.toString(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.blackFS14FW500),
        SizedBox(height: isBillDetials ? 5.h : 25.h),
        Text(
            'Free: ${item.value == null ? 0 : double.parse(item.value.toString())} ${item.unit}',
            style: AppTextStyle.darkBlackFS12FW500),
      ],
    );
  }
}

class _ContainerWrapWidget extends StatelessWidget {
  const _ContainerWrapWidget({required this.isSelected, required this.child});
  final Widget? child;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      decoration: BoxDecoration(
          color: isSelected
              ? AppColors.blueColor.withOpacityValue(0.2)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected
                  ? AppColors.blueColor
                  : AppColors.dividerGreyColor)),
      padding: const EdgeInsets.all(12),
      child: child,
    );
  }
}
