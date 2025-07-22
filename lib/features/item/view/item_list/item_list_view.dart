import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoloworks_invoice/app/common_widgets/network_image_loader.dart';
import 'package:yoloworks_invoice/app/constants/app_ui_constants.dart';
import 'package:yoloworks_invoice/app/styles/colors.dart';
import 'package:yoloworks_invoice/core/extension/color_extension.dart';
import 'package:yoloworks_invoice/core/extension/currency_extension.dart';
import 'package:yoloworks_invoice/features/item/view/item_list/item_list_controller.dart';
import 'package:yoloworks_invoice/features/sales/views/widgets/status_widget.dart';
import 'package:yoloworks_invoice/locator.dart';
import 'package:yoloworks_invoice/router.dart';

import '../../../../app/common_widgets/app_bar_widget.dart';
import '../../../../app/common_widgets/app_refresh_widget.dart';
import '../../../../app/common_widgets/empty_widget/app_empty_widget.dart';
import '../../../../app/common_widgets/floating_button.dart';
import '../../../../app/common_widgets/search_widget.dart';
import '../../../../app/common_widgets/shimmer_widget/list_item_loading_widget.dart';
import '../../../../app/constants/app_sizes.dart';
import '../../../../app/styles/text_styles.dart';
import '../../model/inventory_item_list_model.dart';

class ItemInventoryListView extends ConsumerStatefulWidget {
  const ItemInventoryListView({super.key});

  @override
  ConsumerState createState() => _ItemInventoryListViewState();
}

class _ItemInventoryListViewState extends ConsumerState<ItemInventoryListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = ref.read(itemListControllerProvider.notifier);
      await controller.onInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(itemListControllerProvider.notifier);
    final state = ref.watch(itemListControllerProvider);
    final isLoading = state.isLoading;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBarWidget.empty(
        title: 'Items',
        onChanged: controller.onSearch,
        textCtrl: controller.searchTextCtrl,
        isSearchBar: controller.showSearchBar,
        onClear: () async {
          controller.showSearchBar = false;
          if( controller.searchTextCtrl.text.isNotEmpty){
            controller.searchTextCtrl.clear();
            await controller.fetchData(refresh: true);
          } else {
            controller.setState;
          }
        },
        actions: [
          if (!controller.showSearchBar)
            IconButton(
                onPressed: controller.onOpenSearch,
                icon: const Icon(CupertinoIcons.search)),
          gapW12,
        ],
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child:  const Divider(height: 1,)
        ),

      ),
      floatingActionButton: SafeArea(
        child: FloatingButton(
            onTap: () {
              navigationService.pushNamed(Routes.itemCreate);
            },
            visibilityOfFloating: controller.visibilityOfFloating),
      ),
      body: AppRefreshWidget(
        onRefresh: () async {
          if (isLoading) return;
          return await controller.fetchData(refresh: true);
        },
        onLoad: () async {
          if (isLoading) return;
          return await controller.fetchData();
        },
        childBuilder: (context, physics) => InventoryItemListWidget(
          physics: physics,
          controller: controller.hideButtonController,
          isLoading: isLoading,
          itemList: controller.itemList,
          onTap: (i) {
            navigationService.pushNamed(Routes.itemInventoryDetail,arguments: i.id);
          },
        ),
      ),
    );
  }
}

class InventoryItemListWidget extends StatelessWidget {
  const InventoryItemListWidget({
    super.key,
    this.onTap,
    required this.physics,
    required this.controller,
    required this.itemList,
    this.isLoading = false,
  });

  final bool isLoading;
  final ScrollPhysics physics;
  final ScrollController? controller;
  final void Function(InventoryItemDatum i)? onTap;
  final List<InventoryItemDatum> itemList;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return ListItemLoadingWidget(noIcon: false,);
    }
    if (itemList.isEmpty) {
      return AppEmptyWidget(
        physics: physics,
        reducePercent: 10,
      );
    }

    return ListView.builder(
      controller: controller,
      physics: physics,
      itemCount: itemList.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, i) {
        final item = itemList[i];
        return InkWell(
          onTap: () {
            onTap!(item);
          },
          child: Container(
            decoration: AppUiConstants.salesCardItemDecoration,
            margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Row(
              children: [
                NetworkImageLoader(
                  height: 50.h,
                  width: 40.h,
                  fit: BoxFit.fill,
                  useClientPlaceHolder: false,
                  borderRadius: BorderRadius.circular(8),
                  image: item.image??"",),
                gapW15,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if((item.stockOnHand??"").isNotEmpty==true) Text("${ (item.stockOnHand?? 0)} Left",
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.greyFS12FW500)
                      else
                              StatusWidget(status: "Out of Stock",
                                padding: EdgeInsets.symmetric(horizontal: 5,vertical: 1.5),
                                color: AppColors.beanRedColor.withOpacityValue(.5),textStyle: AppTextStyle.darkBlackFS10FW500.copyWith(fontSize: 9.sp),),
                      gapH2,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                              child: Text(
                            item.name ?? "-",
                            style: AppTextStyle.blackFS14FW600,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )),
                          Text(item.sellingPrice?.toCurrencyFormatString() ?? '0',
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.blackFS14FW600),
                        ],
                      ),
                      gapH4,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("HSN Code: ${item.hsnCode ?? '-'}",
                              style: AppTextStyle.greyFS12FW500),
                          Text("${item.tax ?? 0}%",
                              style: AppTextStyle.greyFS12FW500),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
