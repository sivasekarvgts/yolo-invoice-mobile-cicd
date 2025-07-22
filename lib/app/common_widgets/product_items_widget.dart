// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../../routes/routes_constant.dart';
// import '../../../../../common/constant/app_ui_constant.dart';
// import '../../../../../data/models/emp_role_models/invoice/sales_line_item.dart';
//
// import '../../../../themes/app_colors.dart';
// import '../../../../themes/app_text_style.dart';
//
// import 'product_details_widget.dart';
// import '../foc_item/select_foc_iems.dart';
// import '../../../../widgets/app_bottom_widget/app_button_widget.dart';
//
// class ProductItemsWidget extends StatelessWidget {
//   const ProductItemsWidget(
//       {super.key,
//       required this.onAddFoc,
//       required this.onRemoveFoc,
//       required this.isSalesOrder,
//       required this.isGstRegistered,
//       required this.salesLineItemList,
//       required this.onRemoveLineItem,
//       required this.onItemEdit});
//
//   final bool isSalesOrder;
//   final bool isGstRegistered;
//   final List<SalesLineItem> salesLineItemList;
//   final Function(int i) onRemoveFoc;
//   final Function(SalesLineItem item) onRemoveLineItem;
//   final Function(SalesLineItem item, int i) onItemEdit;
//   final Function(SalesLineItem item, List scheme, int i) onAddFoc;
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//         physics: const NeverScrollableScrollPhysics(),
//         padding: EdgeInsets.zero,
//         shrinkWrap: true,
//         itemCount: salesLineItemList.length,
//         separatorBuilder: (context, i) => const SizedBox(height: 15),
//         itemBuilder: (context, i) {
//           final item = salesLineItemList[i];
//           final isScheme = item.schemeList?.isNotEmpty == true;
//           RxBool isSchemeOpen = true.obs;
//           return Container(
//             decoration: AppUiConstant.salesCardDecoration,
//             child: InkWell(
//               onTap: () => onItemEdit(item, i),
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           child: ProductDetailsWidget(
//                             name: item.inventory?.name ?? 'N/A',
//                             skuCode: item.inventory?.skuCode,
//                           ),
//                         ),
//                         InkWell(
//                             onTap: () => onRemoveLineItem(item),
//                             child: const Padding(
//                                 padding: EdgeInsets.all(5),
//                                 child: Icon(CupertinoIcons.delete, size: 15)))
//                       ],
//                     ),
//                     const SizedBox(height: 5),
//                     Wrap(
//                       crossAxisAlignment: WrapCrossAlignment.start,
//                       children: [
//                         if (item.lineItemDisccountValue != null &&
//                             item.lineItemDisccountValue != '0')
//                           Row(
//                             children: [
//                               Text(item.formattedPrice,
//                                   style: AppTextStyle.blackF14W500TextStyle
//                                       .copyWith(
//                                           decorationColor: Colors.black,
//                                           decorationThickness: 1.5,
//                                           decoration:
//                                               TextDecoration.lineThrough)),
//                               const SizedBox(width: 4),
//                             ],
//                           ),
//                         Text(
//                             item.lineItemDiscountType != null
//                                 ? item.singleItemPrice
//                                 : item.formattedPrice,
//                             style: AppTextStyle.blackF14W500TextStyle),
//                         const SizedBox(width: 4),
//                         if (isGstRegistered)
//                           Text(
//                               '(${item.inventory?.taxValue}% GST ${(item.inventory?.cessRateName != null) ? '& ${item.inventory?.cessRateName}% CESS' : ''})',
//                               style: AppTextStyle.blackF12W400TextStyle),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     const Divider(),
//                     IntrinsicHeight(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               const Icon(Icons.unfold_more_outlined, size: 18),
//                               const SizedBox(width: 5),
//                               Text(
//                                   '${item.qty?.toInt()} ${item.unitName?.toUpperCase()}',
//                                   style: context.textTheme.headlineSmall),
//                               const SizedBox(width: 5),
//                               const VerticalDivider(),
//                             ],
//                           ),
//                           Text(item.formattedSubTotal,
//                               style: context.textTheme.headlineSmall)
//                         ],
//                       ),
//                     ),
//                     if (item.isFocItemPersent == true)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Divider(),
//                           if (isScheme)
//                             Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(vertical: 4.0),
//                               child: Obx(() => Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       InkWell(
//                                         onTap: () => isSchemeOpen.value =
//                                             !isSchemeOpen.value,
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Text(
//                                                 '${item.schemeList?.length} FOC ${item.schemeList!.length > 1 ? 'Items' : 'Item'}',
//                                                 style: AppTextStyle
//                                                     .blackF12W600TextStyle),
//                                             Icon(isSchemeOpen.value
//                                                 ? Icons.keyboard_arrow_up
//                                                 : Icons.keyboard_arrow_down)
//                                           ],
//                                         ),
//                                       ),
//                                       if (isScheme && isSchemeOpen.value)
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             const SizedBox(height: 8),
//                                             SchemeListWidget(
//                                                 height: 50,
//                                                 width: 50,
//                                                 isBillDetials: true,
//                                                 scheme: item.schemeList!),
//                                           ],
//                                         )
//                                     ],
//                                   )),
//                             ),
//                           AppButtonWidget.outline(
//                             onPressed: () async {
//                               if (isScheme) {
//                                 onRemoveFoc(i);
//                                 return;
//                               }
//                               final res = await Get.toNamed(
//                                   RoutesConstant.focItems,
//                                   arguments: {
//                                     'itemQty': item.qty,
//                                     'isSalesOrder': isSalesOrder,
//                                     'itemId': item.itemId,
//                                     'itemUnitId': item.unitId
//                                   });
//                               if (res != null) {
//                                 onAddFoc(item, res as List, i);
//                               }
//                             },
//                             buttonStyle: isScheme
//                                 ? AppTextStyle.blackF14W500TextStyle
//                                 : AppTextStyle.blueF14W500TextStyle,
//                             borderColor:
//                                 isScheme ? Colors.black : AppColors.blueColor,
//                             title: isScheme ? 'Remove FOC' : 'Claim FOC',
//                             borderRadius: 8,
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 12),
//                           ),
//                         ],
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         });
//   }
// }
//
// class SchemeListWidget extends StatelessWidget {
//   const SchemeListWidget(
//       {super.key,
//       required this.scheme,
//       this.height = 100,
//       this.width = 75,
//       this.isBillDetials = false});
//   final List scheme;
//   final bool isBillDetials;
//   final double width;
//   final double height;
//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//         padding: EdgeInsets.zero,
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemBuilder: (_, i) => ItemWidget(
//               item: scheme[i],
//               isSelected: false,
//               height: height,
//               width: width,
//               isBillDetials: isBillDetials,
//             ),
//         separatorBuilder: (_, i) => const Divider(),
//         itemCount: scheme.length);
//   }
// }
