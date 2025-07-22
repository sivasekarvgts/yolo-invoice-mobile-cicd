import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/enums/user_type.dart';
import '../../../../locator.dart';
import '../../../../router.dart';
import '../../../../services/dialog_service/alert_response.dart';
import '../../../../services/dialog_service/snackbar_service.dart';
import '../../../../services/event_bus_service.dart';
import '../../data/customer_repository.dart';
import '../../models/customer/customer_detail_model.dart';

part 'client_detail_controller.g.dart';

part 'package:yoloworks_invoice/features/dashboard/customer/customer_detail/customer_detail_controller.dart';

part 'package:yoloworks_invoice/features/dashboard/vendor/vendor_detail/vendor_detail_controller.dart';

@riverpod
class ClientDetailController extends _$ClientDetailController {
  @override
  AsyncValue<void> build() {
    return AsyncValue.loading();
  }

  AsyncValue<void> get setState => state = AsyncValue.data(null);

  AsyncValue<void> get setLoading => state = AsyncValue.loading();

  CustomerDetailModel? customerData;
  int clientId = 0;
  UsersType? usersType;

  Future<void> onInit(UsersType _usersType, int _customerId) async {
    usersType = _usersType;
    clientId = _customerId;
    await fetchData(refresh: true);
    onRefreshEvent();
  }

  void onRefreshEvent() async {
    eventBusService.eventBus.on<PageRefreshEvent>().listen((event) async {
      if (event.pageNames.contains(Routes.vendorDetail)||event.pageNames.contains(Routes.customerDetail))
        await fetchData(refresh: event.isRefresh);
    });
  }

  fetchData({bool refresh = false}) {
    if (usersType == UsersType.customer) {
      fetchCustomerDetail(refresh: refresh);
      return;
    }
    fetchVendorDetail(refresh: refresh);
  }

  Future deleteContact(int id) async {
    try {
      await ref
          .read(customerRepositoryProvider)
          .deleteCustomerContact(contactId: id);
      SnackbarService.toastMsg("Contact Deleted Successfully!", false);
      await fetchData();
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    state = AsyncValue.data(null);
  }

  Future deleteCustomer(int? id) async {
    AlertResponse? response = await dialogService.showConfirmationAlertDialog(
      secondaryButton: 'No',
      primaryButton: "Yes",
      title: "Are you sure you want to Delete this  client?",
    );
    if (response?.status == true)
      try {
        await ref.read(customerRepositoryProvider).deleteCustomer(id: id ?? 0);
        navigationService.pop(returnValue: true);
        SnackbarService.toastMsg("Customer Deleted Successfully!", false);
      } catch (e, s) {
        state = AsyncValue.error(e, s);
      }
    state = AsyncValue.data(null);
  }

  makeCallFun(String number) {
    makePhoneCall('tel:$number');
  }

  Future<void> makePhoneCall(String url) async {
    Uri _uri = Uri.parse(url);
    if (await canLaunchUrl(_uri)) {
      await launchUrl(_uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
