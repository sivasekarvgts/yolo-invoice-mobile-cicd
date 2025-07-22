import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/common_widgets/tab_bar_widget.dart';
import '../../../../locator.dart';
import '../../data/auth_repository.dart';
import '../../models/organization_info_model.dart';
import 'bill_configuration/bill_configuration_view.dart';
import 'organization_info/organization_info_view.dart';

part 'manage_organization_controller.g.dart';

@riverpod
class ManageOrganisationController extends _$ManageOrganisationController {
  @override
  AsyncValue<void> build() {
    return AsyncValue.data(null);
  }

  final tab1navigatorKey = GlobalKey<NavigatorState>();
  final tab2navigatorKey = GlobalKey<NavigatorState>();
  OrganizationInfoModel? organizationInfo;

  String get userAddress {
    final state = preferenceService.getUserOrg()?.addressDetail?.first.state;
    final place = preferenceService.getUserOrg()?.addressDetail?.first.address1;
    final address =
        (state == null || state == "") ? place : "${state} - ${place}";
    return address ?? "";
  }

  Future<void> init() async {
    await fetchData();
  }

  Future fetchData({bool? refresh}) async {
    try {
      if (refresh == true) {
        organizationInfo = null;
      }
      if (organizationInfo == null) {
        state = const AsyncValue.loading();
      }
      organizationInfo =
          await ref.read(authRepositoryProvider).getOrganizationInfo();
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    state = AsyncValue.data(null);
  }

  List<TabItems> tabs = [
    TabItems(
        tab: OrganizationInfoView(),
        title: "Organization Info",
        icon: (Icons.badge_outlined)),
    TabItems(
        tab: BillConfigurationView(),
        title: "Bill Configuration",
        icon: (Icons.tune))
  ];
}
