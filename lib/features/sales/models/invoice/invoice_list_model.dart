import 'dart:convert';
import 'dart:ui';

import 'package:yoloworks_invoice/app/styles/colors.dart';
import 'package:yoloworks_invoice/core/extension/color_extension.dart';
import 'package:yoloworks_invoice/core/extension/datetime_extension.dart';

InvoiceListModel salesInvoiceListModelFromJson(String str) =>
    InvoiceListModel.fromJson(json.decode(str));

String salesInvoiceListModelToJson(InvoiceListModel data) =>
    json.encode(data.toJson());

class InvoiceListModel {
  final int? count;
  final int? numPages;
  final int? pageSize;
  final int? currentPage;
  final List<int>? pageRange;
  final List<InvoiceList>? data;
  final TotalValues? totalValues;

  InvoiceListModel({
    this.count,
    this.numPages,
    this.pageSize,
    this.currentPage,
    this.pageRange,
    this.data,
    this.totalValues,
  });

  factory InvoiceListModel.fromJson(Map<String, dynamic> json) =>
      InvoiceListModel(
        count: json["count"],
        numPages: json["num_pages"],
        pageSize: json["page_size"],
        currentPage: json["current_page"],
        pageRange: json["page_range"] == null
            ? []
            : List<int>.from(json["page_range"]!.map((x) => x)),
        data: json["data"] == null
            ? []
            : List<InvoiceList>.from(
                json["data"]!.map((x) => InvoiceList.fromJson(x))),
        totalValues: json["total_values"] == null
            ? null
            : TotalValues.fromJson(json["total_values"]),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "num_pages": numPages,
        "page_size": pageSize,
        "current_page": currentPage,
        "page_range": pageRange == null
            ? []
            : List<dynamic>.from(pageRange!.map((x) => x)),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "total_values": totalValues?.toJson(),
      };
}

class InvoiceList {
  final int? id;
  final String? invoiceNumber;
  final dynamic routeName;
  final String? client;
  final String? vendor;
  final int? vendorId;
  final int? clientId;
  String? dueStatus;
  final String? colorCode;
  final double? total;
  final String? logo;
  final DateTime? billDate;
  final int? billStatus;
  final String? comments;
  final double? paidAmount;
  final double? balanceDue;

  InvoiceList({
    this.id,
    this.invoiceNumber,
    this.routeName,
    this.client,
    this.vendor,
    this.vendorId,
    this.clientId,
    this.dueStatus,
    this.colorCode,
    this.total,
    this.logo,
    this.billDate,
    this.billStatus,
    this.comments,
    this.paidAmount,
    this.balanceDue,
  });

  String? get dueStatusName {
    if (billStatus == 4 || (balanceDue ?? 0) < 0) {
      return "Paid";
    }
    return dueStatus;
  }

  Color? get colorValue {
    if (billStatus == 4 || !((balanceDue ?? 0) > 0)) {
      dueStatus = "Paid";
      return AppColors.lightGreenColor;
    }
    return colorCode?.toGetColor();
  }

  String? get dateFormatted => billDate?.toFormattedYearMonthDate();

  factory InvoiceList.fromJson(Map<String, dynamic> json) => InvoiceList(
        id: json["id"],
        invoiceNumber: json["invoice_number"],
        routeName: json["route_name"],
        client: json["client"],
        vendor: json["vendor"],
        vendorId: json["vendor_id"],
        clientId: json["client_id"],
        dueStatus: json["due_status"],
        colorCode: json["color_code"],
        total: json["total"]?.toDouble(),
        logo: json["logo"],
        billDate: json["bill_date"] == null
            ? null
            : DateTime.parse(json["bill_date"]),
        billStatus: json["bill_status"],
        comments: json["comments"],
        paidAmount: json["paid_amount"]?.toDouble(),
        balanceDue: json["balance_due"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "invoice_number": invoiceNumber,
        "route_name": routeName,
        "client": client,
        "vendor": vendor,
        "vendor_id": vendorId,
        "client_id": clientId,
        "due_status": dueStatus,
        "color_code": colorCode,
        "total": total,
        "logo": logo,
        "bill_date":
            "${billDate!.year.toString().padLeft(4, '0')}-${billDate!.month.toString().padLeft(2, '0')}-${billDate!.day.toString().padLeft(2, '0')}",
        "bill_status": billStatus,
        "comments": comments,
        "paid_amount": paidAmount,
        "balance_due": balanceDue,
      };
}

class TotalValues {
  final int? totalCount;
  final double? totalBillAmount;
  final double? totalPaidAmount;
  final double? totalDueAmount;

  TotalValues({
    this.totalCount,
    this.totalBillAmount,
    this.totalPaidAmount,
    this.totalDueAmount,
  });

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
}
