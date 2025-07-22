import 'dart:convert';

import 'package:equatable/equatable.dart';

List<CategoriesModel> categoriesModelFromJson(String str) =>
    List<CategoriesModel>.from(
        json.decode(str).map((x) => CategoriesModel.fromJson(x)));

String categoriesModelToJson(List<CategoriesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoriesModel extends Equatable {
  final int? id;
  final String? name;
  final String? code;
  final String? description;
  final String? image;
  final int? parent;
  final bool? status;
  final bool? delete;
  final int? createdBy;

  CategoriesModel({
    this.id,
    this.name,
    this.code,
    this.description,
    this.image,
    this.parent,
    this.status,
    this.delete,
    this.createdBy,
  });

  CategoriesModel fromJson(json) => CategoriesModel.fromJson(json);

  factory CategoriesModel.fromJson(Map<String, dynamic> json) =>
      CategoriesModel(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        description: json["description"],
        image: json["image"],
        parent: json["parent"],
        status: json["status"],
        delete: json["delete"],
        createdBy: json["created_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "description": description,
        "image": image,
        "parent": parent,
        "status": status,
        "delete": delete,
        "created_by": createdBy,
      };

  @override
  // TODO: implement props
  List<Object?> get props =>
      [id, name, code, description, image, parent, status, delete, createdBy];
}
