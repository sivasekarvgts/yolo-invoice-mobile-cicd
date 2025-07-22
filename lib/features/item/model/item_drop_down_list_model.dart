// To parse this JSON data, do
//
//     final itemCategoryListModel = itemCategoryListModelFromJson(jsonString);

import 'dart:convert';

List<ItemDropDownListModel> itemCategoryListModelFromJson(String str) =>
    List<ItemDropDownListModel>.from(
        json.decode(str).map((x) => ItemDropDownListModel.fromJson(x)));

String itemCategoryListModelToJson(List<ItemDropDownListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItemDropDownListModel {
  final int? id;
  final String? name;
  final double? code;
  final int? category;
  final dynamic description;
  final String? image;
  final dynamic parentId;
  final String? parent;
  final bool? status;
  final bool? delete;
  final int? createdBy;

  ItemDropDownListModel({
    this.id,
    this.name,
    this.code,
    this.category,
    this.description,
    this.image,
    this.parentId,
    this.parent,
    this.status,
    this.delete,
    this.createdBy,
  });

  factory ItemDropDownListModel.fromJson(Map<String, dynamic> json) =>
      ItemDropDownListModel(
        id: json["id"],
        name: json["name"],
        code: double.tryParse(json["code"].toString()) ?? 0.0,
        category: json["category"],
        description: json["description"],
        image: json["image"],
        parentId: json["parent_id"],
        parent: json["parent"],
        status: json["status"],
        delete: json["delete"],
        createdBy: json["created_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "category": category,
        "description": description,
        "image": image,
        "parent_id": parentId,
        "parent": parent,
        "status": status,
        "delete": delete,
        "created_by": createdBy,
      };
}
