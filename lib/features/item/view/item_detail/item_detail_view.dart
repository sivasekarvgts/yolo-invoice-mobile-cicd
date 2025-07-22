import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yoloworks_invoice/app/common_widgets/app_cupertino_switch_widget.dart';
import 'package:yoloworks_invoice/app/common_widgets/app_loading_widget.dart';
import 'package:yoloworks_invoice/app/common_widgets/shimmer_widget/shimmer_effect.dart';
import 'package:yoloworks_invoice/app/constants/app_ui_constants.dart';
import 'package:yoloworks_invoice/core/extension/currency_extension.dart';
import 'package:yoloworks_invoice/features/item/view/item_detail/item_detail_controller.dart';
import 'package:yoloworks_invoice/features/item/view/new_item/edit_item/item_edit_view.dart';
import 'package:yoloworks_invoice/locator.dart';
import 'package:yoloworks_invoice/router.dart';

import '../../../../app/common_widgets/network_image_loader.dart';
import '../../../../app/constants/app_sizes.dart';
import '../../../../app/styles/colors.dart';
import '../../../../app/styles/text_styles.dart';

class ItemDetailView extends ConsumerStatefulWidget {
  const ItemDetailView({super.key, required this.id});
  final int id;

  @override
  ConsumerState createState() => _ItemDetailViewState();
}

class _ItemDetailViewState extends ConsumerState<ItemDetailView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = ref.read(itemDetailControllerProvider.notifier);
      controller.onInit(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(itemDetailControllerProvider.notifier);
    final state = ref.watch(itemDetailControllerProvider);
    final item = controller.inventoryItemDetails;


    // if(state.isLoading)return Scaffold(body:);
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Back"),
        actions: [
          IgnorePointer(
            ignoring: controller.statusLoading,
            child: Row(
              children: [
                Transform.scale(
                    scale: 0.8,
                    child: AppCupertinoSwitchWidget(
                      isLoading: controller.statusLoading,
                      value: controller.inventoryItemDetails?.status ?? false,
                      onChanged: controller.onActiveInActiveItem,
                    )),
                Text(
                  controller.inventoryItemDetails?.status == true
                      ? 'Active'
                      : "Inactive",
                  style: AppTextStyle.darkBlackFS12FW600,
                ),
              ],
            ),
          ),
          gapW12,
        ],
      ),
      body:state.isLoading? _ItemDetailLoadingWidget(): AppOverlayLoaderWidget(
        isLoading: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              spacing: 10,
              children: [
                SizedBox(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NetworkImageLoader(
                      height: 80.h,
                      width: 60.h,
                      fit: BoxFit.fill,
                      useClientPlaceHolder: false,
                      borderRadius: BorderRadius.circular(8),
                      image: controller.inventoryItemDetails?.image ?? "",
                    ),
                    gapW15,
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          gapH10,
                          Text(
                            controller.inventoryItemDetails?.name ?? "-",
                            style: AppTextStyle.bodyExtraLarge
                                .copyWith(fontWeight: fontWeight600),
                          ),
                          if(controller.inventoryItemDetails?.category!= null)  Text(
                            "${controller.inventoryItemDetails?.category ?? " - "}",
                            style: AppTextStyle.greyFS12FW600,
                          ),
                          Text(
                            "HSN: ${controller.inventoryItemDetails?.hsnCode ?? '-'}${controller.inventoryItemDetails?.category!=null?" | ":"\n"}SKU: ${controller.inventoryItemDetails?.skuCode ?? '-'}"
                           , style: AppTextStyle.greyFS12FW600,
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        navigationService.pushNamed(Routes.itemCreate,
                            arguments: controller.inventoryItemDetails);
                        },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8,0,0,8),
                        child: Text(
                          "Edit",
                          style: AppTextStyle.blueFS12FW500,
                        ),
                      ),
                    ),
                  ],
                ),

                _TitleWithEditButton(title:
                  "Stock Details",
                  onTap: (){
                    controller.inventoryItemDetails?.itemUpdateType =
                        ItemEditType.stockDetail;
                    navigationService.pushNamed(Routes.itemEdit,
                        arguments: controller.inventoryItemDetails);
                  },
                ),
                DividedTextContentWidget(
                  leadingTitle: "STOCK IN HAND",
                  leadingValue: item?.stockOnHandPcs ?? "",
                  trailingTitle: "MINIMUM STOCK",
                  trailingValue: item?.reorderPoint ?? "",
                ),
                Container(
                  padding:  EdgeInsets.all( 10.h),
                  decoration: AppUiConstants.salesCardItemDecoration,
                  child: Column(
                    spacing: 10,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              flex: 0,
                              child: Text("Warehouse",
                                  style: AppTextStyle.greyFS14FW500)),
                          Expanded(
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "Quantity",
                                    style: AppTextStyle.greyFS14FW500,
                                  )))
                        ],
                      ),
                      Divider(
                        height: 1,
                      ),
                      ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: item?.warehouseStocks?.length ?? 0,
                        separatorBuilder: (context, index) => Divider(),
                        itemBuilder: (context, index) {
                          final warehouseStock = item?.warehouseStocks?[index];
                          return _DividedTextRow(
                            title: warehouseStock?.warehouseName ?? "-",
                            value:
                                warehouseStock?.itemDetails?.isNotEmpty == true
                                    ? warehouseStock?.itemDetails?.first ?? "-"
                                    : "-",
                          );
                        },
                      )
                    ],
                  ),
                ),
                _TitleWithEditButton(
                  title: "Sales Details",
                  onTap: null,
                ),
                Container(
                  padding:  EdgeInsets.all( 10.h),

                  decoration: AppUiConstants.salesCardItemDecoration,
                  child: Column(
                    spacing: 10,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              flex: 0,
                              child: Text("Unit",
                                  style: AppTextStyle.greyFS14FW500)),
                          Expanded(
                              flex: 8,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "Conversion Rate",
                                    style: AppTextStyle.greyFS14FW500,
                                  ))),
                          // gapW15,
                          Expanded(
                              flex: 3,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "Price",
                                    style: AppTextStyle.greyFS14FW500,
                                  )))
                        ],
                      ),
                      Divider(
                        height: 1,
                      ),
                      ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: item?.itemUnits?.length ?? 0,
                        separatorBuilder: (context, index) => Divider(),
                        itemBuilder: (context, index) {
                          final uom = item?.itemUnits?[index];
                          return _DividedTextRow(
                              title: uom?.unit ?? "-",
                              value:
                                  "${uom?.quantity ?? ""} (${uom?.baseUnit ?? uom?.unit ?? ""})",
                              value2:
                                  (uom?.sellingPrice).toCurrencyFormatString());
                        },
                      )
                    ],
                  ),
                ),
                _TitleWithEditButton(title: "Tax Preferences",
                  onTap: () {
                  controller.inventoryItemDetails?.itemUpdateType =
                      ItemEditType.taxPreference;
                  navigationService.pushNamed(Routes.itemEdit,
                      arguments: controller.inventoryItemDetails);
                },),
                Container(
                  decoration: AppUiConstants.salesCardItemDecoration,
                    padding: EdgeInsets.all(10.h),
                  child:  (item?.taxPreference == 1)?
                      Column(
                        spacing: 10,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  flex: 0,
                                  child: Text("Tax",
                                      style: AppTextStyle.greyFS14FW500)),
                              Expanded(
                                  flex: 8,
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "GST Rate",
                                        style: AppTextStyle.greyFS14FW500,
                                      ))),
                              Expanded(
                                  flex: 3,
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "CESS Rate",
                                        style: AppTextStyle.greyFS14FW500,
                                      ))),
                            ],
                          ),
                              Divider(height:1,),
                          Row(
                            children: [
                              Expanded(
                                  flex: 0,
                                  child: Text(item?.taxPreferenceName ?? "-",
                                      style: AppTextStyle.blackFS14FW600)),
                              Expanded(
                                  flex: 8,
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "${item?.tax ?? "0"}%",
                                        style: AppTextStyle.blackFS14FW600,
                                      ))),
                              Expanded(
                                  flex: 3,
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "${item?.cessRate ?? "-"}${(item?.cessRate==null)?"":"%"}",
                                        style: AppTextStyle.blackFS14FW600,
                                      ))),
                            ],
                          )
                        ],
                      ):
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 7,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item?.taxPreferenceName ?? "-",
                            style: AppTextStyle.darkBlackFS16FW600.copyWith(fontSize: 18.sp),
                          ),
                          if (item?.taxPreference == 1) Text("GST RATE",style: AppTextStyle.greyFS12FW600,)
                        ],
                      ),
                      if (item?.taxPreference == 2)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Exemption Reason: ",
                              style: AppTextStyle.greyFS12FW600,
                            ),
                            Text(
                              item?.exemptionReasonName ?? "-",
                              style: AppTextStyle.blackFS14FW500,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                _TitleWithEditButton(title: "Account Details",onTap: (){ controller.inventoryItemDetails?.itemUpdateType =
                    ItemEditType.accountDetail;
                navigationService.pushNamed(Routes.itemEdit,
                    arguments: controller.inventoryItemDetails);},),
                Container(
                  padding: EdgeInsets.all(10.h),
                  decoration: AppUiConstants.salesCardItemDecoration,
                  child: Column(
                    spacing: 2,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "SALES ACCOUNT",
                        style: AppTextStyle.greyFS12FW500,
                      ),
                      Text(
                       (item?.salesAccountName ?? "-"),
                        style: AppTextStyle.blackFS14FW500,
                      ),
                      Divider(),
                      Text(
                       "PURCHASE ACCOUNT",
                        style: AppTextStyle.greyFS12FW500,
                      ),
                      Text(
                        (item?.purchaseAccountName ?? "-"),
                        style: AppTextStyle.blackFS14FW500,
                      ),
                      Divider(),
                      Text(
                         "INVENTORY ACCOUNT",
                        style: AppTextStyle.greyFS12FW500,
                      ),
                      Text(
                         (item?.inventoryAccountName ?? "-"),
                        style: AppTextStyle.blackFS14FW500,
                      ),
                    ],
                  ),
                ),
                gapH48,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DividedTextRow extends StatelessWidget {
  const _DividedTextRow(
      {super.key, required this.title, required this.value, this.value2});
  final String title;
  final String value;
  final String? value2;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 0, child: Text(title, style: AppTextStyle.blackFS14FW600)),
        Expanded(
            flex: 7,
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  value,
                  style: AppTextStyle.blackFS14FW600,
                ))),
        if (value2 != null) gapW15,
        if (value2 != null)
          Expanded(
              flex: 2,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    value2!,
                    style: AppTextStyle.blackFS14FW600,
                    maxLines: 1,
                  )))
      ],
    );
  }
}

class _TitleWithEditButton extends StatelessWidget {
  const _TitleWithEditButton({super.key,required this.onTap,required this.title});
  final VoidCallback? onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,style: AppTextStyle.blackFS16FW500,),
        if(onTap!=null)  InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5,5,0,5),
            child: Text(
              "Edit",
              style: AppTextStyle.blueFS12FW500,
            ),
          ),
        ),
      ],
    );
  }
}


class DividedTextContentWidget extends StatelessWidget {
  const DividedTextContentWidget({
    super.key,
    required this.leadingTitle,
    required this.trailingValue,
    required this.trailingTitle,
    required this.leadingValue,
    this.isLoading =false,

  });
  final String leadingTitle;
  final String leadingValue;
  final String trailingTitle;
  final String trailingValue;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 20,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all( 10.h),
            decoration: AppUiConstants.salesCardItemDecoration,
            child: Column(
              children: [
                Text(
                  leadingTitle,
                  style: AppTextStyle.greyFS12FW600,
                ),
               if(isLoading)
                 Padding(
                   padding: const EdgeInsets.only(top:4.0),
                   child: ShimmerWidget.text(height: 24.h, width: 100.w),
                 )else
                 Text(
                  leadingValue,
                  style: AppTextStyle.darkBlackFS16FW600.copyWith(fontSize: 18.sp),

                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all( 10.h),
            decoration: AppUiConstants.salesCardItemDecoration,
            child: Column(
              children: [
                Text(
                  trailingTitle,
                  style: AppTextStyle.greyFS12FW600,
                ),
                if(isLoading)
                  Padding(
                    padding: const EdgeInsets.only(top:4.0),
                    child: ShimmerWidget.text(height: 24.h, width: 100.w),
                  )else
                Text(
                  trailingValue,
                  style: AppTextStyle.darkBlackFS16FW600.copyWith(fontSize: 18.sp),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


class _ItemDetailLoadingWidget extends StatelessWidget {
  const _ItemDetailLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(),
            Row(
              children: [
                NetworkImageLoader(
                  isLoading: true,
                  height: 80.h,
                  width: 60.h,
                  fit: BoxFit.fill,
                  useClientPlaceHolder: false,
                  borderRadius: BorderRadius.circular(8),
                  image:  "",
                ),gapW15,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5,
                  children: [
                    ShimmerWidget.text(height: 18.h, width: 100.w),
                    ShimmerWidget.text(height: 13.h, width: 130.w),
                    ShimmerWidget.text(height: 14.h, width: 150.w)
                  ],
                ),
              ],
            ),
                Text("Stock Details",style:AppTextStyle.greyFS16FW500 ,),
            DividedTextContentWidget(
              leadingTitle: "STOCK IN HAND",
              leadingValue:  "",
              trailingTitle: "MINIMUM STOCK",
              trailingValue: "",
              isLoading: true,
            ),
            Container(
              padding:  EdgeInsets.all( 10.h),
              decoration: AppUiConstants.salesCardItemDecoration,
              child: Column(
                spacing: 10,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Warehouse",style: AppTextStyle.greyFS14FW500,),
                      Text("Quantity",style: AppTextStyle.greyFS14FW500,),
                    ],
                  ),
                  Divider(
                    height: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Default",style: AppTextStyle.blackFS14FW500,),
                     ShimmerWidget.text(height: 14.h, width: 60.w)
                    ],
                  ), Divider(
                    height: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     ShimmerWidget.text(height: 15.h, width: 60.w),
                     ShimmerWidget.text(height: 15.h, width: 60.w)
                    ],
                  ), Divider(
                    height: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     ShimmerWidget.text(height: 15.h, width: 60.w),
                     ShimmerWidget.text(height: 15.h, width: 60.w)
                    ],
                  ),
                ],
              )
            ),
            Text("Sales Details",style:AppTextStyle.greyFS16FW500 ,),
            Container(
                padding:  EdgeInsets.all( 10.h),
                decoration: AppUiConstants.salesCardItemDecoration,
                child: Column(
                  spacing: 10,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            flex:0,
                            child: Text("Unit",style: AppTextStyle.greyFS14FW500,)),
                        Expanded(
                            flex: 8,
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Text("Conversion Rate",style: AppTextStyle.greyFS14FW500,))),
                        Expanded(
                            flex: 3,
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Text("Price",style: AppTextStyle.greyFS14FW500,))),
                      ],
                    ),
                    Divider(
                      height: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerWidget.text(height: 14.h, width: 60.w),
                        ShimmerWidget.text(height: 14.h, width: 60.w),
                        ShimmerWidget.text(height: 14.h, width: 60.w)
                      ],
                    ), Divider(
                      height: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerWidget.text(height: 15.h, width: 60.w),
                        ShimmerWidget.text(height: 15.h, width: 60.w),
                        ShimmerWidget.text(height: 15.h, width: 60.w)
                      ],
                    ),
                  ],
                )
            ),
            Text("Tax Preferences",style:AppTextStyle.greyFS16FW500 ,),
            Container(
              padding:  EdgeInsets.all( 10.h),
              decoration: AppUiConstants.salesCardItemDecoration,
              child: Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerWidget.text(height: 18.h, width: 150.w),
                  ShimmerWidget.text(height: 12.h, width: 50.w),
                ],
              ),
            ),
            Text("Account Details",style:AppTextStyle.greyFS16FW500 ,),
            Container(
              padding:  EdgeInsets.all( 10.h),
              decoration: AppUiConstants.salesCardItemDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  ShimmerWidget.text(height: 14.h, width: 150.w),
                  ShimmerWidget.text(height: 12.h, width: 50.w),
                  Divider(height: 1,), ShimmerWidget.text(height: 18.h, width: 150.w),
                  ShimmerWidget.text(height: 14.h, width: 50.w),
                  Divider(height: 1,),
                  ShimmerWidget.text(height: 14.h, width: 150.w),
                  ShimmerWidget.text(height: 12.h, width: 50.w),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
