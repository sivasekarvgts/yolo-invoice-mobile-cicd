// To parse this JSON data, do
//
//     final itemUnitsListModel = itemUnitsListModelFromJson(jsonString);

import 'dart:convert';

List<ItemUnitsListModel> itemUnitsListModelFromJson(String str) =>
    List<ItemUnitsListModel>.from(
        json.decode(str).map((x) => ItemUnitsListModel.fromJson(x)));

String itemUnitsListModelToJson(List<ItemUnitsListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItemUnitsListModel {
  final int? id;
  final String? name;
  final int? quantity;
  final int? code;
  final int? relatedUnitId;
  final String? relatedUnit;
  final int? conversionRate;
  final String? description;
  final bool? status;
  final bool? delete;
  final int? createdBy;

  ItemUnitsListModel({
    this.id,
    this.name,
    this.quantity,
    this.code,
    this.relatedUnitId,
    this.relatedUnit,
    this.conversionRate,
    this.description,
    this.status,
    this.delete,
    this.createdBy,
  });

  factory ItemUnitsListModel.fromJson(Map<String, dynamic> json) =>
      ItemUnitsListModel(
        id: json["id"],
        name: json["name"],
        quantity: json["quantity"],
        code: json["code"],
        relatedUnitId: json["related_unit_id"],
        relatedUnit: json["related_unit"],
        conversionRate: json["conversion_rate"],
        description: json["description"],
        status: json["status"],
        delete: json["delete"],
        createdBy: json["created_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "quantity": quantity,
        "code": code,
        "related_unit_id": relatedUnitId,
        "related_unit": relatedUnit,
        "conversion_rate": conversionRate,
        "description": description,
        "status": status,
        "delete": delete,
        "created_by": createdBy,
      };
}
