import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import '../../locator.dart';
import '../../router.dart';
import '../../services/appconfig_service/appconfig_model.dart';
import '../../utils/logger.dart';

class MaintenanceChecker {
  versionCheck() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    final String currentVersion = info.version;

    final AppMaintenance? appMaintenance =
        appConfigService.config.appMaintenance;

    try {
      print("appStore.version: ${appMaintenance}");
      print("current.version: $currentVersion");

      if (int.parse(appMaintenance!.showVersionAndBelow!.replaceAll(".", "")) >
          int.parse(currentVersion.replaceAll(".", ""))) {
        String message = 'New  maintenance Available';
        Logger.d("Unable to check for version info", e: message);

        // analyticsService.logScreenName("maintenance_Screen");
        // analyticsService.logEvent("maintenance_Screen", <String, dynamic>{'version': appMaintenance.showVersionAndBelow, 'message': message});

        if (Platform.isIOS && appMaintenance.enableMaintenanceOnIos == true) {
          return await navigationService.popAllAndPushNamed(Routes.maintenance);
        } else if (Platform.isAndroid &&
            appMaintenance.enableMaintenanceOnAndroid == true) {
          return await navigationService.popAllAndPushNamed(Routes.maintenance);
        }
      }
    } catch (exception, stacktrace) {
      Logger.e("Unable to check for version info", e: exception, s: stacktrace);
    }
  }
}
