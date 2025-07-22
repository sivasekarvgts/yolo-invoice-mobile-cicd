import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yoloworks_invoice/app/constants/images.dart';
import 'package:yoloworks_invoice/app/styles/colors.dart';
import 'package:yoloworks_invoice/features/transactions/view/transactions_controller.dart';
import 'package:yoloworks_invoice/locator.dart';
import 'package:yoloworks_invoice/router.dart';

import '../../../app/constants/app_sizes.dart';
import '../../../app/constants/app_ui_constants.dart';
import '../../../app/styles/text_styles.dart';

class TransactionsView extends ConsumerStatefulWidget {
  const TransactionsView({super.key});

  @override
  ConsumerState createState() => _TransactionsViewState();
}

class _TransactionsViewState extends ConsumerState<TransactionsView> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(transactionsControllerProvider.notifier);
    final state = ref.watch(transactionsControllerProvider);
    final isLoading = state.isLoading;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text("Transactions"),
        actions: [Icon(CupertinoIcons.bell),gapW15],
        bottom: PreferredSize(
            preferredSize: Size.zero,
            child: Divider(height: 1,)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.fromLTRB( 12.w,16.w,12.w,110.h,),
          child: Column(
            spacing: 18.h,
            children: [
              WrappedCardWithTitle(
                title: "ITEMS",
                children: [
                  TransactionsCardWidget(
                    onTap: (){
                    navigationService.pushNamed(Routes.itemInventoryList);
                  },title: "Items",icon: CupertinoIcons.bag,),
                  TransactionsCardWidget(isLast: true,onTap: (){
                   controller.comingSoon();
                    // navigationService.pushNamed(Routes.itemInventoryList);
                  },title: "Warehouse",icon: CupertinoIcons.house_alt,isDisabled: true,)
                ],
              ), WrappedCardWithTitle(
                title: "SALES",
                children: [
                  TransactionsCardWidget(onTap: (){
                    navigationService.pushNamed(Routes.customer, );
                  },title: "Customer",iconPath: Svgs.customer,),
                  TransactionsCardWidget(onTap: (){
                    navigationService.pushNamed(Routes.salesOrderList);
                  },title: "Sales Order",iconPath: Svgs.order),
                  TransactionsCardWidget(onTap: (){
                    navigationService.pushNamed(Routes.salesInvoiceList);
                  },title: "Sales Invoice",iconPath: Svgs.invoice),
                  TransactionsCardWidget(onTap: (){
                    navigationService.pushNamed(Routes.receiptList);
                  },title: "Receipt",iconPath: Svgs.receipt,),
                  TransactionsCardWidget(isLast:true,onTap: (){
                    controller.comingSoon();
                  },title: "Credit Note",icon: CupertinoIcons.return_icon,isDisabled: true,),
                ],
              ),WrappedCardWithTitle(
                title: "PURCHASE",
                children: [
                  TransactionsCardWidget(onTap: (){
                    navigationService.pushNamed(Routes.vendor);
                  },title: "Vendor",iconPath: Svgs.vendor,),
                  TransactionsCardWidget(onTap: (){
                    navigationService.pushNamed(Routes.purchaseOrderList);
                  },title: "Purchase Order",iconPath: Svgs.order),
                  TransactionsCardWidget(onTap: (){
                    navigationService.pushNamed(Routes.purchaseInvoiceList);
                  },title: "Purchase Invoice",iconPath: Svgs.invoice),
                  TransactionsCardWidget(onTap: (){
                    navigationService.pushNamed(Routes.paymentList);
                  },title: "Payment",iconPath: Svgs.paymentSent,),
                  TransactionsCardWidget(isLast:true,onTap: (){
                    controller.comingSoon();
                  },
                    title: "Payment Request",icon: CupertinoIcons.paperplane,isDisabled: true,),
                ],
              ),
            ],
          ),
        ),
      ),

    );
  }
}

class WrappedCardWithTitle extends StatelessWidget {
  const WrappedCardWithTitle({super.key,required this.children,required this.title});
  final List<Widget> children;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(title,style: AppTextStyle.greyFS14FW500,),
        ),
        gapH5,
        Container(
          decoration: AppUiConstants.salesCardDecoration.copyWith(borderRadius: BorderRadius.circular(14)),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: children.length,
            itemBuilder: (context, index) => children[index],),
        ),
      ],
    );
  }
}


class TransactionsCardWidget extends StatelessWidget {
  const TransactionsCardWidget({super.key,required this.onTap,this.isLast =false, this.iconPath,this.icon,required this.title,this.isDisabled=false});
  final String title;
  final String? iconPath;
  final IconData? icon;
  final VoidCallback? onTap ;
  final bool isLast;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return   Material(
      color: Colors.transparent,
      child: InkWell(
        onTap:isDisabled?null: onTap,
        child: Row(
          children: [
            gapW10,
            if(iconPath!=null)  SvgPicture.asset(iconPath!,color: isDisabled? AppColors.greyColor: Colors.black,),
            if(icon!=null) Icon(icon,color: isDisabled? AppColors.greyColor300: Colors.black,size: 22,),
            gapW20,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  gapH10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style:isDisabled ? AppTextStyle.greyFS16FW500.copyWith(color: AppColors.greyColor300):AppTextStyle.darkBlackFS16FW500,
                      ),
                      Padding(
                        padding:  EdgeInsets.only(right: 8.w),
                        child: Icon(CupertinoIcons.forward,color:isDisabled ?AppColors.greyColor300:   AppColors.greyColor500,size: 20,),
                      ),
                    ],
                  ),
                  gapH10,
               if(!isLast)   Divider(height: 1,),
                  if(isLast)  gapH5,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
