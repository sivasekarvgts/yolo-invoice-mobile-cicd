import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yoloworks_invoice/app/constants/app_sizes.dart';
import 'package:yoloworks_invoice/app/constants/images.dart';
import 'package:yoloworks_invoice/app/styles/colors.dart';
import 'package:yoloworks_invoice/core/enums/user_type.dart';
import 'package:yoloworks_invoice/core/extension/color_extension.dart';
import 'package:yoloworks_invoice/features/dashboard/view/dashboard_view.dart';
import 'package:yoloworks_invoice/features/reports/view/report_view.dart';
import 'package:yoloworks_invoice/features/settings/view/settings_view.dart';
import 'package:yoloworks_invoice/features/transactions/view/transactions_view.dart';
import 'package:yoloworks_invoice/locator.dart';
import 'package:yoloworks_invoice/router.dart';
import '../../core/enums/order_type.dart';
import '../../features/dashboard/client/client_list_controller.dart';
import '../../features/payment/payment_create/models/payment_params_request_model.dart';
import '../../features/sales/models/sales_params_request_model/sales_params_request_model.dart';
import '../../services/dialog_service/alert_response.dart';
import '../styles/text_styles.dart';

class BottomTabBarView extends StatefulWidget {
  @override
  _BottomTabBarViewState createState() => _BottomTabBarViewState();
}

class _BottomTabBarViewState extends State<BottomTabBarView> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  final _pages = [DashboardView(), TransactionsView(), DashboardView(),ReportView(),SettingsView()];
  late TabController tabController;


  @override
  void initState() {
  tabController =TabController(length: 5, vsync: this);
    super.initState();
  }

  void showDialog() {
    dialogService.showPositionedAlertDialog(
      left: 20,right: 20,
      title:  "Select to create" ,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          CupertinoCreateItemWidget(
            icon: Svgs.invoice,
            onTap: (){
            navigate(routeName:Routes.salesInvoice,billType: BillType.salesInvoice,isVendor: false);
          },title: "Sales Invoice",), gapH4,Divider(
            thickness: 1,
            color: AppColors.greyColor300,
          ), gapH4,
          CupertinoCreateItemWidget(  icon: Svgs.order,
            onTap: (){
            navigate(routeName:Routes.salesOrder,billType: BillType.salesOrder,isVendor: false);
          },title: "Sales Order",), gapH4,Divider(
            thickness: 1,
            color: AppColors.greyColor300,
          ), gapH4,
          CupertinoCreateItemWidget(
            icon: Svgs.customer,
            onTap: (){
            dialogService.showSelectDialog(title: "New Customer",
                child:
                SelectClientTypeWidget(userType: UsersType.customer,refresh: (){},)
            );
          },title: "Customer",), gapH4,Divider(
            thickness: 1,
            color: AppColors.greyColor300,
          ), gapH4,
          CupertinoCreateItemWidget(
            icon: Svgs.receipt,
            onTap: () async {
              final res =
                  await navigationService.pushNamed( Routes.customer, arguments: true);
              if (res == null) return;
            navigationService.pushNamed(Routes.paymentCreate,arguments:  PaymentParamsRequestModel(
                clientId: res,
                isVendor: false,
                billType:
              BillType.paymentReceived));
            // navigate(routeName:Routes.vendor,billType: BillType.salesInvoice,isVendor: false);
          },title: "Receipt",),
        ],
      ),
    );
  }



  void showClientTypeSelectDialog(UsersType userType) {
    dialogService.showSelectDialog(
      title: userType == UsersType.customer ? "New Customer" : "New Vendor",
      child:SelectClientTypeWidget(userType: userType,refresh:(){} ,),
    );
  }



  void navigate({required String  routeName,required BillType  billType,required bool isVendor}) async {
    final res =
    await navigationService.pushNamed(isVendor?Routes.vendor:Routes.customer, arguments: true);
    if (res == null) return;
    navigationService.pushNamed(routeName,
        arguments: SalesParamsRequestModel(
            clientId: res, billType: billType,isVendor: isVendor));
  }

  @override
  Widget build(BuildContext context) {
       return Scaffold(
      extendBody: true,
      body: BottomBar(
        fit: StackFit.expand,
        borderRadius: BorderRadius.circular(100),
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        barColor: AppColors.dividerGreyColor.withOpacityValue(.5),
        width: MediaQuery.of(context).size.width * 0.93,
        barAlignment: Alignment.bottomCenter,
        body: (context, controller) => IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        start: 2,
        end: 0,
        offset: 10,
        child:TabBar(
          controller: tabController,
          padding: EdgeInsets.symmetric(vertical: 2,),
          indicator: BoxDecoration(
            color: AppColors.primary, // selected tab background color
            shape: BoxShape.circle, // makes it round
          ),
          indicatorSize: TabBarIndicatorSize.tab, // makes indicator wrap whole tab
          indicatorPadding: EdgeInsets.all(5.h),
          labelColor: Colors.white, // icon color when selected
          unselectedLabelColor: Colors.black, // icon color when not selected
          tabs:  [
            Tab(icon: Icon(Icons.home,size: 20.w,)),
            Tab(icon: Icon(Icons.view_agenda_outlined,size: 20.w,)),
            Tab(icon: SizedBox()),
            Tab(icon: Icon(Icons.show_chart,size: 20.w,)),
            Tab(icon: Icon(Icons.menu,size: 20.w,)),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        height: 65,
        child: InkWell(
          onTap: (){},
          child: Padding(
                   padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
            child:
            InkWell(
              onTap: (){},
              child: FloatingActionButton(
                shape: CircleBorder(),
                backgroundColor: AppColors.primary,
                onPressed: (){
                  showDialog();
                },child: Icon(Icons.add,color: Colors.white,),),
            ),
          ),
        ),
      ),
    );
  }
}




class CupertinoCreateItemWidget extends StatelessWidget {
  const CupertinoCreateItemWidget({super.key,required this.onTap,required this.icon,required this.title});
  final String title;
  final String icon;
  final VoidCallback onTap ;
  @override
  Widget build(BuildContext context) {
    return   Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          dialogService.dialogComplete(AlertResponse(status: true));
          onTap();
        },
        child: Container(
          color: Colors.transparent,
          child: Row(
            children: [
              Container(
                  width: 30,
                  height: 30,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: AppColors.greyColor300, width: 1)),
                  child: SvgPicture.asset(icon,color: Colors.black,)),
              gapW8,
              Text(
                title,
                style: AppTextStyle.bodyMedium,
              )
            ],
          ),
        ),
      ),
    );
  }
}


