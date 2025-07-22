import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:yoloworks_invoice/api/api_endpoints.dart';
import '../../core/enums/request_method.dart';
import '../../core/models/request_setting.dart';
import '../../locator.dart';
import '../dialog_service/snackbar_service.dart';
import 'file_storage_services.dart';

class DioFileDownloadService {

  Future<void> downloadFile(int billNo, String fileName,
      {bool toView = false,required int  billType }) async {
    try {
      String? downloadsDir;
      if (!toView) {
        downloadsDir = await FileStorageServices.getExternalDocumentPath();
      } else {
        downloadsDir = await FileStorageServices.getTempDocumentPath();
      }
      String filePath = "$downloadsDir/$fileName";

      int count = 1;

      while (File(filePath).existsSync()) {
        filePath = "$downloadsDir/${fileName.split('.xlsx')[0]}($count).xlsx";
        count++;
      }

      debugPrint("📥 Downloading...");

      final requestSetting =RequestSettings(
          "${ApiEndPoint.invoiceDownload}?bill=$billNo&type=$billType&all_bill=0",
          RequestMethod.GET,
          params: null,
          authenticated: true);

    final res = await apiBaseService.request<dynamic>(
          requestSetting,
              (data) => (data));


      // final String url =
      //     "$baseUrl${APIEndPoint.reportDownload}${param["session_id"]}/?route_ids=${param["route_ids"]}";
      //
      // await _client.dio.download(url, filePath, deleteOnError: false);

      debugPrint("✅ File downloaded to: $filePath");
        successMsg(text: toView?"File Ready to View":null);
        await openFile(filePath);
    } catch (e) {
      failureMsg(
          "Failed", "Unable to ${toView ? "View Bill" : "Download Bill"}.");
      debugPrint("❌ Error downloading file: $e");
    }
  }

  /// 🔹 Opens a file using the default viewer
  Future<void> openFile(String filePath) async {
    final result = await OpenFilex.open(filePath);
    debugPrint("📂 Open File Result: ${result.message}");
  }


  void failureMsg(String title, String msg) => SnackbarService.showSnackBar(
      title: '$title!',
      msg: msg,
      color: Colors.red,
      icon: const Icon(Icons.error, color: Colors.white));

  void successMsg({String? text}) => SnackbarService.showSnackBar(
      title: 'Success!',
      msg: text??"Download Completed",
      color: Colors.green,
      icon: const Icon(Icons.check_circle, color: Colors.white));
}
