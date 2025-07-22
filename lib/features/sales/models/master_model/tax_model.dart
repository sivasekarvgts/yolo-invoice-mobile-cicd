import 'dart:convert';

import 'package:equatable/equatable.dart';

List<TaxModel> taxModelFromJson(String str) =>
    List<TaxModel>.from(json.decode(str).map((x) => TaxModel.fromJson(x)));

String taxModelToJson(List<TaxModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TaxModel extends Equatable {
  final int? id;
  final String? name;
  final double? rate;
  final int? code;
  final int? taxTypeId;
  final String? taxType;
  final String? description;
  final int? createdBy;
  final bool? status;
  final bool? delete;
  final int? sectionId;
  final String? section;

  TaxModel({
    this.id,
    this.name,
    this.rate,
    this.code,
    this.taxTypeId,
    this.taxType,
    this.description,
    this.createdBy,
    this.status,
    this.delete,
    this.sectionId,
    this.section,
  });

  factory TaxModel.fromJson(Map<String, dynamic> json) => TaxModel(
        id: json["id"],
        name: json["name"],
        rate: json["rate"]?.toDouble(),
        code: json["code"],
        taxTypeId: json["tax_type_id"],
        taxType: json["tax_type"],
        description: json["description"],
        createdBy: json["created_by"],
        status: json["status"],
        delete: json["delete"],
        sectionId: json["section_id"],
        section: json["section"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "rate": rate,
        "code": code,
        "tax_type_id": taxTypeId,
        "tax_type": taxType,
        "description": description,
        "created_by": createdBy,
        "status": status,
        "delete": delete,
        "section_id": sectionId,
        "section": section,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        code,
        rate,
        taxType,
        taxTypeId,
        delete,
        description,
        section,
        sectionId
      ];
}
