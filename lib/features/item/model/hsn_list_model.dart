// To parse this JSON data, do
//
//     final hsnListModel = hsnListModelFromJson(jsonString);

import 'dart:convert';

HsnListModel hsnListModelFromJson(String str) =>
    HsnListModel.fromJson(json.decode(str));

String hsnListModelToJson(HsnListModel data) => json.encode(data.toJson());

class HsnListModel {
  final int? count;
  final int? numPages;
  final int? pageSize;
  final int? currentPage;
  final List<int>? pageRange;
  final int? perPage;
  final List<HsnData>? data;

  HsnListModel({
    this.count,
    this.numPages,
    this.pageSize,
    this.currentPage,
    this.pageRange,
    this.perPage,
    this.data,
  });

  factory HsnListModel.fromJson(Map<String, dynamic> json) => HsnListModel(
        count: json["count"],
        numPages: json["num_pages"],
        pageSize: json["page_size"],
        currentPage: json["current_page"],
        pageRange: json["page_range"] == null
            ? []
            : List<int>.from(json["page_range"]!.map((x) => x)),
        perPage: json["per_page"],
        data: json["data"] == null
            ? []
            : List<HsnData>.from(json["data"]!.map((x) => HsnData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "num_pages": numPages,
        "page_size": pageSize,
        "current_page": currentPage,
        "page_range": pageRange == null
            ? []
            : List<dynamic>.from(pageRange!.map((x) => x)),
        "per_page": perPage,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class HsnData {
  final int? id;
  final String? name;
  final String? description;
  final dynamic code;
  final bool? status;
  final bool? delete;

  HsnData({
    this.id,
    this.name,
    this.description,
    this.code,
    this.status,
    this.delete,
  });

  factory HsnData.fromJson(Map<String, dynamic> json) => HsnData(
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
