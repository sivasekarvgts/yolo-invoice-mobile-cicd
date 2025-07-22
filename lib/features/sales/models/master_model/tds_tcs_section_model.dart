import 'dart:convert';

List<TdsTcsSectionModel> tdsTcsSectionModelFromJson(String str) =>
    List<TdsTcsSectionModel>.from(
        json.decode(str).map((x) => TdsTcsSectionModel.fromJson(x)));

String tdsTcsSectionModelToJson(List<TdsTcsSectionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TdsTcsSectionModel {
  final int? id;
  final String? name;
  final String? description;
  final String? code;
  final bool? status;
  final bool? delete;

  TdsTcsSectionModel({
    this.id,
    this.name,
    this.description,
    this.code,
    this.status,
    this.delete,
  });

  factory TdsTcsSectionModel.fromJson(Map<String, dynamic> json) =>
      TdsTcsSectionModel(
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
