import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yoloworks_invoice/features/auth/data/auth_repository.dart';
import 'package:yoloworks_invoice/router.dart';
import '../../../../locator.dart';
import '../../../../services/appconfig_service/appconfig_model.dart';
import '../../../../services/dialog_service/alert_response.dart';
import '../../models/organization_model.dart';

part 'select_organization_controller.g.dart';

@riverpod
class SelectOrganisationController extends _$SelectOrganisationController {
  @override
  AsyncValue<void> build() {
    return AsyncValue.data(null);
  }

  setState() {
    state = AsyncValue.data(null);
  }

  late InAppWebViewController controller;
  bool load = true;
  bool isPageNotLoaded = false;
  late Uri uri;
  List<Organization> organizationList = [];
  OrganizationModel? organization;

  late PackageInfo info;
  final AppConfig appConfig = appConfigService.config;

  Future<void> init() async {
    info = await PackageInfo.fromPlatform();
    uri = Uri.parse(appConfig.accountUrl ?? "");
  }

  fetchData({bool? refresh}) async {
    try {
      if (refresh == true) {
        organization = null;
        organizationList = [];
      }
      if (organization == null) {
        state = const AsyncValue.loading();
      }
      organization =
          await ref.read(authRepositoryProvider).getUserOrganization();
      organizationList = organization?.organization ?? [];
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    state = AsyncValue.data(null);
  }

  void selectOrganization(Organization _org) async {
    AlertResponse? response = await dialogService.showConfirmationAlertDialog(
      secondaryButton: 'No',
      primaryButton: "Yes",
      title: "Are you sure you want to select this ${_org.name} organization?",
    );
    if (response?.status == true) {
      await preferenceService.setUserOrg(_org);
      navigationService.popAllAndPushNamed(Routes.dashboard);
    }
  }
}
