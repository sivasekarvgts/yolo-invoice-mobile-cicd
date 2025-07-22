import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vgts_plugin/form/vgts_form.dart';
import 'package:yoloworks_invoice/app/common_widgets/app_bar_widget.dart';
import 'package:yoloworks_invoice/app/constants/app_sizes.dart';
import 'package:yoloworks_invoice/features/item/model/inventory_item_details_model.dart';
import 'package:yoloworks_invoice/features/item/view/new_item/item_create_controller.dart';

import '../../../../app/common_widgets/app_loading_widget.dart';
import '../../../../app/common_widgets/button.dart';
import '../../../../app/styles/colors.dart';
import '../../../../app/styles/text_styles.dart';

class ItemCreateView extends ConsumerStatefulWidget {
  const ItemCreateView({super.key,this.editDetails});
  final InventoryItemDetailsModel? editDetails;

  @override
  ConsumerState createState() => _ItemCreateViewState();
}

class _ItemCreateViewState extends ConsumerState<ItemCreateView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = ref.read(itemCreateControllerProvider.notifier);
      controller.onInit(widget.editDetails);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(itemCreateControllerProvider.notifier);
    final state = ref.watch(itemCreateControllerProvider);
    return VGTSForm(
      key: controller.basicInfoKey,
      child: AppOverlayLoaderWidget(
        isLoading: state.isLoading,
        child: Scaffold(
          appBar: AppBarWidget.empty(
            title: controller.isEdit?"Edit Item":'New Item',
            bottom:controller.isEdit?null: PreferredSize(
              preferredSize: Size.zero,
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 2,
                  width: MediaQuery.of(context).size.width /
                      controller.completedPercent,
                  child: const ColoredBox(color: AppColors.primary),
                ),
              ),
            ),
          ),
          bottomNavigationBar: state.isLoading
              ? null
              : SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Divider(height: 1),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        child: Row(
                          children: [
                            if (controller.selectedIndex > 0 &&
                                !(controller.selectedIndex > 2))
                              Expanded(
                                flex: 0,
                                child: Row(
                                  children: [
                                    AppButton.outline(
                                      fullSize: false,
                                      'Back',
                                      textStyle: AppTextStyle.bodyMedium.copyWith(
                                          color: AppColors.fuscousGreyColor),
                                      height: 40.h,
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      borderColor: AppColors.fuscousGreyColor,
                                      icon: const Icon(Icons.arrow_back_outlined,
                                          color: AppColors.fuscousGreyColor,
                                          size: 18),
                                      onPressed: () {
                                        if (controller.selectedIndex == 1) {
                                          return controller.onNext(0);
                                        }
                                        controller.onNext(1);
                                      },
                                      key: Key("customerCreateBack"),
                                    ),
                                    gapW16,
                                  ],
                                ),
                              ),
                            Expanded(
                              flex: 1,
                              child: AppButton(
                                  key: Key("add_item_next"),
                                  iconAlignment: Alignment.centerRight,
                                (  controller.completedPercent == 1||controller.isEdit)
                                      ? 'Save'
                                      : 'Next',
                                  height: 40.h,
                                  width: MediaQuery.of(context).size.width * .5,
                                  icon: const Icon(Icons.arrow_forward,
                                      color: Colors.white, size: 18),
                                  isLoading: state.isLoading, onPressed: () {
                                if (controller.selectedIndex == 0) {
                                  controller.onSaveBasicInfo();
                                  return;
                                } else if (controller.selectedIndex == 1) {
                                  controller.onSaveSales();
                                  return;
                                } else if (controller.selectedIndex == 2) {
                                  controller.onSavePurchase();
                                  return;
                                }
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          body:
              SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: controller.formWidgets[controller.selectedIndex]),
        ),
      ),
    );
  }
}
