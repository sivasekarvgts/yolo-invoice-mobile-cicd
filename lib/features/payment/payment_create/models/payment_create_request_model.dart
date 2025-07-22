import 'dart:convert';

import '../../../../utils/json_builder.dart';

PaymentCreateRequestModel paymentCreateRequestModelFromJson(String str) =>
    PaymentCreateRequestModel.fromJson(json.decode(str));

String paymentCreateRequestModelToJson(PaymentCreateRequestModel data) =>
    json.encode(data.toJson());

class PaymentCreateRequestModel with JsonBuilderMixin {
  List<Invoice>? invoices;
  String? date;
  String? receivableAmount;
  int? paymentMode;
  String? notes;
  int? clientId;
  int? vendorId;
  int? account;
  String? amountInExcess;
  String? chequeNumber;
  String? chequeDate;
  String? referenceNumber;
  String? transactionId;

  PaymentCreateRequestModel({
    this.invoices,
    this.date,
    this.receivableAmount,
    this.paymentMode,
    this.account,
    this.notes,
    this.clientId,
    this.vendorId,
    this.amountInExcess,
    this.chequeNumber,
    this.chequeDate,
    this.referenceNumber,
    this.transactionId,
  });

  factory PaymentCreateRequestModel.fromJson(Map<String, dynamic> json) =>
      PaymentCreateRequestModel(
        invoices: json["invoices"] == null
            ? []
            : List<Invoice>.from(
                json["invoices"]!.map((x) => Invoice.fromJson(x))),
        date: json["date"],
        receivableAmount: json["receivable_amount"],
        paymentMode: json["payment_mode"],
        notes: json["notes"],
        clientId: json["client_id"],
        amountInExcess: json["amount_in_excess"],
        chequeNumber: json["cheque_number"],
        chequeDate: json["cheque_date"],
        referenceNumber: json["reference_number"],
        transactionId: json["transaction_id"],
      );

  Map<String, dynamic> toJson([bool isReq = false]) => buildJson({
        "invoices": invoices == null
            ? []
            : List<dynamic>.from(
                invoices!.map((x) => isReq ? x.toReqJson() : x.toJson())),
        "date": date,
        "account": account,
        "receivable_amount": receivableAmount,
        "payment_mode": paymentMode,
        "notes": notes,
        "client_id": clientId,
        "vendor_id": vendorId,
        "amount_in_excess": amountInExcess,
        "cheque_number": chequeNumber,
        "cheque_date": chequeDate,
        "reference_number": referenceNumber,
        "transaction_id": transactionId,
   });
}

class Invoice {
  String? amount;
  int? invoice;

  Invoice({
    this.amount,
    this.invoice,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
        amount: json["amount"],
        invoice: json["invoice"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "invoice": invoice,
      };

  Map<String, dynamic> toReqJson() => {
        "amount": amount,
        if (invoice != null) 'invoice': invoice,
      };
}
