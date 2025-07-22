import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yoloworks_invoice/locator.dart';


sealed class FileStorageServices {
  static Future<String?> getExternalDocumentPath() async {
    Directory directory = Directory("");
    if (Platform.isAndroid) {
      directory = Directory("/storage/emulated/0/Download");
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final exPath = directory.path;
    debugPrint("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  static Future<String?> getTempDocumentPath() async {
    Directory directory = await getTemporaryDirectory();

    final exPath = directory.path;
    debugPrint("Saved Temp Path: $exPath");
    return exPath;
  }

  static Future<bool> storagePermissionGiven() async {
    bool isGranted = true;
    final sdkVersion = await deviceService.getAndroidSdkVersion();
    debugPrint('sdkVersion : $sdkVersion');

    if ((Platform.isIOS || Platform.isAndroid) &&
        (sdkVersion <= 29) &&
        !(await Permission.storage.isGranted)) {
      isGranted = await Permission.storage.request().isGranted;
    }

    // if ((sdkVersion > 29) && !(await Permission.photos.isGranted)) {
    //   isGranted = await Permission.photos.request().isGranted;
    // }

    // if ((sdkVersion > 29)) {
    //   isGranted = true;
    // }

    return isGranted;
  }

  static Future<bool> requestStoragePermission() async {
    final status = await storagePermissionGiven();
    if (status) {
      debugPrint('Storage permission granted');
      return true;
    } else {
      debugPrint('Storage permission permanently denied');
      final setting = await openAppSettings();
      return setting;
    }
  }
}
