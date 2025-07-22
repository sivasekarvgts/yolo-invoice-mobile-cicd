import 'dart:convert';

import 'package:equatable/equatable.dart';

List<DuePeriodListModel> duePeriodListModelFromJson(String str) =>
    List<DuePeriodListModel>.from(
        json.decode(str).map((x) => DuePeriodListModel.fromJson(x)));

String duePeriodListModelToJson(List<DuePeriodListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DuePeriodListModel extends Equatable {
  final int? id;
  final String? name;
  final int? days;
  final String? description;
  final int? code;
  final int? createdBy;
  final bool? status;
  final bool? delete;

  DuePeriodListModel({
    this.id,
    this.name,
    this.days,
    this.description,
    this.code,
    this.createdBy,
    this.status,
    this.delete,
  });

  factory DuePeriodListModel.fromJson(Map<String, dynamic> json) =>
      DuePeriodListModel(
        id: json["id"],
        name: json["name"],
        days: json["days"],
        description: json["description"],
        code: json["code"],
        createdBy: json["created_by"],
        status: json["status"],
        delete: json["delete"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "days": days,
        "description": description,
        "code": code,
        "created_by": createdBy,
        "status": status,
        "delete": delete,
      };

  @override
  List<Object?> get props => [id, name, days, code, status, delete];
}
