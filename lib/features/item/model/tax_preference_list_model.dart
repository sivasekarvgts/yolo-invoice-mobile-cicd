// To parse this JSON data, do
//
//     final taxPreferenceListModel = taxPreferenceListModelFromJson(jsonString);

import 'dart:convert';

List<TaxPreferenceListModel> taxPreferenceListModelFromJson(String str) =>
    List<TaxPreferenceListModel>.from(
        json.decode(str).map((x) => TaxPreferenceListModel.fromJson(x)));

String taxPreferenceListModelToJson(List<TaxPreferenceListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TaxPreferenceListModel {
  final int? id;
  final String? name;
  final int? code;
  final String? description;
  final bool? status;
  final bool? delete;
  final int? createdBy;

  TaxPreferenceListModel({
    this.id,
    this.name,
    this.code,
    this.description,
    this.status,
    this.delete,
    this.createdBy,
  });

  factory TaxPreferenceListModel.fromJson(Map<String, dynamic> json) =>
      TaxPreferenceListModel(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        description: json["description"],
        status: json["status"],
        delete: json["delete"],
        createdBy: json["created_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "description": description,
        "status": status,
        "delete": delete,
        "created_by": createdBy,
      };
}
