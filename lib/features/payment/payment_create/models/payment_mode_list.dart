import 'dart:convert';

List<PaymentModeList> paymentModeListFromJson(String str) =>
    List<PaymentModeList>.from(
        json.decode(str).map((x) => PaymentModeList.fromJson(x)));

String paymentModeListToJson(List<PaymentModeList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaymentModeList {
  final int? id;
  final String? name;
  final String? description;
  final int? code;
  final bool? status;
  final bool? delete;

  PaymentModeList({
    this.id,
    this.name,
    this.description,
    this.code,
    this.status,
    this.delete,
  });

  factory PaymentModeList.fromJson(Map<String, dynamic> json) =>
      PaymentModeList(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        status: json["status"],
        delete: json["delete"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "status": status,
        "delete": delete,
        "description": description,
      };
}
