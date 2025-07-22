import 'dart:convert';

import 'package:yoloworks_invoice/core/extension/currency_extension.dart';

import '../../../../core/extension/datetime_extension.dart';
import '../../../../core/models/address_detail.dart';

PaymentDetailModel paymentDetailModelFromJson(String str) =>
    PaymentDetailModel.fromJson(json.decode(str));

String paymentDetailModelToJson(PaymentDetailModel data) =>
    json.encode(data.toJson());

class PaymentDetailModel {
  final int? id;
  final String? paymentNumber;
  final String? referenceNumber;
  final dynamic clientId;
  final String? client;
  final String? clientPhone;
  final dynamic vendorId;
  final String? vendor;
  final String? vendorPhone;
  final String? image;
  final List<AddressDetail>? addressDetail;
  final DateTime? date;
  final int? paymentMode;
  final String? paymentModeName;
  final double? receivedAmount;
  final double? excessAmount;
  final double? utilizedAmount;
  final String? transactionId;
  final String? chequeNumber;
  final DateTime? chequeDate;
  final List<InvoiceDetail>? invoiceDetails;
  final List<InvoiceTimeline>? invoiceTimeline;
  final int? createdBy;
  final bool? status;

  PaymentDetailModel({
    this.id,
    this.paymentNumber,
    this.referenceNumber,
    this.clientId,
    this.client,
    this.clientPhone,
    this.vendorId,
    this.vendor,
    this.vendorPhone,
    this.image,
    this.addressDetail,
    this.date,
    this.paymentMode,
    this.paymentModeName,
    this.receivedAmount,
    this.excessAmount,
    this.utilizedAmount,
    this.transactionId,
    this.chequeNumber,
    this.chequeDate,
    this.invoiceDetails,
    this.invoiceTimeline,
    this.createdBy,
    this.status,
  });

  String get billDate => DateFormates.ddMMMYYFormat.format(date!);

  String get receivedAmt => (receivedAmount ?? 0).toCurrencyFormatString();

  String get excessAmt => (excessAmount ?? 0).toCurrencyFormatString();

  String get usedAmt => (utilizedAmount ?? 0).toCurrencyFormatString();

  factory PaymentDetailModel.fromJson(Map<String, dynamic> json) =>
      PaymentDetailModel(
        id: json["id"],
        paymentNumber: json["payment_number"],
        referenceNumber: json["reference_number"],
        clientId: json["client_id"],
        client: json["client"],
        clientPhone: json["client_phone"],
        vendorId: json["vendor_id"],
        vendor: json["vendor"],
        vendorPhone: json["vendor_phone"],
        image: json["image"],
        addressDetail: json["address_detail"] == null
            ? []
            : List<AddressDetail>.from(
                json["address_detail"]!.map((x) => AddressDetail.fromJson(x))),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        paymentMode: json["payment_mode"],
        paymentModeName: json["payment_mode_name"],
        receivedAmount: json["received_amount"]?.toDouble(),
        excessAmount: json["excess_amount"]?.toDouble(),
        utilizedAmount: json["utilized_amount"]?.toDouble(),
        transactionId: json["transaction_id"],
        chequeNumber: json["cheque_number"],
        chequeDate: json["cheque_date"] == null
            ? null
            : DateTime.parse(json["cheque_date"]),
        invoiceDetails:
            json["invoice_details"] == null && json["invoice_details"] == [null]
                ? []
                : List<InvoiceDetail>.from((json["invoice_details"] as List)
                    .where((t) => t != null)
                    .map((x) => InvoiceDetail.fromJson(x))),
        invoiceTimeline: json["invoice_timeline"] == null
            ? []
            : List<InvoiceTimeline>.from(json["invoice_timeline"]!
                .map((x) => InvoiceTimeline.fromJson(x))),
        createdBy: json["created_by"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "payment_number": paymentNumber,
        "reference_number": referenceNumber,
        "client_id": clientId,
        "client": client,
        "client_phone": clientPhone,
        "vendor_id": vendorId,
        "vendor": vendor,
        "vendor_phone": vendorPhone,
        "image": image,
        "address_detail": addressDetail == null
            ? []
            : List<dynamic>.from(addressDetail!.map((x) => x.toJson())),
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "payment_mode": paymentMode,
        "payment_mode_name": paymentModeName,
        "received_amount": receivedAmount,
        "excess_amount": excessAmount,
        "utilized_amount": utilizedAmount,
        "transaction_id": transactionId,
        "cheque_number": chequeNumber,
        "cheque_date":
            "${chequeDate!.year.toString().padLeft(4, '0')}-${chequeDate!.month.toString().padLeft(2, '0')}-${chequeDate!.day.toString().padLeft(2, '0')}",
        "invoice_details": invoiceDetails == null
            ? []
            : List<dynamic>.from(invoiceDetails!.map((x) => x?.toJson())),
        "invoice_timeline": invoiceTimeline == null
            ? []
            : List<dynamic>.from(invoiceTimeline!.map((x) => x.toJson())),
        "created_by": createdBy,
        "status": status,
      };
}

class InvoiceDetail {
  final int? id;
  final int? paymentId;
  final int? invoice;
  final String? invoiceNumber;
  final DateTime? billDate;
  final DateTime? dueDate;
  final List<ItemDetail>? itemDetails;
  final double? total;
  final double? balanceDue;
  final String? dueStatus;
  final int? dueStatusId;
  final double? amount;
  final String? description;

  InvoiceDetail({
    this.id,
    this.paymentId,
    this.invoice,
    this.invoiceNumber,
    this.billDate,
    this.dueDate,
    this.itemDetails,
    this.total,
    this.balanceDue,
    this.dueStatus,
    this.dueStatusId,
    this.amount,
    this.description,
  });

  String get billDateFormat => DateFormates.billDateFormat.format(billDate!);

  String get dueDateFormat => DateFormates.billDateFormat.format(dueDate!);

  String get balanceDueAmt => (balanceDue ?? 0).toCurrencyFormatString();

  String get receivedAmt => (amount ?? 0).toCurrencyFormatString();

  factory InvoiceDetail.fromJson(Map<String, dynamic> json) => InvoiceDetail(
        id: json["id"],
        paymentId: json["payment_id"],
        invoice: json["invoice"],
        invoiceNumber: json["invoice_number"],
        billDate: json["bill_date"] == null
            ? null
            : DateTime.parse(json["bill_date"]),
        dueDate:
            json["due_date"] == null ? null : DateTime.parse(json["due_date"]),
        itemDetails: json["item_details"] == null
            ? []
            : List<ItemDetail>.from(
                json["item_details"]!.map((x) => ItemDetail.fromJson(x))),
        total: json["total"]?.toDouble(),
        balanceDue: json["balance_due"]?.toDouble(),
        dueStatus: json["due_status"],
        dueStatusId: json["due_status_id"],
        amount: json["amount"]?.toDouble(),
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "payment_id": paymentId,
        "invoice": invoice,
        "invoice_number": invoiceNumber,
        "bill_date":
            "${billDate!.year.toString().padLeft(4, '0')}-${billDate!.month.toString().padLeft(2, '0')}-${billDate!.day.toString().padLeft(2, '0')}",
        "due_date":
            "${dueDate!.year.toString().padLeft(4, '0')}-${dueDate!.month.toString().padLeft(2, '0')}-${dueDate!.day.toString().padLeft(2, '0')}",
        "item_details": itemDetails == null
            ? []
            : List<dynamic>.from(itemDetails!.map((x) => x.toJson())),
        "total": total,
        "balance_due": balanceDue,
        "due_status": dueStatus,
        "due_status_id": dueStatusId,
        "amount": amount,
        "description": description,
      };
}

class ItemDetail {
  final int? pk;

  ItemDetail({
    this.pk,
  });

  factory ItemDetail.fromJson(Map<String, dynamic> json) => ItemDetail(
        pk: json["pk"],
      );

  Map<String, dynamic> toJson() => {
        "pk": pk,
      };
}

class InvoiceTimeline {
  final int? id;
  final DateTime? created;
  final String? description;

  InvoiceTimeline({
    this.id,
    this.created,
    this.description,
  });

  factory InvoiceTimeline.fromJson(Map<String, dynamic> json) =>
      InvoiceTimeline(
        id: json["id"],
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created": created?.toIso8601String(),
        "description": description,
      };
}
