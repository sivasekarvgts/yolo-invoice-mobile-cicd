import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yoloworks_invoice/app/common_widgets/hide_floating.dart';
import 'package:yoloworks_invoice/app/styles/text_styles.dart';
import 'package:yoloworks_invoice/core/enums/user_type.dart';
import 'package:yoloworks_invoice/features/dashboard/data/customer_repository.dart';
import 'package:yoloworks_invoice/locator.dart';
import 'package:yoloworks_invoice/services/dialog_service/alert_response.dart';

import '../../../app/constants/app_sizes.dart';
import '../../../app/constants/images.dart';
import '../../../app/styles/colors.dart';
import '../../../router.dart';
import '../../../services/event_bus_service.dart';
import '../../../utils/debounce.dart';
import '../models/customer/customer_list.dart';

part 'client_list_controller.g.dart';

part 'package:yoloworks_invoice/features/dashboard/customer/customer_list_controller.dart';

part 'package:yoloworks_invoice/features/dashboard/vendor/vendor_list_controller.dart';

@riverpod
class ClientListController extends _$ClientListController with HideFloating {
  @override
  AsyncValue<void> build() {
    return AsyncValue.loading();
  }

  AsyncValue<void> get setState => state = AsyncValue.data(null);

  AsyncValue<void> get setLoading => state = AsyncValue.loading();

  UsersType? userType;
  CustomerListModel? customerData;
  List<CustomerList> clientList = [];
  final searchTextCtrl = TextEditingController();
  bool showSearchBar = false;
  bool isSales = false;

  Future<void> onInit(UsersType _userType, bool sales) async {
    isSales = sales;
    userType = _userType;
    await fetchData(refresh: true);
    hideButtonController = ScrollController();
    onRefreshEvent();
  }

  void onRefreshEvent() async {
    eventBusService.eventBus.on<PageRefreshEvent>().listen((event) async {
      if (event.pageNames.contains(Routes.vendor)||event.pageNames.contains(Routes.customer))
        await fetchData(refresh: event.isRefresh);
    });
  }

  Future onSearchOrder(String query) async {
    Debounce.debounce('clients-search', () async {
      await fetchData(refresh: true);
    });
  }

  Future fetchData({refresh = false}) async {
    if (userType == UsersType.vendor) {
      await fetchVendorList(refresh: refresh);
      return;
    }
    await fetchCustomer(refresh: refresh);
  }

  Future detailView(int id) async {
    if (isSales == true) {
      navigationService.pop(returnValue: id);
      return;
    }

    String route = Routes.customerInfo;
    if (userType == UsersType.vendor) route = Routes.vendorInfo;
    final res = await navigationService.pushNamed(route, arguments: id);
    if (res == true) await fetchData(refresh: true);
  }

  void onOpenSearch() {
    showSearchBar = true;
    setState;
  }

  void showDialog() {
    dialogService.showSelectDialog(
      title: userType == UsersType.customer ? "New Customer" : "New Vendor",
      child:SelectClientTypeWidget(userType: userType!,refresh:(){fetchData(refresh: true);} ,),
    );
  }
}



class SelectClientTypeWidget extends StatelessWidget {
  const SelectClientTypeWidget({super.key,required this.userType,required this.refresh });
  final UsersType userType;
  final Function() refresh;
  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            dialogService.dialogComplete(AlertResponse(status: true));
            navigationService
                .pushNamed(Routes.addNewClient,
                arguments: AddNewClientRouteArg(
                    customerType: 1, usersType: userType))
                ?.then((v) {
              if (v == true) refresh();
            });
          },
          child: Row(
            children: [
              Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: AppColors.greyColor300, width: 1)),
                  child: SvgPicture.asset(Svgs.vendor)),
              gapW8,
              Text(
                "Business ${userType==UsersType.customer ?"Customer":"Vendor"}",
                style: AppTextStyle.bodyMedium,
              )
            ],
          ),
        ),
        gapH4,
        Divider(
          thickness: 1,
          color: AppColors.greyColor300,
        ),
        gapH4,
        GestureDetector(
          onTap: () {
            dialogService.dialogComplete(AlertResponse(status: true));
            navigationService
                .pushNamed(Routes.addNewClient,
                arguments: AddNewClientRouteArg(
                    customerType: 2, usersType: userType))
                ?.then((v) {
              if (v == true) refresh();
            });
          },
          child: Row(
            children: [
              Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: AppColors.greyColor300, width: 1)),
                  child: Icon(CupertinoIcons.person)),
              gapW8,
              Text(
                "Individual ${userType==UsersType.customer ?"Customer":"Vendor"}",
                style: AppTextStyle.bodyMedium,
              )
            ],
          ),
        ),
      ],
    );
  }
}
