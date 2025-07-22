import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';
import '../../locator.dart';
import '../../router.dart';
import '../../services/appconfig_service/appconfig_model.dart';
import '../../utils/logger.dart';

class UpdateChecker {
  versionCheck() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    final String currentVersion = info.version;

    final AppConfig appConfig = appConfigService.config;

    final AppUpdateDetails? storeVersion = Platform.isIOS
        ? appConfig.appUpdate?.iOS
        : appConfig.appUpdate?.android;

    try {
      print("appStore.version: ${storeVersion}");
      print("current.version: $currentVersion");

      if (int.parse(storeVersion!.showVersionAndBelow!.replaceAll(".", "")) >
          int.parse(currentVersion.replaceAll(".", ""))) {
        String message = storeVersion.updateMessage ?? 'New  Update Available';
        Logger.d("Unable to check for version info", e: message);
        // analyticsService.logScreenName("update_dialog");
        // analyticsService.logEvent("update_dialog", <String, dynamic>{'version': storeVersion.showVersionAndBelow, 'message': message});

        return await navigationService.popAllAndPushNamed(Routes.update);
      }
    } catch (exception, stacktrace) {
      Logger.e("Unable to check for version info", e: exception, s: stacktrace);
    }
  }
}
