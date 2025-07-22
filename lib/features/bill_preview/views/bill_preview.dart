import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yoloworks_invoice/app/common_widgets/floating_button.dart';
import 'package:yoloworks_invoice/app/common_widgets/network_image_loader.dart';
import 'package:yoloworks_invoice/app/constants/app_ui_constants.dart';
import 'package:yoloworks_invoice/core/extension/address_extenstion.dart';
import 'package:yoloworks_invoice/core/extension/color_extension.dart';
import 'package:yoloworks_invoice/core/extension/currency_extension.dart';
import 'package:yoloworks_invoice/features/bill_preview/views/widgets/sales_bill_summary_tab.dart';

import '../../../app/common_widgets/app_bar_widget.dart';
import '../../../app/common_widgets/app_loading_widget.dart';
import '../../../app/common_widgets/app_popup_menu_button_widget.dart';
import '../../../app/common_widgets/brief_tile.dart';
import '../../../app/common_widgets/shimmer_widget/shimmer_effect.dart';
import '../../../app/common_widgets/tab_bar_widget.dart';
import '../../../app/constants/app_sizes.dart';
import '../../../app/constants/images.dart';
import '../../../app/styles/colors.dart';
import '../../../app/styles/text_styles.dart';
import '../../../core/enums/user_type.dart';
import '../../../services/download_service/file_download_service.dart';
import '../../sales/views/widgets/product_details_widget.dart';
import '../../sales/views/widgets/status_widget.dart';
import '../models/bill_preview_model.dart';
import 'bill_preview_ctrl.dart';

class BillPreview extends ConsumerStatefulWidget {
  const BillPreview({super.key, required this.billPreviewArgs});

  final BillPreviewArgs billPreviewArgs;

  @override
  ConsumerState<BillPreview> createState() => _BillPreviewState();
}

class _BillPreviewState extends ConsumerState<BillPreview>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = ref.read(billPreviewCtrlProvider.notifier);
      controller.onInit(widget.billPreviewArgs, this);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(billPreviewCtrlProvider.notifier);
    final state = ref.watch(billPreviewCtrlProvider);
    final isLoading = state.isLoading;

    final billPreviewModel = controller.billPreviewModel;

    return AppOverlayLoaderWidget(
      isLoading: controller.loading,
      child: Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          appBar: AppBarWidget.empty(
            title: '#${billPreviewModel?.orderNumber ?? ""}',
            actions: [
              if (!isLoading)
                Center(
                    child: StatusWidget(
                  status: billPreviewModel?.orderStatusName ?? "",
                  color:
                      billPreviewModel?.colorValue ?? AppColors.lightGreenColor,
                  textStyle: AppTextStyle.darkBlackFS12FW500,
                )),
              if (!isLoading &&
                  !(controller.isSalesInvoice || controller.isPurchaseInvoice))
                InkWell(
                    onTap: controller.onConvert,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: Icon(Icons.swap_horiz),
                    )),

              // AppPopupMenuButtonWidget(
              //     icon: Icon(CupertinoIcons.add_circled),
              //     menuItems: [
              //       PopupMenuItem(
              //         value: "add_payment",
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(
              //               "Add Payment",
              //               style: AppTextStyle.blackFS14FW500,
              //             ),
              //             Icon(
              //               Icons.currency_rupee,
              //               size: 20,
              //               // color: AppColors.redColor,
              //             ),
              //           ],
              //         ),
              //       ),
              //       PopupMenuItem(
              //         value: "add_credit",
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(
              //               "Add Credit",
              //               style: AppTextStyle.blackFS14FW500,
              //             ),
              //             Icon(
              //               Icons.edit_outlined,
              //               size: 20,
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //     onSelected: (value) async {
              //       if (value == 'add_payment') {
              //         controller.navigateToPaymentCreate();
              //         return;
              //       }
              //       if (value == 'add_credit') {
              //         controller.onEdit();
              //         return;
              //       }
              //     }),
              AppPopupMenuButtonWidget(
                  menuItems: [
                    PopupMenuItem(
                      value: "delete",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Delete",
                            style: AppTextStyle.blackFS14FW500,
                          ),
                          Icon(
                            CupertinoIcons.delete,
                            size: 20,
                            color: AppColors.redColor,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: "edit",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Edit",
                            style: AppTextStyle.blackFS14FW500,
                          ),
                          Icon(
                            Icons.edit_outlined,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: "preview",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Preview",
                            style: AppTextStyle.blackFS14FW500,
                          ),
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) async {
                    if (value == 'delete') {
                      controller.deleteOrderPopup();
                      return;
                    }
                    if (value == 'edit') {
                      controller.onEdit();
                      return;
                    }
                    if (value == 'preview') {
                      int billType = 0;
                      if (controller.billPreviewArgs?.isSalesInvoice == true) {
                        billType = 1;
                      } else if (controller
                              .billPreviewArgs?.isPurchaseInvoice ==
                          true) {
                        billType = 2;
                      } else if (controller.billPreviewArgs?.isPurchaseOrder ==
                          true) {
                        billType = 4;
                      } else {
                        billType = 3;
                      }
                      DioFileDownloadService().downloadFile(
                        billPreviewModel?.id ?? 0,
                        billType: billType,
                        billPreviewModel?.orderNumber ?? "Invoice",
                      );
                      return;
                    }
                  }),
              gapW12,
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0),
                child:    Divider(
                    height: 1,
                  ),

            ),
          ),

          floatingActionButton:controller.isAddPayment  ?FloatingButton(
            visibilityOfFloating: true,
            icon: (Icons.add_card_rounded),
            onTap: controller.showDialog,
          ):null,
          body: isLoading
              ? _BillPreviewLoading()
              : NestedScrollView(
                  controller: controller.scrollController,
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return Column(
                              children: [
                                BriefTile(
                                  isLoading: isLoading,
                                  image:billPreviewModel?.logo ,
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                                  title: billPreviewModel?.client ??
                                      billPreviewModel?.vendor ??
                                      "",

                                  subTitle: billPreviewModel?.addressDetail?.inFullAddress(
                                      isShipping: UsersType == UsersType.customer) ??
                                      '',
                                  trailing: SizedBox(),
                                  hideDivider: true,
                                ),
                                gapH10,
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: InkWell(
                                    onTap: controller.openItem,
                                    child: Row(children: [
                                      Text(
                                          "${(billPreviewModel?.itemDetails?.length ?? 0) <= 1 ? 'ITEM' : 'ITEMS'} (${billPreviewModel?.itemDetails?.length ?? 0})",
                                          style:
                                              AppTextStyle.darkBlackFS14FW600),
                                      const Spacer(),
                                      Icon(
                                          controller.isOpen
                                              ? Icons.keyboard_arrow_up
                                              : Icons.keyboard_arrow_down,
                                          size: 20),
                                      gapW6,
                                    ]),
                                  ),
                                ),gapH12,
                                if (controller.isOpen)
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB( 12, 0, 12, 12),
                                    child: _BillItemListWidget(
                                      billPreviewModel?.itemDetails ?? [],
                                      (i) => controller.openFOCItem(i),
                                    ),
                                  ),
                              ],
                            );
                          },
                          childCount: 1,
                        ),
                      ),
                    ];
                  },
                  body: (controller.isSalesInvoice ||
                              controller.isPurchaseInvoice) &&
                          !controller.tabLoading &&
                          controller.tabs.length > 1
                      ? Column(
                          children: [
                            TabBarHeaderWidget(
                              tabController: controller.tabController!,
                              tabs: controller.tabs,
                              color: Colors.white,
                            ),
                            Expanded(
                              child: TabBarBodyWidget(
                                tabController: controller.tabController!,
                                tabs: controller.tabs,
                                needScroll: true,
                              ),
                            ),
                          ],
                        )
                      : SingleChildScrollView(
                          physics: ClampingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              gapH10,
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 3.h),
                                child: Text(
                                  "Bill Summary",
                                  style: AppTextStyle.darkBlackFS12FW500,
                                ),
                              ),
                              BillSummaryTab(),
                            ],
                          ),
                        ),
                )),
    );
  }
}

class _BillItemListWidget extends StatelessWidget {
  const _BillItemListWidget(this.itemDetails, this.openFOCItem);

  final List<ItemDetail> itemDetails;
  final Function(int i) openFOCItem;

  @override
  Widget build(BuildContext context) {
    final Map<String, List<ItemDetail>> groupedItems = {};

    for (var item in itemDetails) {
      groupedItems.putIfAbsent(item.itemId.toString(), () => []).add(item);
    }
    final entriesList = groupedItems.entries.toList();
    return ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: entriesList.length,
        separatorBuilder: (context, index) => gapH8,
        itemBuilder: (context, i) {
          final item = entriesList[i];
          return Container(
            padding: EdgeInsets.all(12),
            decoration: AppUiConstants.salesCardItemDecoration,
            // BoxDecoration(
            //     color: AppColors.white,
            //     border:
            //         Border.all(color: AppColors.dividerGreyColor, width: 1)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductDetailsWidget(
                  isShowNameOnly: false,
                  name: item.value.first.item!,
                  isSKU: (item.value.first.skuCode ?? "").isNotEmpty,
                  isHSN: (item.value.first.hsnCode ?? "").isNotEmpty,
                  gstValue: item.value.first.hsnCode,
                  skuCode: item.value.first.skuCode,
                  hsnCode: item.value.first.hsnCode,
                ),
                Divider(),
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: item.value.length,
                  separatorBuilder: (context, index) => gapH5,
                  itemBuilder: (context, index) {
                    final ItemDetail itemData = item.value[index];
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "${(itemData.quantity ?? 0).removeZero()} ${itemData.unit} x ${(itemData.rate ?? 0.0).toCurrencyFormatString()}",
                                  style: AppTextStyle.greyFS14FW600,
                                ),
                              )),
                              Expanded(
                                  flex: 0,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: ((itemData.discountAmount ?? 0.0) >
                                            0)
                                        ? Text(
                                            "-${itemData.isDiscountPercentage == true ? "${itemData.discount}%" : itemData.discountAmount}",
                                            style:
                                                AppTextStyle.greyFS14FW600,
                                          )
                                        : SizedBox(),
                                  )),
                              Expanded(
                                  child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "${(itemData.totalAmount ?? 0.0).toCurrencyFormatString()}",
                                  style: AppTextStyle.darkBlackFS14FW500,
                                ),
                              )),
                            ],
                          ),
                        ),
                        if (itemData.scheme?.isNotEmpty == true)
                          Row(
                            children: [
                              SvgPicture.asset(
                                Svgs.scheme,
                                colorFilter: ColorFilter.mode(
                                    AppColors.greenColor, BlendMode.srcIn),
                              ),
                              gapW2,
                              ...itemData.scheme!.map((i) => Text(
                                    ' ${itemData.unit} - ${i.value?.removeZero()} ${i.unit} ${i.item}'
                                        .toUpperCase(),
                                    style: AppTextStyle.darkGrassGreenF11W600,
                                  )),
                            ],
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        });
  }
}

class _BillPreviewLoading extends StatelessWidget {
  const _BillPreviewLoading();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BriefTile(title: "",isLoading: true,),
          gapH8,
          Row(children: [
            Text("ITEMS", style: AppTextStyle.greyFS14FW500),
            const Spacer(),
            Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20),
            gapW6,
          ]),
          gapH5,
          Divider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerWidget.text(
                height: 15,
                width: 150,
              ),
              gapH4,
              ShimmerWidget.text(
                height: 15,
                width: 120,
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(),
          ),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerWidget.text(
                      height: 15,
                      width: 100,
                    ),
                    gapH8,
                    ShimmerWidget.text(
                      height: 15,
                      width: 70,
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerWidget.text(
                      height: 15,
                      width: 100,
                    ),
                    gapH8,
                    ShimmerWidget.text(
                      height: 15,
                      width: 70,
                    )
                  ],
                ),
              ],
            ),
          ),
          gapH5,
          Divider(),
          gapH5,
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerWidget.text(
                      height: 15,
                      width: 100,
                    ),
                    gapH8,
                    ShimmerWidget.text(
                      height: 15,
                      width: 70,
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerWidget.text(
                      height: 15,
                      width: 100,
                    ),
                    gapH8,
                    ShimmerWidget.text(
                      height: 15,
                      width: 70,
                    )
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(
              color: AppColors.outlineGreyColor,
            ),
          ),
          ShimmerWidget.text(
            height: 15,
          ),
          gapH5,
          ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerWidget.text(
                        height: 20,
                        width: 100,
                      ),
                      ShimmerWidget.text(
                        height: 20,
                        width: 120,
                      )
                    ],
                  ),
                );
              }),
          gapH15,
          const Divider(),
          gapH4,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerWidget.text(
                height: 20,
                width: 100,
              ),
              ShimmerWidget.text(
                height: 20,
                width: 100,
              ),
            ],
          ),
          gapH4,
          Divider(),
          gapH10,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerWidget.text(
                height: 20,
                width: 100,
              ),
              gapH12,
              ShimmerWidget.text(
                height: 100,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class BillPreviewArgs {
  const BillPreviewArgs({
    this.orderId,
    this.invoiceId,
    this.isSalesOrder = false,
    this.isSalesInvoice = false,
    this.isPurchaseOrder = false,
    this.isPurchaseInvoice = false,
  });

  final int? orderId;
  final int? invoiceId;
  final bool isSalesOrder;
  final bool isSalesInvoice;
  final bool isPurchaseOrder;
  final bool isPurchaseInvoice;
}
