import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../app/styles/colors.dart';
import '../../core/enums/environment.dart';
import '../../locator.dart';
import '../../services/appconfig_service/appconfig_model.dart';
import '../../utils/logger.dart';

class AppConfigService {
  Map? _deviceInfo;
  AppEnvironment? _appEnvironment;
  String? _packageName;
  String? _appVersion;
  String? configKey;
  AppConfig _appConfig = AppConfig(appName: "Yolo Invoice", baseApiUrl: "");
  late FirebaseRemoteConfig remoteConfig;

  Map get deviceInfo => _deviceInfo ?? {};

  String get appVersion => _appVersion ?? '';

  String get packageName => _packageName ?? '';

  AppEnvironment? get appEnvironment => _appEnvironment;

  AppConfig get config {
    return _appConfig;
  }

  String get envString {
    if (_packageName?.endsWith(".dev") == true) {
      return "DEVELOP";
    } else if (_packageName?.endsWith(".devX") == true) {
      return "DEVX";
    } else if (_packageName?.endsWith(".uat") == true) {
      return "UAT";
    } else {
      return "PROD";
    }
  }

  Color get color {
    if (_packageName?.endsWith(".dev") == true|| _packageName?.endsWith(".devX") == true) {
      return Colors.red;
    } else if (_packageName?.endsWith(".uat") == true) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  Future<void> configure() async {
    remoteConfig = FirebaseRemoteConfig.instance;
    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: remoteConfig.settings.fetchTimeout,
          minimumFetchInterval: Duration.zero));

              try {
          final activated = await remoteConfig.fetchAndActivate();
          print('Remote Config activated: $activated');
        } catch (ex, s) {
          Logger.e(ex.toString(), s: s);
        }

      try {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        _packageName = packageInfo.packageName;
        _appVersion = packageInfo.version;
      } catch (ex, s) {
        Logger.e(ex.toString(), s: s);
      }

      try {
        final deviceInfoPlugin = DeviceInfoPlugin();
        _deviceInfo = (await deviceInfoPlugin.deviceInfo).data;
      } catch (ex, s) {
        Logger.e(ex.toString(), s: s);
      }

      if (packageName.endsWith("dev")) {
        _appEnvironment = AppEnvironment.dev;
        //TODO :change to dev_config
        configKey = "devx_config";
      } else if (packageName.endsWith("uat")) {
        _appEnvironment = AppEnvironment.staging;
        configKey = "uat_config";
      } else if (packageName.endsWith("devX")) {
        _appEnvironment = AppEnvironment.staging;
        configKey = "devx_config";
      } else {
        _appEnvironment = AppEnvironment.production;
        configKey = "config";
      }
      final _remoteJson = FirebaseRemoteConfig.instance.getString(configKey!);
      print("REMOTE JSON :${_remoteJson}");
      _appConfig = AppConfig.fromJson(jsonDecode(_remoteJson));

      Logger.d('Init RemoteConfig: SUCCESS');
      Logger.d(appConfigService.config.toJson().toString());
    } catch (e, s) {
      Connectivity().onConnectivityChanged.listen((result) {
        if (result.first == ConnectivityResult.none) {
          Fluttertoast.showToast(
              msg:
                  "No Network Connection. Please Enable Internet and Try Again.",
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: AppColors.textOnBackground.withOpacity(0.8),
              textColor: AppColors.background);
        }
      });

      debugPrint("exe $e");
      debugPrint("exe $s");
      rethrow;
    }
  }
}
