import 'package:flutter/material.dart';
import 'package:yoloworks_invoice/core/extension/currency_extension.dart';

import '../../../../app/constants/app_sizes.dart';
import '../../../../app/styles/text_styles.dart';
import '../../models/item_model/sales_line_item.dart';

class ProductItemsWidget extends StatelessWidget {
  const ProductItemsWidget(
      {super.key,
      required this.onAddFoc,
      required this.onRemoveFoc,
      required this.isSalesOrder,
      required this.isGstRegistered,
      required this.salesLineItemList,
      required this.onRemoveLineItem,
      required this.onItemEdit});

  final bool isSalesOrder;
  final bool isGstRegistered;
  final List<SalesLineItem> salesLineItemList;
  final void Function(int i) onRemoveFoc;
  final void Function(SalesLineItem item) onRemoveLineItem;
  final void Function(SalesLineItem item, int i) onItemEdit;
  final void Function(SalesLineItem item, List scheme, int i) onAddFoc;

  @override
  Widget build(BuildContext context) {
    //  final textfieldWidth = (MediaQuery.of(context).size.width / 4);
    // final Map<String, List<SalesLineItem>> groupedItems = {};

    // for (var item in salesLineItemList) {
    //   groupedItems.putIfAbsent(item.itemId.toString(), () => []).add(item);
    // }
    // final entriesList = groupedItems.entries.toList();

    // return ListView.builder(
    //   shrinkWrap: true,
    //   padding: EdgeInsets.only(bottom: 5),
    //   itemCount: entriesList.length,
    //   physics: const NeverScrollableScrollPhysics(),
    //   itemBuilder: (_, index) {
    //     final item = entriesList[index].value;
    //     return Container(
    //       decoration: BoxDecoration(
    //           color: Colors.white,
    //           border: Border.all(
    //               color: AppColors.dividerGreyColor
    //               ,width: 1
    //           )
    //       ),
    //       padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Row(
    //             crossAxisAlignment: CrossAxisAlignment.end,
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               Expanded(
    //                 child: Text(item?.first.inventory?.item ?? '',
    //                     overflow: TextOverflow.ellipsis,
    //                     style: AppTextStyle.darkBlackFS12FW500.copyWith(fontSize: AppFontSize.dp13)),
    //               ),
    //               if (true == true)
    //                 InkWell(
    //                   onTap: () {
    //                     // onOpenScheme!(index);
    //                   },
    //                   child: Text(
    //                     'View Offers',
    //                     overflow: TextOverflow.ellipsis,
    //                     style: AppTextStyle.blueFS12FW500,
    //                   ),
    //                 ),
    //             ],
    //           ),
    //           if (item?.first.inventory?.skuCode != null) const SizedBox(height: 4),
    //           if (item?.first.inventory?.skuCode != null)
    //             Text(item!.first.inventory!.skuCode!,
    //                 style: AppTextStyle.greyFS10FW600),
    //           if (item != null)
    //             ListView.separated(
    //                 shrinkWrap: true,
    //                 physics: const NeverScrollableScrollPhysics(),
    //                 padding: const EdgeInsets.only(top: 8, bottom: 4),
    //                 itemCount: item.length??0,
    //                 itemBuilder: (_, i) {
    //                   final itemUnit = item[i];
    //                   // final schemeRuleList = itemUnit.schemeList
    //                   //     ?.map((n) => n.schemeRule ?? [])
    //                   //     .expand((m) => m)
    //                   //     .toList() ??
    //                   //     [];
    //                   // final schemeAppliedList = schemeRuleList
    //                   //     .map((q) => q.schemeApplied ?? [])
    //                   //     .expand((m) => m)
    //                   //     .toList();
    //                   return Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Row(
    //                         mainAxisAlignment:
    //                         MainAxisAlignment.spaceBetween,
    //                         children: [
    //                           InkWell(
    //                             onTap: () {
    //                               onRemoveLineItem(itemUnit);
    //                             },
    //                             child: Padding(
    //                               padding: const EdgeInsets.only(
    //                                   top: 8, bottom: 5, right: 3),
    //                               child: Icon(
    //                                 Icons.close,
    //                                 size: 20,
    //                                 color: AppColors.redColor,
    //                               ),
    //                             ),
    //                           ),
    //                           const SizedBox(width: 4),
    //                           Expanded(
    //                             child: Row(
    //                               mainAxisAlignment:
    //                               MainAxisAlignment.spaceBetween,
    //                               children: [
    //                                 AppTextFieldWidget(
    //                                   maxLines: 1,
    //                                   textFieldPadding: 0,
    //                                   ctrl: itemUnit.qtyCtrlValue,
    //                                   focusNode: itemUnit.qtyFocusNode,
    //                                   maxLength: 10,
    //                                   inputFormatter: [
    //                                     AmountInputFormatter(
    //                                       maxDigits: 7,
    //                                       decimalRange: 2,
    //                                       isSymbol: false,
    //                                     )
    //                                   ],
    //                                   autoFocus: false,
    //                                   constraints: BoxConstraints(
    //                                       maxWidth: textfieldWidth,
    //                                       maxHeight: 30),
    //                                   contentPadding:
    //                                   const EdgeInsets.all(5),
    //                                   borderColor:
    //                                   AppColors.greyColor,
    //                                   borderRadius: 8,
    //                                   keyboardTextType:
    //                                   TextInputType.number,
    //                                   style: AppTextStyle
    //                                       .darkBlackFS12FW500,
    //                                   textAlign: TextAlign.end,
    //                                   onChanged: (value)
    //                                         {
    //                                           // onChangeSalesItemUnit(
    //                                         //     value: value,
    //                                         //     itemId: itemUnit.itemId!,
    //                                         //     itemUnitId:
    //                                         //     itemUnit.itemUnitId!),
    //                                          },
    //                                   onTap: () {
    //                                     // onRemoveOverlay!();
    //                                   },
    //                                   onEditingComplete: () {},
    //                                   onFieldSubmitted: (value) {},
    //                                   errorStyle: AppTextStyle
    //                                       .blueFS10FW700,
    //                                   suffixIcon: Container(
    //                                     decoration: BoxDecoration(
    //                                         border: Border(
    //                                           top: BorderSide(
    //                                               color: AppColors
    //                                                   .greyColor),
    //                                           right: BorderSide(
    //                                               color: AppColors
    //                                                   .greyColor),
    //                                           bottom: BorderSide(
    //                                               color: AppColors
    //                                                   .greyColor),
    //                                         ),
    //                                         color: AppColors
    //                                             .dividerGreyColor,
    //                                         borderRadius:
    //                                         BorderRadius.only(
    //                                           topRight:
    //                                           Radius.circular(8),
    //                                           bottomRight:
    //                                           Radius.circular(8),
    //                                         )),
    //                                     child: Padding(
    //                                       padding: const EdgeInsets
    //                                           .symmetric(
    //                                           horizontal: 2,
    //                                           vertical: 4),
    //                                       child: Text(
    //                                         itemUnit.unitName
    //                                             ?.capitalizeFirst ??
    //                                             '',
    //                                         style: AppTextStyle
    //                                             .darkBlackFS12FW500,
    //                                       ),
    //                                     ),
    //                                   ),
    //                                 ),
    //                                 const SizedBox(width: 8),
    //                                 AppTextFieldWidget(
    //                                   maxLines: 1,
    //                                   textFieldPadding: 0,
    //                                   ctrl: TextEditingController(
    //                                       // TODO Formatted price
    //                                       text: itemUnit.formattedPrice.toString()
    //                                   ),
    //                                   isEnabled: false,
    //                                   autoFocus: false,
    //                                   constraints: BoxConstraints(
    //                                       maxWidth: textfieldWidth,
    //                                       maxHeight: 30),
    //                                   contentPadding:
    //                                   const EdgeInsets.all(5),
    //                                   borderColor:
    //                                   AppColors.greyColor,
    //                                   borderRadius: 8,
    //                                   // TODO color medium grey
    //                                   hintStyle: AppTextStyle
    //                                       .greyFS10FW600.copyWith(color: AppColors.greyColor300),
    //                                   hintText: 'Price',
    //                                   style: AppTextStyle
    //                                       .darkBlackFS12FW500,
    //                                   errorStyle: AppTextStyle
    //                                       .redFS12FW500,
    //                                   textAlign: TextAlign.end,
    //                                 ),
    //                                 const SizedBox(width: 8),
    //                                 AppTextFieldWidget(
    //                                   maxLines: 1,
    //                                   textFieldPadding: 0,
    //                                   ctrl: itemUnit.discountCtrlValue,
    //                                   focusNode:
    //                                   itemUnit.discountFocusNode,
    //                                   inputFormatter:
    //                                    itemUnit.lineItemDiscountType == "Amount"
    //                                       ? [
    //                                     AmountInputFormatter(
    //                                         isSymbol: false,
    //                                         price: itemUnit
    //                                             .priceQtyValue)
    //                                   ]
    //                                       : [
    //                                     PercentageNumbersFormatter(
    //                                         isSymbol: false,
    //                                         price: itemUnit
    //                                             .priceQtyValue)
    //                                   ],
    //                                   maxLength:
    //                                   itemUnit.lineItemDiscountType == "Amount"
    //                                       ? 10
    //                                       :
    //                                   5,
    //                                   autoFocus: false,
    //                                   keyboardTextType:
    //                                   TextInputType.number,
    //                                   autovalidateMode: AutovalidateMode
    //                                       .onUserInteraction,
    //                                   constraints: BoxConstraints(
    //                                       maxWidth: textfieldWidth,
    //                                       maxHeight: 30),
    //                                   contentPadding:
    //                                   const EdgeInsets.all(5),
    //                                   borderColor:
    //                                   AppColors.greyColor,
    //                                   borderRadius: 8,
    //                                   // TODO Color
    //                                   hintStyle: AppTextStyle
    //                                       .greyFS10FW600.copyWith(color: AppColors.greyColor300),
    //                                   hintText: 'Discount',
    //                                   style: AppTextStyle
    //                                       .darkBlackFS12FW500,
    //                                   errorStyle: AppTextStyle
    //                                       .redFS12FW500,
    //                                   textAlign: TextAlign.end,
    //                                   onChanged: (value) {
    //                                     // onItemDiscountChanged!(
    //                                     //     value, index, i, true);
    //                                   },
    //                                   onTap: () {
    //                                     // onDiscountTap!(index, i);
    //                                   },
    //                                   onEditingComplete: () {},
    //                                   onFieldSubmitted: (value) {},
    //                                   prefixIconConstraints:
    //                                   BoxConstraints(
    //                                     minWidth: 22,
    //                                     minHeight: 22,
    //                                   ),
    //                                   prefixIcon:
    //                                   DiscountPercentageWidget(
    //                                       isPercentage:
    //                                       itemUnit.lineItemDiscountType!="Amount",
    //                                       onTap: (value) {

    //                                         // onItemPercent(
    //                                         //     index, i, !value);
    //                                       }),
    //                                 ),
    //                               ],
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                       // if (schemeAppliedList.isNotEmpty)
    //                         // Column(
    //                         //     crossAxisAlignment:
    //                         //     CrossAxisAlignment.start,
    //                         //     children: schemeAppliedList.map((e) {
    //                         //       final schemeRule =
    //                         //       schemeRuleList.singleWhere(
    //                         //               (r) => r.id == e.schemeRule,
    //                         //           orElse: () => SchemeRule());
    //                         //       return Padding(
    //                         //         padding:
    //                         //         const EdgeInsets.only(top: 4),
    //                         //         child: Row(
    //                         //           children: [
    //                         //             Material(
    //                         //               color: Colors.white,
    //                         //               child: InkWell(
    //                         //                 // onTap: () =>
    //                         //                 //     onRemoveScheme!(
    //                         //                 //         schemeRule.id!),
    //                         //                 child: Padding(
    //                         //                   padding: const EdgeInsets
    //                         //                       .symmetric(
    //                         //                       vertical: 2),
    //                         //                   child: Icon(
    //                         //                     Icons.close,
    //                         //                     size: 16,
    //                         //                     color: AppColors
    //                         //                         .ferrariRedColor,
    //                         //                   ),
    //                         //                 ),
    //                         //               ),
    //                         //             ),
    //                         //             const SizedBox(width: 6),
    //                         //             SvgPicture.asset(
    //                         //                 'assets/svgs/scheme.svg',
    //                         //                 width: 12,
    //                         //                 height: 12,
    //                         //                 color: AppColors
    //                         //                     .greyColor),
    //                         //             const SizedBox(width: 3),
    //                         //             Expanded(
    //                         //               child: Text(
    //                         //                 'FREE ${AppConstants.removeZero(e.value ?? 0.0)} ${e.unitName?.capitalizeFirst} ${e.itemName?.capitalizeFirst}',
    //                         //                 overflow:
    //                         //                 TextOverflow.ellipsis,
    //                         //                 style: AppTextStyle
    //                         //                     .darkGrassGreenF12W600Style,
    //                         //               ),
    //                         //             ),
    //                         //           ],
    //                         //         ),
    //                         //       );
    //                         //     }).toList()),
    //                       // if (itemUnit?.discountErrorMsg != null)
    //                       //   Padding(
    //                       //     padding: const EdgeInsets.symmetric(
    //                       //         vertical: 2, horizontal: 4),
    //                       //     child: Text(
    //                       //       '${itemUnit.discountErrorMsg}',
    //                       //       textAlign: TextAlign.left,
    //                       //       style:
    //                       //       AppTextStyle.redFS12FW500,
    //                       //     ),
    //                       //   ),
    //                       // if (itemUnit.errorMsg != null)
    //                       //   Padding(
    //                       //     padding: const EdgeInsets.symmetric(
    //                       //         vertical: 2, horizontal: 4),
    //                       //     child: Text(
    //                       //       '${itemUnit.errorMsg}',
    //                       //       textAlign: TextAlign.left,
    //                       //       style:
    //                       //       AppTextStyle.redFS12FW500,
    //                       //     ),
    //                       //   )
    //                     ],
    //                   );
    //                 },
    //                 separatorBuilder: (_, i) => Padding(
    //                     padding:
    //                     const EdgeInsets.symmetric(vertical: 2),
    //                     child: Divider(color: AppColors.greyColor300,)),),
    //         ],
    //       ),
    //     );
    //   },
    // );

    return SizedBox();
  }
}

class SchemeListWidget extends StatelessWidget {
  const SchemeListWidget(
      {super.key,
      required this.scheme,
      this.height = 100,
      this.width = 75,
      this.isBillDetials = false});
  final List scheme;
  final bool isBillDetials;
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, i) => ItemWidget(
              item: scheme[i],
              isSelected: false,
              height: height,
              width: width,
              isBillDetials: isBillDetials,
            ),
        separatorBuilder: (_, i) => const Divider(),
        itemCount: scheme.length);
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget(
      {super.key,
      required this.item,
      required this.isSelected,
      this.height = 100,
      this.width = 75,
      this.isShowImage = false,
      this.isBillDetials = false});
  final dynamic item;
  final bool isBillDetials;
  final bool isShowImage;
  final double height;
  final double width;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item['item'].toString(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.darkBlackFS14FW500),
            const SizedBox(height: 2),
            if (item['sku_code'] != null)
              Text('SKU - ${item['sku_code']}',
                  style: AppTextStyle.greyFS12FW500),
            gapH5,
            Text(
                'Free: ${item['value'] == null ? 0 : double.parse(item['value'].toString()).removeZero()} ${item['unit']}',
                style: AppTextStyle.darkBlackFS14FW500),
          ],
        ))
      ],
    );
  }
}
