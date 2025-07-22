import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoloworks_invoice/app/styles/colors.dart';
import 'package:yoloworks_invoice/core/extension/address_extenstion.dart';

import '../../../app/common_widgets/app_bar_widget.dart';
import '../../../app/common_widgets/app_refresh_widget.dart';
import '../../../app/common_widgets/empty_widget/app_empty_widget.dart';
import '../../../app/common_widgets/floating_button.dart';
import '../../../app/common_widgets/network_image_loader.dart';
import '../../../app/common_widgets/search_widget.dart';
import '../../../app/common_widgets/shimmer_widget/shimmer_effect.dart';
import '../../../app/constants/app_sizes.dart';
import '../../../app/constants/app_ui_constants.dart';
import '../../../app/styles/text_styles.dart';
import '../../../core/enums/user_type.dart';
import 'client_list_controller.dart';

class ClientListView extends ConsumerStatefulWidget {
  const ClientListView({
    super.key,
    required this.usersType,
    this.isSelect = false,
  });

  final UsersType usersType;
  final bool isSelect;

  @override
  ConsumerState createState() => _ClientListViewState();
}

class _ClientListViewState extends ConsumerState<ClientListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = ref.read(clientListControllerProvider.notifier);
      await controller.onInit(widget.usersType, widget.isSelect);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(clientListControllerProvider.notifier);
    final state = ref.watch(clientListControllerProvider);
    final isCustomer = controller.userType == UsersType.customer;
    final title =
        '${controller.isSales ? "Select " : ""}${isCustomer ? "Customer" : "Vendor"}';
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBarWidget.empty(
        title: title,
        onChanged: controller.onSearchOrder,
        textCtrl: controller.searchTextCtrl,
        isSearchBar: controller.showSearchBar,
        onClear: () async {
          controller.showSearchBar = false;
         if( controller.searchTextCtrl.text.isNotEmpty){
           controller.searchTextCtrl.clear();
           await controller.fetchData(refresh: true);
         }else {
            controller.setState;
          }
        },
        actions: [
          if (!controller.showSearchBar)
            IconButton(
                onPressed: controller.onOpenSearch,
                iconSize: 20,
                icon: const Icon(CupertinoIcons.search)),
          gapW4,
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: const Divider(
            height: 1,
          ),
        ),
      ),
      floatingActionButton: SafeArea(
        child: FloatingButton(
            label: "New $title",
            onTap: () {
              controller.showDialog();
            },
            visibilityOfFloating: controller.visibilityOfFloating),
      ),
      body: Column(
        children: [
          if (state.isLoading) ClientLoadingList() else ClientListWidget(),
        ],
      ),
    );
  }
}

class ClientListWidget extends ConsumerWidget {
  const ClientListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(clientListControllerProvider.notifier);
    return Expanded(
      flex: 1,
      child:   AppRefreshWidget(
              onRefresh: () async {
                return await controller.fetchData(refresh: true);
              },
              onLoad: () async {
                return await controller.fetchData();
              },
              childBuilder: (context, physics) {
                if( controller.clientList.isEmpty){
                  return AppEmptyWidget(
                    physics: physics, reducePercent: 10,
                  );
                }
                return ListView.separated(
                padding: EdgeInsets.only(
                    left: 12.w, right: 12.w, bottom: 12.h, top: 8.h),
                physics: physics,
                controller: controller.hideButtonController,
                itemCount: controller.clientList.length,
                itemBuilder: (context, index) {
                  final data = controller.clientList[index];
                  return CustomerItemWidget(
                    id: data.id ?? 0,
                    title: data.displayName ?? "-",
                    image: data.logo,
                    onTap: (int id) {
                      controller.detailView(id);
                    },
                    subTitle: data.addressDetail.toCityAddressOne(
                            isShipping: UsersType == UsersType.customer) ??
                        '',
                  );
                },
                separatorBuilder: (context, index) => gapH2,
              );}
            ),
    );
  }
}

class ClientLoadingList extends StatelessWidget {
  const ClientLoadingList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        itemCount: 12,
        itemBuilder: (context, index) {
          return  Container(
          padding: EdgeInsets.symmetric(vertical: 12.0,horizontal: 5),
              decoration:AppUiConstants.salesCardItemDecoration,
              child: LoadingCardShimmerTile());
        },
        separatorBuilder: (context, index) => gapH8,
      ),
    );
  }
}

class LoadingCardShimmerTile extends StatelessWidget {
  const LoadingCardShimmerTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ShimmerWidget.circular(
          height: 44,
          width: 44,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gapH5,
            ShimmerWidget.text(
              height: 20,
              width: 250,
            ),
            const SizedBox(height: 4),
            ShimmerWidget.text(
              height: 20,
              width: 200,
            ),
            gapH2,
          ],
        ),
      ],
    );
  }
}

class CustomerItemWidget extends StatelessWidget {
  const CustomerItemWidget(
      {super.key,
      required this.id,
      required this.image,
      required this.title,
      required this.subTitle,
      required this.onTap});
  final int id;
  final String image;
  final String title;
  final String subTitle;
  final void Function(int id) onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(id),
      child: Container(
        decoration: AppUiConstants.salesCardItemDecoration,
        margin: EdgeInsets.symmetric(vertical: 3.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        child: Row(
          children: [
            NetworkImageLoader(
                borderRadius: BorderRadius.circular(25.r),
                height: 48.h,
                width: 48.w,
                fit: BoxFit.cover,
                useClientPlaceHolder: false,
                image: image),
            gapW15,
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyle.blackFS14FW600,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                gapH3,
                Text(subTitle, style: AppTextStyle.greyFS12FW500),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
