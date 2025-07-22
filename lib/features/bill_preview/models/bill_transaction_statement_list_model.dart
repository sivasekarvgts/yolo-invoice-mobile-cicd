// To parse this JSON data, do
//
//     final transactionStatementListModel = transactionStatementListModelFromJson(jsonString);

import 'dart:convert';

List<BillTransactionStatementListModel> transactionStatementListModelFromJson(
        String str) =>
    List<BillTransactionStatementListModel>.from(json
        .decode(str)
        .map((x) => BillTransactionStatementListModel.fromJson(x)));

String transactionStatementListModelToJson(
        List<BillTransactionStatementListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BillTransactionStatementListModel {
  final int? id;
  final int? branchId;
  final String? branch;

  // TODO id to int
  final dynamic clientId;
  final String? client;
  final String? clientLogo;
  final dynamic vendorId;
  final String? vendor;
  final String? vendorLogo;
  final int? invoiceId;
  final String? invoiceNo;
  final String? orderId;
  final dynamic orderNo;
  final dynamic paymentId;
  final dynamic invoicePayment;
  final String? paymentNo;
  final double? receivedAmount;
  final double? amount;
  final double? balance;
  final String? description;
  final int? transactionTypeId;
  final String? transactionType;
  final String? created;
  final DateTime? date;
  final int? createdBy;

  BillTransactionStatementListModel({
    this.id,
    this.branchId,
    this.branch,
    this.clientId,
    this.client,
    this.clientLogo,
    this.vendorId,
    this.vendor,
    this.vendorLogo,
    this.invoiceId,
    this.invoiceNo,
    this.orderId,
    this.orderNo,
    this.paymentId,
    this.invoicePayment,
    this.paymentNo,
    this.receivedAmount,
    this.amount,
    this.balance,
    this.description,
    this.transactionTypeId,
    this.transactionType,
    this.created,
    this.date,
    this.createdBy,
  });

  factory BillTransactionStatementListModel.fromJson(
          Map<String, dynamic> json) =>
      BillTransactionStatementListModel(
        id: json["id"],
        branchId: json["branch_id"],
        branch: json["branch"],
        clientId: json["client_id"],
        client: json["client"],
        clientLogo: json["client_logo"],
        vendorId: json["vendor_id"],
        vendor: json["vendor"],
        vendorLogo: json["vendor_logo"],
        invoiceId: json["invoice_id"],
        invoiceNo: json["invoice_no"],
        orderId: json["order_id"],
        orderNo: json["order_no"],
        paymentId: json["payment_id"],
        invoicePayment: json["invoice_payment"],
        paymentNo: json["payment_no"],
        receivedAmount: json["received_amount"]?.toDouble(),
        amount: json["amount"]?.toDouble(),
        balance: json["balance"]?.toDouble(),
        description: json["description"],
        transactionTypeId: json["transaction_type_id"],
        transactionType: json["transaction_type"],
        created: json["created"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        createdBy: json["created_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "branch_id": branchId,
        "branch": branch,
        "client_id": clientId,
        "client": client,
        "client_logo": clientLogo,
        "vendor_id": vendorId,
        "vendor": vendor,
        "vendor_logo": vendorLogo,
        "invoice_id": invoiceId,
        "invoice_no": invoiceNo,
        "order_id": orderId,
        "order_no": orderNo,
        "payment_id": paymentId,
        "invoice_payment": invoicePayment,
        "payment_no": paymentNo,
        "received_amount": receivedAmount,
        "amount": amount,
        "balance": balance,
        "description": description,
        "transaction_type_id": transactionTypeId,
        "transaction_type": transactionType,
        "created": created,
        "date": date?.toIso8601String(),
        "created_by": createdBy,
      };
}
