// To parse this JSON data, do
//
//     final paymentRetrieveModel = paymentRetrieveModelFromJson(jsonString);

import 'dart:convert';

import 'package:yoloworks_invoice/core/extension/currency_extension.dart';

import '../../../../core/extension/datetime_extension.dart';
import '../../../../utils/json_builder.dart';

PaymentRetrieveModel paymentRetrieveModelFromJson(String str) =>
    PaymentRetrieveModel.fromJson(json.decode(str));

String paymentRetrieveModelToJson(PaymentRetrieveModel data) =>
    json.encode(data.toJson());

class PaymentRetrieveModel with JsonBuilderMixin {
  final int? id;
  final String? paymentNumber;
  final String? referenceNumber;
  final int? clientId;
  final String? client;
  final String? clientPhone;
  final double? clientBalance;
  final int? vendorId;
  final int? account;
  final String? vendor;
  final String? vendorPhone;
  final double? vendorBalance;
  final String? image;
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
  final int? createdBy;
  final bool? status;

  PaymentRetrieveModel({
    this.id,
    this.paymentNumber,
    this.referenceNumber,
    this.clientId,
    this.account,
    this.client,
    this.clientPhone,
    this.clientBalance,
    this.vendorId,
    this.vendor,
    this.vendorPhone,
    this.vendorBalance,
    this.image,
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
    this.createdBy,
    this.status,
  });

  String get billDateFormat =>
      date == null ? '' : DateFormates.monthDayYearFormat.format(date!);
  String get chequeDateFormat => chequeDate == null
      ? ''
      : DateFormates.monthDayYearFormat.format(chequeDate!);
  String get receivedAmt => (receivedAmount ?? 0).toCurrencyFormatString();
  String get excessAmt => (excessAmount ?? 0).toCurrencyFormatString();
  String get usedAmt => (utilizedAmount ?? 0).toCurrencyFormatString();

  factory PaymentRetrieveModel.fromJson(Map<String, dynamic> json) =>
      PaymentRetrieveModel(
        id: json["id"],
        paymentNumber: json["payment_number"],
        referenceNumber: json["reference_number"],
        clientId: json["client_id"] != ''
            ? int.parse(json["client_id"].toString())
            : null,
        client: json["client"],
        account: json["account"],
        clientPhone: json["client_phone"],
        clientBalance: json["client_balance"] != ''
            ? json["client_balance"]?.toDouble()
            : null,
        vendorId: json["vendor_id"] != ''
            ? int.parse(json["vendor_id"].toString())
            : null,
        vendor: json["vendor"],
        vendorPhone: json["vendor_phone"],
        vendorBalance: json["vendor_balance"] != ''
            ? json["vendor_balance"]?.toDouble()
            : null,
        image: json["image"],
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
        invoiceDetails: json["invoice_details"] == null
            ? []
            : List<InvoiceDetail>.from((json["invoice_details"] as List)
                .where((t) => t != null)
                .map((x) => InvoiceDetail.fromJson(x))),
        createdBy: json["created_by"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "account": account,
        "payment_number": paymentNumber,
        "reference_number": referenceNumber,
        "client_id": clientId,
        "client": client,
        "client_phone": clientPhone,
        "client_balance": clientBalance,
        "vendor_id": vendorId,
        "vendor": vendor,
        "vendor_phone": vendorPhone,
        "vendor_balance": vendorBalance,
        "image": image,
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
            : List<dynamic>.from(invoiceDetails!.map((x) => x.toJson())),
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
  final double? total;
  final double? balanceDue;
  final String? dueStatus;
  final int? dueStatusId;
  final double? amount;

  InvoiceDetail({
    this.id,
    this.paymentId,
    this.invoice,
    this.invoiceNumber,
    this.billDate,
    this.total,
    this.balanceDue,
    this.dueStatus,
    this.dueStatusId,
    this.amount,
  });

  String get balanceAmtCurrencyFormat => balanceDue != null
      ? double.parse(balanceDue.toString()).toCurrencyFormatString()
      : 0.0.toCurrencyFormatString();

  factory InvoiceDetail.fromJson(Map<String, dynamic> json) => InvoiceDetail(
        id: json["id"],
        paymentId: json["payment_id"],
        invoice: json["invoice"],
        invoiceNumber: json["invoice_number"],
        billDate: json["bill_date"] == null
            ? null
            : DateTime.parse(json["bill_date"]),
        total: json["total"]?.toDouble(),
        balanceDue: json["balance_due"]?.toDouble(),
        dueStatus: json["due_status"],
        dueStatusId: json["due_status_id"],
        amount: json["amount"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "payment_id": paymentId,
        "invoice": invoice,
        "invoice_number": invoiceNumber,
        "bill_date":
            "${billDate!.year.toString().padLeft(4, '0')}-${billDate!.month.toString().padLeft(2, '0')}-${billDate!.day.toString().padLeft(2, '0')}",
        "total": total,
        "balance_due": balanceDue,
        "due_status": dueStatus,
        "due_status_id": dueStatusId,
        "amount": amount,
      };
}
