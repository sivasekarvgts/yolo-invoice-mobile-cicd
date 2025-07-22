import 'package:flutter/material.dart';

class TdsTcsModel {
  final String title;
  final int id;

  TdsTcsModel({required this.title, required this.id});
}

class AdjustmentDiscountModel {
  final String title;
  final IconData iconData;
  final int id;

  AdjustmentDiscountModel(
      {required this.title, required this.iconData, required this.id});
}

class GstTaxModel {
  final String title;
  final int id;

  GstTaxModel({required this.title, required this.id});
}

final gstTaxModel = [
  GstTaxModel(title: 'Including Tax', id: 0),
  GstTaxModel(title: 'Excluding Tax', id: 1)
];

List<AdjustmentDiscountModel> adjustmentModel = [
  AdjustmentDiscountModel(id: 0, iconData: Icons.remove, title: 'Subtract'),
  AdjustmentDiscountModel(iconData: Icons.add, id: 1, title: 'Add'),
];

List<AdjustmentDiscountModel> discountModel = [
  AdjustmentDiscountModel(id: 1, iconData: Icons.percent, title: 'Percentage'),
  AdjustmentDiscountModel(
      id: 2, iconData: Icons.currency_rupee, title: 'Amount'),
];

List<TdsTcsModel> tdsTcsModel = [
  TdsTcsModel(id: 0, title: 'TDS'),
  TdsTcsModel(id: 1, title: 'TCS'),
];
