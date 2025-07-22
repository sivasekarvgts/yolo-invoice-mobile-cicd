import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../../app/constants/app_constants.dart';

SchemeListModel schemeListModelFromJson(String str) =>
    SchemeListModel.fromJson(json.decode(str));

String schemeListModelToJson(SchemeListModel data) =>
    json.encode(data.toJson());

class SchemeListModel extends Equatable {
  final int? itemId;
  final List<Scheme>? schemes;

  SchemeListModel({
    this.itemId,
    this.schemes,
  });

  factory SchemeListModel.fromJson(Map<String, dynamic> json) =>
      SchemeListModel(
        itemId: json["item_id"],
        schemes: json["schemes"] == null
            ? []
            : List<Scheme>.from(
                json["schemes"]!.map((x) => Scheme.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "item_id": itemId,
        "schemes": schemes == null
            ? []
            : List<dynamic>.from(schemes!.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [itemId, schemes];
}

class Scheme extends Equatable {
  final int? id;
  final int? schemeId;
  final String? schemeName;
  final int? combineWithId;
  final String? combineWith;
  final List<Rule>? rules;

  Scheme({
    this.id,
    this.schemeId,
    this.schemeName,
    this.combineWithId,
    this.combineWith,
    this.rules,
  });

  factory Scheme.fromJson(Map<String, dynamic> json) => Scheme(
        id: json["id"],
        schemeId: json["scheme_id"],
        schemeName: json["scheme_name"],
        combineWithId: json["combine_with_id"],
        combineWith: json["combine_with"],
        rules: json["rules"] == null
            ? []
            : List<Rule>.from(json["rules"]!.map((x) => Rule.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "scheme_id": schemeId,
        "scheme_name": schemeName,
        "combine_with_id": combineWithId,
        "combine_with": combineWith,
        "rules": rules == null
            ? []
            : List<dynamic>.from(rules!.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props =>
      [id, schemeId, schemeName, combineWith, combineWithId, rules];
}

class Rule extends Equatable {
  final int? id;
  final int? itemId;
  final String? item;
  final String? image;
  final double? value;
  final int? unitId;
  final String? unit;
  final int? combineWithId;
  final String? combineWith;

  Rule({
    this.id,
    this.itemId,
    this.item,
    this.image,
    this.value,
    this.unitId,
    this.unit,
    this.combineWithId,
    this.combineWith,
  });

  factory Rule.fromJson(Map<String, dynamic> value) {
    final json = AppConstants.isNotNullJson(value);
    return Rule(
      id: json["id"],
      itemId: json["item_id"],
      item: json["item"],
      image: json["image"],
      value: json["value"]?.toDouble(),
      unitId: json["unit_id"],
      unit: json["unit"],
      combineWithId: json["combine_with_id"],
      combineWith: json["combine_with"],
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "item_id": itemId,
        "item": item,
        "image": image,
        "value": value,
        "unit_id": unitId,
        "unit": unit,
        "combine_with_id": combineWithId,
        "combine_with": combineWith,
      };

  @override
  List<Object?> get props => [
        id,
        itemId,
        item,
        image,
        value,
        unitId,
        unit,
        combineWithId,
        combineWith,
      ];
}
