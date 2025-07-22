// To parse this JSON data, do
//
//     final transportModeModel = transportModeModelFromJson(jsonString);

import 'dart:convert';

List<TransportModeModel> transportModeModelFromJson(String str) => List<TransportModeModel>.from(json.decode(str).map((x) => TransportModeModel.fromJson(x)));

String transportModeModelToJson(List<TransportModeModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransportModeModel {
  final int? id;
  final String? name;
  final String? description;
  final int? code;
  final bool? status;
  final bool? delete;

  TransportModeModel({
    this.id,
    this.name,
    this.description,
    this.code,
    this.status,
    this.delete,
  });

  factory TransportModeModel.fromJson(Map<String, dynamic> json) => TransportModeModel(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    code: json["code"],
    status: json["status"],
    delete: json["delete"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "code": code,
    "status": status,
    "delete": delete,
  };
}
