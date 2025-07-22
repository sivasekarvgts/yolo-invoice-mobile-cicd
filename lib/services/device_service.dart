import 'dart:core';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io';

import '../../locator.dart';
import '../../core/enums/environment.dart';
import 'package:uuid/uuid.dart';

class DeviceService {
  String? _deviceId;
  // String? _userAgent;
  Map<String, String>? _deviceInfoHeaders;
  PackageInfo? packageInfo;
  AppEnvironment? environment;
  String? version;
  bool isProd = false;


  configureDeviceService() async {
    try {
      await initPlatformPackageInfo();
      // await getUserAgent();
      await getDeviceInfoHeaders();
      await getDeviceId();
      debugPrint("Device Service Setup Successfully");
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
  }

  

  envString() {
    switch (environment) {
      case AppEnvironment.dev:
        return "DEVELOP";
      case AppEnvironment.staging:
        return "STAGING";
      case AppEnvironment.production:
        return "PRODUCTION";
      default:
        return "New Env";
    }
  }

  Future<PackageInfo?> initPlatformPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
    String? packageName = packageInfo?.packageName;
    if (packageName?.endsWith(".dev") == true) {
      environment = AppEnvironment.dev;
    } 
    else if (packageName?.endsWith(".devX") == true) {
      environment = AppEnvironment.devX;
    }
    else if (packageName?.endsWith(".uat") == true) {
      environment = AppEnvironment.staging;
    }
     else {
      isProd = true;
      environment = AppEnvironment.production;
    }
    version = "${packageInfo?.version}+${packageInfo?.buildNumber}";

    return packageInfo;
  }

  // String? getUserAgent() {
  //   if (_userAgent?.isNotEmpty == true) {
  //     return _userAgent;
  //   }
  //   String ogappVersionString;
  //   if (Platform.isIOS || Platform.isAndroid) {
  //     ogappVersionString = "vittae-app/${packageInfo?.version}-${packageInfo?.buildNumber}";
  //   } else {
  //     ogappVersionString = "vittae-app/?";
  //   }
  //   final dartVersionString = Platform.version.split(" ").first;
  //   final osString = Platform.operatingSystem;
  //   final osVersionString = Platform.operatingSystemVersion.split(" ").first;
  //   _userAgent = "$ogappVersionString Dart/$dartVersionString OS/$osString-$osVersionString";
  //   debugPrint("Useragent $_userAgent");
  //   return _userAgent;
  // }

  Future<Map<String, String>?> getDeviceInfoHeaders() async {
    if (_deviceInfoHeaders != null) {
      return _deviceInfoHeaders;
    }
    _deviceInfoHeaders = <String, String>{};
    try {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
        _deviceInfoHeaders!['os-name'] = "Android";
        _deviceInfoHeaders!['device-model'] = info.model;
        _deviceInfoHeaders!['device-id'] = info.id;
      } else if (Platform.isIOS) {
        IosDeviceInfo info = await deviceInfoPlugin.iosInfo;
        _deviceInfoHeaders!['os_type'] = "iOS";
        _deviceInfoHeaders!['device_model'] = info.model;
        _deviceInfoHeaders!['device_id'] = info.identifierForVendor ?? '';
      }
    } on Exception {}
    return _deviceInfoHeaders;
  }

  Future<String?> getDeviceId() async {
    if (_deviceId == null) {
      _deviceId = preferenceService.getDeviceId();
      if (_deviceId == null) {
        var uuid = const Uuid();
        _deviceId = uuid.v1();
        preferenceService.setDeviceId(_deviceId!);
      }
      return _deviceId;
    }
    return _deviceId;
  }

   Future<int> getAndroidSdkVersion() async {
    if (Platform.isIOS) return 0;
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    final androidInfo = await deviceInfoPlugin.androidInfo;
    return androidInfo.version.sdkInt;
  }
}
