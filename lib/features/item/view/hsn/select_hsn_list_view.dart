import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoloworks_invoice/app/constants/app_ui_constants.dart';
import 'package:yoloworks_invoice/app/styles/colors.dart';
import 'package:yoloworks_invoice/app/styles/text_styles.dart';
import 'package:yoloworks_invoice/features/item/model/hsn_list_model.dart';
import 'package:yoloworks_invoice/features/item/view/hsn/select_hsn_list_controller.dart';

import '../../../../../app/common_widgets/app_bar_widget.dart';
import '../../../../../app/common_widgets/app_refresh_widget.dart';
import '../../../../../app/common_widgets/search_widget.dart';
import '../../../../../app/constants/app_sizes.dart';
import '../../../../../locator.dart';
import '../../../../app/common_widgets/app_filter_widget.dart';
import '../../../../app/common_widgets/empty_widget/app_empty_widget.dart';
import '../../../../app/common_widgets/shimmer_widget/list_item_loading_widget.dart';

class SelectHsnListView extends ConsumerStatefulWidget {
  const SelectHsnListView({super.key});

  @override
  ConsumerState<SelectHsnListView> createState() => _SelectHsnListViewState();
}

class _SelectHsnListViewState extends ConsumerState<SelectHsnListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = ref.read(selectHsnListControllerProvider.notifier);
      await controller.onInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(selectHsnListControllerProvider.notifier);
    final state = ref.watch(selectHsnListControllerProvider);
    final isLoading = state.isLoading;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBarWidget.empty(
        title: 'Select HSN',
        actions: [
          if (!controller.showSearchBar)
            IconButton(
                onPressed: controller.onOpenSearch,
                iconSize: 20,
                icon: const Icon(CupertinoIcons.search)),
        
          gapW12,
        ],
        onChanged: controller.onSearchInvoice,
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
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: const Divider(height: 1,)),
      ),
      body: Column(
        children: [
          Expanded(
            child: AppRefreshWidget(
              onRefresh: () async {
                if (isLoading) return;
                return await controller.fetchData(refresh: true);
              },
              onLoad: () async {
                if (isLoading) return;
                return await controller.fetchData();
              },
              childBuilder: (context, physics) => HsnListWidget(
                physics: physics,
                isLoading: isLoading,
                hsnList: controller.hsnList,
                onTap: (val) {
                  navigationService.pop(returnValue: val);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HsnListWidget extends ConsumerWidget {
  const HsnListWidget({
    super.key,
    this.onTap,
    required this.physics,
    required this.hsnList,
    this.isLoading = false,
  });

  final bool isLoading;
  final ScrollPhysics physics;
  final void Function(HsnData val)? onTap;
  final List<HsnData> hsnList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isLoading) {
      return ListItemLoadingWidget();
    }
    if (hsnList.isEmpty) {
      return AppEmptyWidget(
        physics: physics,
        reducePercent: 10,
      );
    }

    return ListView.separated(
      physics: physics,
      itemCount: hsnList.length,
      padding: EdgeInsets.all( 12.w,),
      separatorBuilder: (context, index) => gapH5,
      itemBuilder: (context, i) {
        final hsn = hsnList[i];
        return InkWell(
          onTap: () {
            onTap!(hsn);
          },
          child: Container(
            // color: AppColors.white,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: AppUiConstants.salesCardItemDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hsn.name ?? "",
                  style: AppTextStyle.darkBlackFS14FW400,
                ),
                gapH5,
                Text(
                  hsn.description ?? "",
                  style: AppTextStyle.greyFS12FW500,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
