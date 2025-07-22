// To parse this JSON data, do
//
//     final salesPersonListModel = salesPersonListModelFromJson(jsonString);

import 'dart:convert';

List<SalesPersonListModel> salesPersonListModelFromJson(String str) => List<SalesPersonListModel>.from(json.decode(str).map((x) => SalesPersonListModel.fromJson(x)));

String salesPersonListModelToJson(List<SalesPersonListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SalesPersonListModel {
  final String? username;
  final int? id;
  final String? name;

  SalesPersonListModel({
    this.username,
    this.id,
    this.name,
  });

  factory SalesPersonListModel.fromJson(Map<String, dynamic> json) => SalesPersonListModel(
    username: json["username"],
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "id": id,
    "name": name,
  };
}
