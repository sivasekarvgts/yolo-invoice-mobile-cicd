import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:yoloworks_invoice/core/extension/color_extension.dart';
import 'package:yoloworks_invoice/core/extension/datetime_extension.dart';

OrderListModel salesOrderListModelFromJson(String str) =>
    OrderListModel.fromJson(json.decode(str));

String salesOrderListModelToJson(OrderListModel data) =>
    json.encode(data.toJson());

class OrderListModel extends Equatable {
  final int? count;
  final int? numPages;
  final int? pageSize;
  final int? currentPage;
  final List<int>? pageRange;
  final List<OrderListItem>? orderList;
  final TotalValues? totalValues;
  final String? vendor;
  final int? vendorId;

  OrderListModel({
    this.count,
    this.numPages,
    this.pageSize,
    this.currentPage,
    this.pageRange,
    this.orderList,
    this.totalValues,
    this.vendor,
    this.vendorId,
  });

  factory OrderListModel.fromJson(Map<String, dynamic> json) => OrderListModel(
        count: json["count"],
        numPages: json["num_pages"],
        pageSize: json["page_size"],
        currentPage: json["current_page"],
        pageRange: json["page_range"] == null
            ? []
            : List<int>.from(json["page_range"]!.map((x) => x)),
        orderList: json["data"] == null
            ? []
            : List<OrderListItem>.from(
                json["data"]!.map((x) => OrderListItem.fromJson(x))),
        totalValues: json["total_values"] == null
            ? null
            : TotalValues.fromJson(json["total_values"]),
        vendor: json["vendor"],
        vendorId: json["vendor_id"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "num_pages": numPages,
        "page_size": pageSize,
        "current_page": currentPage,
        "page_range": pageRange == null
            ? []
            : List<dynamic>.from(pageRange!.map((x) => x)),
        "data": orderList == null
            ? []
            : List<dynamic>.from(orderList!.map((x) => x.toJson())),
        "total_values": totalValues?.toJson(),
        "vendor": vendor,
        "vendor_id": vendorId,
      };

  @override
  List<Object?> get props => [orderList, totalValues, vendor, vendorId];
}

class OrderListItem extends Equatable {
  final int? id;
  final String? orderNumber;
  final String? salesPerson;
  final dynamic routeName;
  final String? client;
  final int? clientId;
  final double? total;
  final String? logo;
  final DateTime? orderDate;
  final bool? isApproved;
  final int? orderStatusId;
  final String? orderStatusName;
  final String? colorCode;
  final String? vendor;
  final int? vendorId;

  OrderListItem({
    this.id,
    this.orderNumber,
    this.routeName,
    this.client,
    this.clientId,
    this.total,
    this.logo,
    this.orderDate,
    this.salesPerson,
    this.isApproved,
    this.orderStatusId,
    this.orderStatusName,
    this.colorCode,
    this.vendor,
    this.vendorId,
  });

  Color? get colorValue => colorCode?.toGetColor();

  String? get dateFormatted => orderDate?.toFormattedYearMonthDate();

  factory OrderListItem.fromJson(Map<String, dynamic> json) => OrderListItem(
        id: json["id"],
        orderNumber: json["order_number"],
        routeName: json["route_name"],
        salesPerson: json["sales_person"],
        client: json["client"],
        clientId: json["client_id"],
        total: json["total"]?.toDouble(),
        logo: json["logo"],
        orderDate: json["order_date"] == null
            ? null
            : DateTime.parse(json["order_date"]),
        isApproved: json["is_approved"],
        orderStatusId: json["order_status_id"],
        orderStatusName: json["order_status_name"] ?? 'pending',
        colorCode: json["color_code"],
        vendor: json["vendor"],
        vendorId: json["vendor_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_number": orderNumber,
        "sales_person": salesPerson,
        "route_name": routeName,
        "client": client,
        "client_id": clientId,
        "total": total,
        "logo": logo,
        "order_date": orderDate,
        "is_approved": isApproved,
        "order_status_id": orderStatusId,
        "order_status_name": orderStatusName,
        "color_code": colorCode,
        "vendor": vendor,
        "vendor_id": vendorId,
      };

  @override
  List<Object?> get props => [
        id,
        orderDate,
        salesPerson,
        orderNumber,
        routeName,
        orderStatusId,
        orderStatusName,
        logo,
        isApproved,
        colorCode,
        vendor,
        vendorId,
      ];
}

class TotalValues extends Equatable {
  final int? totalCount;
  final double? totalBillAmount;
  final double? totalPaidAmount;
  final double? totalDueAmount;

  TotalValues(
      {this.totalCount,
      this.totalBillAmount,
      this.totalDueAmount,
      this.totalPaidAmount});

  factory TotalValues.fromJson(Map<String, dynamic> json) => TotalValues(
        totalCount: json["total_count"],
        totalBillAmount: json["total_bill_amount"]?.toDouble(),
        totalPaidAmount: json["total_paid_amount"]?.toDouble(),
        totalDueAmount: json["total_due_amount"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "total_bill_amount": totalBillAmount,
        "total_paid_amount": totalPaidAmount,
        "total_due_amount": totalDueAmount,
      };

  @override
  List<Object?> get props =>
      [totalBillAmount, totalCount, totalDueAmount, totalPaidAmount];
}
