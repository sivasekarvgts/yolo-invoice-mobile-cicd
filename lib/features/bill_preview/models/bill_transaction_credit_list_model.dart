// To parse this JSON data, do
//
//     final transactionCreditListModel = transactionCreditListModelFromJson(jsonString);

import 'dart:convert';

BillTransactionCreditListModel transactionCreditListModelFromJson(String str) =>
    BillTransactionCreditListModel.fromJson(json.decode(str));

String transactionCreditListModelToJson(BillTransactionCreditListModel data) =>
    json.encode(data.toJson());

class BillTransactionCreditListModel {
  final List<Payment>? payments;
  final List<Credit>? credits;

  BillTransactionCreditListModel({
    this.payments,
    this.credits,
  });

  factory BillTransactionCreditListModel.fromJson(Map<String, dynamic> json) =>
      BillTransactionCreditListModel(
        payments: json["Payments"] == null
            ? []
            : List<Payment>.from(
                json["Payments"]!.map((x) => Payment.fromJson(x))),
        credits: json["Credits"] == null
            ? []
            : List<Credit>.from(
                json["Credits"]!.map((x) => Credit.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Payments": payments == null
            ? []
            : List<dynamic>.from(payments!.map((x) => x.toJson())),
        "Credits": credits == null
            ? []
            : List<dynamic>.from(credits!.map((x) => x.toJson())),
      };
}

class Credit {
  final int? id;
  final int? creditNote;
  final String? creditnoteNumber;
  final int? invoice;
  final String? invoiceNumber;
  final double? amount;
  final DateTime? date;

  Credit({
    this.id,
    this.creditNote,
    this.creditnoteNumber,
    this.invoice,
    this.invoiceNumber,
    this.amount,
    this.date,
  });

  factory Credit.fromJson(Map<String, dynamic> json) => Credit(
        id: json["id"],
        creditNote: json["credit_note"],
        creditnoteNumber: json["creditnote_number"],
        invoice: json["invoice"],
        invoiceNumber: json["invoice_number"],
        amount: json["amount"]?.toDouble(),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "credit_note": creditNote,
        "creditnote_number": creditnoteNumber,
        "invoice": invoice,
        "invoice_number": invoiceNumber,
        "amount": amount,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
      };
}

class Payment {
  final int? id;
  final int? paymentId;
  final String? paymentNumber;
  final dynamic referenceNumber;
  final DateTime? date;
  final int? paymentMode;
  final String? paymentModeName;
  final int? invoice;
  final String? invoiceNumber;
  final double? amount;

  Payment({
    this.id,
    this.paymentId,
    this.paymentNumber,
    this.referenceNumber,
    this.date,
    this.paymentMode,
    this.paymentModeName,
    this.invoice,
    this.invoiceNumber,
    this.amount,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"],
        paymentId: json["payment_id"],
        paymentNumber: json["payment_number"],
        referenceNumber: json["reference_number"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        paymentMode: json["payment_mode"],
        paymentModeName: json["payment_mode_name"],
        invoice: json["invoice"],
        invoiceNumber: json["invoice_number"],
        amount: json["amount"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "payment_id": paymentId,
        "payment_number": paymentNumber,
        "reference_number": referenceNumber,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "payment_mode": paymentMode,
        "payment_mode_name": paymentModeName,
        "invoice": invoice,
        "invoice_number": invoiceNumber,
        "amount": amount,
      };
}
