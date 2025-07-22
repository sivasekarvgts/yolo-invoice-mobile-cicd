import 'dart:convert';

import 'package:equatable/equatable.dart';

List<TypeModel> typeModelFromJson(String str) =>
    List<TypeModel>.from(json.decode(str).map((x) => TypeModel.fromJson(x)));

String typeModelToJson(List<TypeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TypeModel extends Equatable {
  final int? id;
  final bool? status;
  final bool? delete;
  final String? name;
  final String? code;
  final int? createdBy;
  final int? days;
  final String? description;
  final String? businessType;

  TypeModel(
      {this.id,
      this.createdBy,
      this.name,
      this.days,
      this.description,
      this.businessType,
      this.code,
      this.status,
      this.delete});

  factory TypeModel.fromJson(Map<String, dynamic> json) => TypeModel(
      id: json["id"],
      createdBy: json["created_by"],
      name: json["name"],
      days: json["days"],
      description: json["description"],
      businessType: json["business_type"] == null
          ? null
          : json["business_type"].toString(),
      code: json["code"] == null ? null : json["code"].toString(),
      status: json["status"],
      delete: json["delete"]);

  TypeModel fromJson(json) => TypeModel.fromJson(json);

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_by": createdBy,
        "days": days,
        "name": name,
        "description": description,
        "business_type": businessType,
        "code": code,
        "status": status,
        "delete": delete
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is TypeModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => super.hashCode ^ id.hashCode;

  @override
  List<Object?> get props => [
        id,
        createdBy,
        days,
        name,
        description,
        businessType,
        code,
        status,
        delete
      ];
}
