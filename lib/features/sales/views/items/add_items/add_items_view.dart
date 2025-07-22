import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:vgts_plugin/form/utils/input_formatter.dart';
import 'package:vgts_plugin/form/vgts_form.dart';

import '../../../../../app/common_widgets/app_outside_focus_remover.dart';
import '../../../../../app/common_widgets/empty_widget/error_text_widget.dart';
import '../../../../../app/styles/colors.dart';
import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/constants/app_sizes.dart';

import '../../../../../app/common_widgets/button.dart';
import '../../../../../app/common_widgets/app_bar_widget.dart';
import '../../../../../app/common_widgets/app_text_field_widgets/sales_text_field_form_widget.dart';
import '../../../models/item_model/item_list_model.dart';
import '../../../models/sales_params_request_model/sales_params_request_model.dart';
import 'add_items_ctrl.dart';

class AddItemsView extends ConsumerStatefulWidget {
  const AddItemsView({super.key, this.addItemRequestModel});
  final AddItemRequestModel? addItemRequestModel;

  @override
  ConsumerState<AddItemsView> createState() => _AddItemsViewState();
}

class _AddItemsViewState extends ConsumerState<AddItemsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = ref.read(addItemCtrlProvider.notifier);
      controller.onInit(widget.addItemRequestModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(addItemCtrlProvider.notifier);
    final state = ref.watch(addItemCtrlProvider);

    return VGTSForm(
      key: controller.addItemsFormKey,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          await controller.showConfirmPop(context);
        },
        child: Scaffold(
          appBar: AppBarWidget.empty(
            title: controller.isEdit ? 'Edit Items' : 'Add Items',
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(1.h),
              child: Divider(height: 1.h),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(height: 1),
                Padding(
                  padding: EdgeInsets.only(
                      left: 16.w, right: 16.w, top: 10.h, bottom: 5.h),
                  child: Row(
                    children: [
                      if (!controller.isEdit)
                        Expanded(
                          child: AppButton.outline(
                            key: Key("save__and_add_new"),
                            'Save & Add New',
                            textStyle: AppTextStyle.blueFS14FW500,
                            height: 35.h,
                            borderRadius: BorderRadius.circular(8.r),
                            onPressed: controller.addNewItem,
                          ),
                        ),
                      if (!controller.isEdit) gapW20,
                      Expanded(
                        child: AppButton(
                            key: controller.isEdit
                                ? Key('update__item')
                                : Key("save__item"),
                            controller.isEdit ? 'Update' : 'Save',
                            height: 35.h,
                            borderRadius: BorderRadius.circular(8.r),
                            onPressed: () => controller.addNewItem(true)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TypeAheadField<ItemDatum>(
                  controller: controller.itemCtrl,
                  suggestionsCallback: (search) async {
                    return await controller.fetchData(search);
                  },
                  loadingBuilder: (context) =>
                      Center(child: CupertinoActivityIndicator(radius: 12.r)),
                  errorBuilder: (context, error) => Center(
                      child: Text(
                    'Error!',
                    style: AppTextStyle.darkBlackFS12FW500,
                  )),
                  emptyBuilder: (context) => Center(
                    child: Text('No items found!',
                        style: AppTextStyle.darkBlackFS12FW500),
                  ),
                  constraints: BoxConstraints(maxHeight: 200.h),
                  builder: (context, ctrl, focusNode) {
                    return SalesTextFieldFormWidget(
                      autoFocus: !controller.isEdit,
                      focusNode: focusNode,
                      ctrl: ctrl,
                      label: 'Item Name',
                      hintText: 'Search by product name or code..',
                    );
                  },
                  itemBuilder: (context, item) {
                    return ListTile(
                      title: Text(item.item ?? item.name ?? '',
                          style: AppTextStyle.darkBlackFS12FW500),
                    );
                  },
                  onSelected: controller.onSelectItem,
                ),
                if (controller.selectedSalesLineItem?.taxId != null ||
                    controller.selectedSalesLineItem?.cessId != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      gapH8,
                      Row(
                        children: [
                          Flexible(
                            child: Material(
                              color: Colors.white,
                              child: InkWell(
                                onTap: controller.openHSNCodeBottomSheet,
                                child: Row(
                                  children: [
                                    Text(
                                      'HSN : ',
                                      style: AppTextStyle.darkBlackFS12FW500,
                                    ),
                                    gapW2,
                                    Flexible(
                                      child: Text(
                                        controller.selectedSalesLineItem
                                                ?.hsnCode ??
                                            '-',
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyle.blueFS12FW500,
                                      ),
                                    ),
                                    gapW4,
                                    Icon(
                                      Icons.edit,
                                      color: AppColors.blueColor,
                                      size: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          gapW4,
                          if (controller.selectedSalesLineItem?.skuCode !=
                              null)
                            Flexible(
                              flex: 2,
                              child: Text(
                                'SKU : ${controller.selectedSalesLineItem?.skuCode}',
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.darkBlackFS12FW500,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                if (controller.selectedSalesLineItem?.isFocItemPresent ==
                    true)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      gapH8,
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            InkWell(
                              onTap: controller.openScheme,
                              child: Text(
                                controller.selectedSalesLineItem
                                                ?.schemeList ==
                                            null ||
                                        controller.selectedSalesLineItem
                                                ?.schemeList?.isEmpty ==
                                            true
                                    ? 'Claim FOC'
                                    : '${controller.selectedSalesLineItem?.schemeLength} FOC Item Claimed',
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.blueFS12FW500,
                              ),
                            ),
                            if (controller.selectedSalesLineItem?.schemeList
                                    ?.isNotEmpty ==
                                true)
                              InkWell(
                                onTap: controller.removeFoc,
                                child: Row(
                                  children: [
                                    gapW4,
                                    const VerticalDivider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(CupertinoIcons.delete,
                                            size: 16,
                                            color: AppColors.redColor),
                                        gapW2,
                                        Text("Remove FOC",
                                            style: AppTextStyle.labelSmall
                                                .copyWith(
                                                    color:
                                                        AppColors.redColor)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                gapH8,
                Row(
                  children: [
                    Expanded(
                      child: SalesTextFieldFormWidget(
                        inputFormatter: [
                          AmountInputFormatter(
                            maxDigits: 7,
                            decimalRange: 2,
                            isSymbol: false,
                          )
                        ],
                        keyboardTextType: TextInputType.number,
                        readOnly: !controller.isItemSelected,
                        label: 'Rate',
                        hintText: 'Rate',
                        ctrl: controller.rateCtrl,
                        onChanged: controller.onPriceChange,
                        borderColor: !controller.isItemSelected
                            ? AppColors.greyColor300
                            : null,
                      ),
                    ),
                    gapW16,
                    Expanded(
                      child: SalesTextFieldFormWidget(
                          inputFormatter: [
                            AmountInputFormatter(
                              maxDigits: 7,
                              decimalRange: 2,
                              isSymbol: false,
                            )
                          ],
                          readOnly: !controller.isItemSelected,
                          label: 'Quantity',
                          hintText: 'Quantity',
                          ctrl: controller.qtyCtrl,
                          borderColor: !controller.isItemSelected
                              ? AppColors.greyColor300
                              : null,
                          keyboardTextType: TextInputType.number,
                          onChanged: controller.onQtyChange,
                          suffixIcon: InkWell(
                            onTap: controller.openItemUnitBottomSheet,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        color: !controller.isItemSelected
                                            ? AppColors.greyColor300
                                            : AppColors.greyColor),
                                    right: BorderSide(
                                        color: !controller.isItemSelected
                                            ? AppColors.greyColor300
                                            : AppColors.greyColor),
                                    bottom: BorderSide(
                                        color: !controller.isItemSelected
                                            ? AppColors.greyColor300
                                            : AppColors.greyColor),
                                  ),
                                  color: AppColors.dividerGreyColor,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      ' ${controller.selectedItemUnit?.unit ?? ''}'
                                          .toUpperCase(),
                                      style: AppTextStyle.darkBlackFS12FW500,
                                    ),
                                    gapW2,
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppColors.darkBlackColor,
                                      size: 18,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
                if (controller.errorMsg != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ErrorTextWidget(errorText: controller.errorMsg),
                    ],
                  ),
                gapH4,
                SalesTextFieldFormWidget(
                  inputFormatter: [
                    PercentageNumbersFormatter(isSymbol: false)
                  ],
                  maxLength: controller.discountType == 1 ? 10 : 5,
                  readOnly: !controller.isItemSelected,
                  ctrl: controller.discountCtrl,
                  label: 'Discount',
                  hintText: 'Discount',
                  keyboardTextType: TextInputType.number,
                  borderColor: !controller.isItemSelected
                      ? AppColors.greyColor300
                      : null,
                  onChanged: controller.onChangeDiscount,
                  suffixIcon: InkWell(
                    onTap: controller.discountBottomSheet,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                                color: !controller.isItemSelected
                                    ? AppColors.greyColor300
                                    : AppColors.greyColor),
                            right: BorderSide(
                                color: !controller.isItemSelected
                                    ? AppColors.greyColor300
                                    : AppColors.greyColor),
                            bottom: BorderSide(
                                color: !controller.isItemSelected
                                    ? AppColors.greyColor300
                                    : AppColors.greyColor),
                          ),
                          color: AppColors.dividerGreyColor,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8.r),
                            bottomRight: Radius.circular(8.r),
                          )),
                      padding: EdgeInsets.symmetric(
                          horizontal: 14.w, vertical: 8.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            controller.discountType == 1 ? ' % ' : ' ₹ ',
                            style: AppTextStyle.darkBlackFS12FW500,
                          ),
                          gapW2,
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.darkBlackColor,
                            size: 18,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                gapH8,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: SalesTextFieldFormWidget(
                      onTap: () => controller.openGSTCessBottomSheet(true),
                      ctrl: TextEditingController(
                          text: controller.selectedTaxItem?.name),
                      readOnly: true,
                      label: 'GST',
                      hintText: 'GST',
                      suffixIcon: const Icon(Icons.keyboard_arrow_down,
                          color: Colors.black, size: 18),
                      borderColor: !controller.isItemSelected
                          ? AppColors.greyColor300
                          : null,
                    )),
                    gapW16,
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SalesTextFieldFormWidget(
                          onTap: () =>
                              controller.openGSTCessBottomSheet(false),
                          ctrl: TextEditingController(
                              text: controller.selectedCessItem?.name),
                          readOnly: true,
                          borderColor: !controller.isItemSelected
                              ? AppColors.greyColor300
                              : null,
                          label: 'CESS',
                          hintText: 'CESS',
                          suffixIcon: const Icon(Icons.keyboard_arrow_down,
                              color: Colors.black, size: 18),
                        ),
                      ],
                    )),
                  ],
                ),
                gapH8,
                SalesTextFieldFormWidget(
                  readOnly: true,
                  ctrl: TextEditingController(
                      text: controller
                          .selectedSalesLineItem?.formattedSubTotal),
                  label: 'Amount',
                  hintText: 'Amount',
                  borderColor: AppColors.greyColor300,
                ),
                gapH8,
                SalesTextFieldFormWidget(
                  readOnly: !controller.isItemSelected,
                  ctrl: controller.noteCtrl,
                  label: 'Notes',
                  hintText: 'Write notes here',
                  maxLines: 3,
                  maxLength: 100,
                  constraints: null,
                  borderColor: !controller.isItemSelected
                      ? AppColors.greyColor300
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
