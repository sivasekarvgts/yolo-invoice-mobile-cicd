import 'dart:convert';

List<ItemTaxListModel> itemTaxListModelFromJson(String str) =>
    List<ItemTaxListModel>.from(
        json.decode(str).map((x) => ItemTaxListModel.fromJson(x)));

String itemTaxListModelToJson(List<ItemTaxListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItemTaxListModel {
  final int? id;
  final String? name;
  final double? value;
  final int? code;
  final bool? percentage;
  final bool? isEditable;
  final dynamic description;
  final bool? status;
  final bool? delete;
  final int? createdBy;

  ItemTaxListModel({
    this.id,
    this.name,
    this.value,
    this.code,
    this.percentage,
    this.isEditable,
    this.description,
    this.status,
    this.delete,
    this.createdBy,
  });

  factory ItemTaxListModel.fromJson(Map<String, dynamic> json) =>
      ItemTaxListModel(
        id: json["id"],
        name: json["name"]??json["reason"],
        value: json["value"]?.toDouble(),
        code: json["code"],
        percentage: json["percentage"],
        isEditable: json["is_editable"],
        description: json["description"],
        status: json["status"],
        delete: json["delete"],
        createdBy: json["created_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "value": value,
        "code": code,
        "percentage": percentage,
        "is_editable": isEditable,
        "description": description,
        "status": status,
        "delete": delete,
        "created_by": createdBy,
      };
}
