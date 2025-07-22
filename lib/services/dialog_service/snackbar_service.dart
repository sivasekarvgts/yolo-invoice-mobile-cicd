import 'package:flutter/material.dart';
import 'package:yoloworks_invoice/locator.dart';

import '../../app/styles/colors.dart';

class SnackbarService {
  static void showSnackBar({
    required String title,
    required String msg,
    required Color color,
    Widget? icon,
    Color? colorText,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(
      navigationService.navigatorKey.currentContext!,
    ).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) icon,
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: colorText ?? Colors.white,
                          fontWeight: FontWeight.bold)),
                  Text(msg, style: TextStyle(color: colorText ?? Colors.white)),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor ?? color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.all(15),
      ),
    );
  }

  static void toastMsg(String msg,
          [bool isFailed = true, Color color = Colors.red]) =>
      SnackbarService.showSnackBar(
          title: isFailed ? 'Alert' : 'Success',
          msg: msg,
          color: isFailed ? color : AppColors.greenColor,
          icon: Icon(
              isFailed ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white));
}
