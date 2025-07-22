import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:yoloworks_invoice/app/constants/strings.dart';

import '../../features/dashboard/view/dashboard_controller.dart';
import '../../locator.dart';
import '../../router.dart';
import 'images.dart';

sealed class AppConstants {
  static int microSecondDateTime() => DateTime.now().microsecondsSinceEpoch;
  static int get microSecondPK =>
      math.Random().nextInt(1000) + microSecondDateTime();

  static Map<String, dynamic> isNotNullJson(Map value) {
    Map<String, dynamic> json = <String, dynamic>{};
    value.forEach((key, val) {
      json[key] = isNotNullValue(val);
    });
    return json;
  }

  static dynamic isNotNullValue(dynamic value) {
    if (value == null || value == 'null' || value.toString().isEmpty) return null;
    return value;
  }

  static String textSymbolRemover(String value, {String symbol = "₹"}) {
    if (value.isEmpty || value == '₹') return '0';
    final replacedValue = value.replaceAll(",", "").replaceAll(symbol, "");
    if (value.contains('.') && value.split('.').last.isNotEmpty) {
      return replacedValue.trim();
    }
    return replacedValue.replaceAll('.', '').trim();
  }

  static double amtToPercentage(
      {required double subTotal, required double amt}) {
    return double.parse((100 * (amt / subTotal)).toStringAsFixed(2));
  }

  static double percentageToAmt(
      {required double amt, required double percent}) {
    return double.parse((amt * (percent / 100)).toStringAsFixed(2));
  }

  static bool isAmtValidation(double price) {
    final value = price.toString().split('.');
    return (value.first.length > 10 || value.last.length > 2);
  }

  static String removeZero(double value) {
    final list = value.toString().split('.');
    if (list.last == '0') {
      return list.first;
    }
    return value.toString();
  }

  static removeFocus() {
    final context = navigationService.navigatorKey.currentContext!;
    FocusScope.of(context).unfocus();
  }

  static final List<QuickLickModel> quickLinkCards = [
    QuickLickModel(
        image: Svgs.invoice,
        name: AppStrings.invoice.text,
        route: Routes.salesInvoiceList,
        enabled: true),
    QuickLickModel(
        image: Svgs.order,
        name: AppStrings.order.text,
        route: Routes.salesOrderList,
        enabled: true),
    QuickLickModel(
        image: Svgs.receipt,
        name: AppStrings.receipt.text,
        route: Routes.receiptList,
        enabled: true),
    QuickLickModel(
        image: Svgs.customer,
        name: AppStrings.customer.text,
        route: Routes.customer,
        enabled: true),
    QuickLickModel(
        image: Svgs.purchase,
        name: AppStrings.purchase.text,
        route: Routes.purchaseInvoiceList,
        enabled: false),
    QuickLickModel(
        image: Svgs.billTag,
        name: AppStrings.po.text,
        route: Routes.purchaseOrderList,
        enabled: false),
    QuickLickModel(
        image: Svgs.paymentSent,
        name: AppStrings.payment.text,
        route: Routes.paymentList,
        enabled: false),
    QuickLickModel(
        image: Svgs.vendor,
        name: AppStrings.vendor.text,
        route: Routes.vendor,
        enabled: false),
    QuickLickModel(
        image: Svgs.inventory,
        name: AppStrings.item.text,
        route: Routes.itemInventoryList,
        enabled: false),
    QuickLickModel(
        image: Svgs.service,
        name: AppStrings.service.text,
        route: Routes.service,
        enabled: false)
  ];
}
