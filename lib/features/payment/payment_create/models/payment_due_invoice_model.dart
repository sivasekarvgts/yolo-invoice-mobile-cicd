import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yoloworks_invoice/core/extension/currency_extension.dart';

import '../../../../core/extension/datetime_extension.dart';

PaymentDueInvoiceModel paymentDueInvoiceModelFromJson(String str) =>
    PaymentDueInvoiceModel.fromJson(json.decode(str));

String paymentDueInvoiceModelToJson(PaymentDueInvoiceModel data) =>
    json.encode(data.toJson());

class PaymentDueInvoiceModel {
  final int? id;
  final String? paymentNumber;
  final dynamic referenceNumber;
  final int? clientId;
  final String? client;
  final String? clientPhone;
  final double? clientBalance;
  final String? vendorId;
  final String? vendor;
  final String? vendorPhone;
  final String? vendorBalance;
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
  final int? createdBy;
  final bool? status;
  final String? logo;
  final int? unpaidBill;
  final List<PaymentInvoice>? data;

  PaymentDueInvoiceModel({
    this.id,
    this.paymentNumber,
    this.referenceNumber,
    this.clientId,
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
    this.createdBy,
    this.status,
    this.logo,
    this.unpaidBill,
    this.data,
  });

  String get billDateFormat =>
      date == null ? '' : DateFormates.monthDayYearFormat.format(date!);
  String get chequeDateFormat => chequeDate == null
      ? ''
      : DateFormates.monthDayYearFormat.format(chequeDate!);
  String get receivedAmt => (receivedAmount ?? 0).toCurrencyFormatString();
  String get excessAmt => (excessAmount ?? 0).toCurrencyFormatString();
  String get usedAmt => (utilizedAmount ?? 0).toCurrencyFormatString();

  factory PaymentDueInvoiceModel.fromJson(Map<String, dynamic> json) =>
      PaymentDueInvoiceModel(
        id: json["id"],
        paymentNumber: json["payment_number"],
        referenceNumber: json["reference_number"],
        clientId: json["client_id"],
        client: json["client"],
        clientPhone: json["client_phone"],
        clientBalance: json["client_balance"]?.toDouble(),
        vendorId: json["vendor_id"],
        vendor: json["vendor"],
        vendorPhone: json["vendor_phone"],
        vendorBalance: json["vendor_balance"],
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
        createdBy: json["created_by"],
        status: json["status"],
        logo: json["logo"],
        unpaidBill: json["unpaid_bill"],
        data: json["data"] == null
            ? json["invoice_details"] == null
                ? []
                : List<PaymentInvoice>.from((json["invoice_details"] as List)
                    .where((t) => t != null)
                    .map((x) => PaymentInvoice.fromJson(x)))
            : List<PaymentInvoice>.from(
                json["data"]!.map((x) => PaymentInvoice.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
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
        "created_by": createdBy,
        "status": status,
        "logo": logo,
        "unpaid_bill": unpaidBill,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class PaymentInvoice {
  int? id;
  double? total;
  double? balanceDue;
  final String? billDate;
  final String? invoiceNumber;
  final bool? isOpeningBalance;
  final int? paymentId;
  final int? invoice;
  final int? dueStatusId;
  double? amount;
  final int? clientId;
  final String? client;
  final dynamic vendorId;
  final dynamic vendor;
  final String? dueStatus;
  final String? colorCode;
  double? datumSubTotal;
  double? subTotal;
  final String? billStatus;
  double? receivedAmt;
  TextEditingController? textCtrlValue;

  PaymentInvoice({
    this.billDate,
    this.balanceDue,
    this.total,
    this.invoiceNumber,
    this.isOpeningBalance,
    this.id,
    this.paymentId,
    this.invoice,
    this.dueStatusId,
    this.amount,
    this.clientId,
    this.client,
    this.vendorId,
    this.vendor,
    this.dueStatus,
    this.colorCode,
    this.datumSubTotal,
    this.receivedAmt,
    this.subTotal,
    this.billStatus,
  }) : textCtrlValue = TextEditingController();

  String get balanceAmtCurrencyFormat => balanceDue != null
      ? double.parse(balanceDue.toString()).toCurrencyFormatString()
      : 0.0.toCurrencyFormatString();

  factory PaymentInvoice.fromJson(Map<String, dynamic> json) => PaymentInvoice(
        billDate: json["bill_date"],
        balanceDue: json["balance_due"]?.toDouble(),
        total: json["total"]?.toDouble(),
        receivedAmt: json["received_amt"]?.toDouble(),
        invoiceNumber: json["invoice_number"],
        isOpeningBalance: json["is_opening_balance"],
        id: json["id"],
        clientId: json["client_id"],
        client: json["client"],
        vendorId: json["vendor_id"],
        vendor: json["vendor"],
        dueStatus: json["due_status"],
        colorCode: json["color_code"],
        datumSubTotal: json["sub_total"]?.toDouble(),
        subTotal: json["_sub_total"]?.toDouble(),
        billStatus: json["bill_status"],
        paymentId: json["payment_id"],
        invoice: json["invoice"],
        dueStatusId: json["due_status_id"],
        amount: json["amount"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "bill_date": billDate,
        "balance_due": balanceDue,
        "total": total,
        "received_amt": receivedAmt,
        "invoice_number": invoiceNumber,
        "is_opening_balance": isOpeningBalance,
        "id": id,
        "client_id": clientId,
        "client": client,
        "vendor_id": vendorId,
        "vendor": vendor,
        "due_status": dueStatus,
        "color_code": colorCode,
        "sub_total": datumSubTotal,
        "_sub_total": subTotal,
        "bill_status": billStatus,
        "payment_id": paymentId,
        "invoice": invoice,
        "due_status_id": dueStatusId,
        "amount": amount,
      };
}
