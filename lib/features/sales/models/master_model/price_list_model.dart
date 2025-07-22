import 'dart:convert';

List<PriceListModel> priceListModelFromJson(String str) =>
    List<PriceListModel>.from(
        json.decode(str).map((x) => PriceListModel.fromJson(x)));

String priceListModelToJson(List<PriceListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PriceListModel {
  final int? id;
  final String? name;
  final int? priceListTypeId;
  final String? priceListType;
  final int? priceSchemeTypeId;
  final String? priceSchemeType;
  final bool? hasAllItems;
  final String? description;
  final dynamic currency;
  final bool? hasDiscount;
  final int? percentageTypeId;
  final String? percentageType;
  final double? percentageValue;
  final int? roundOffId;
  final double? roundOff;
  final int? decimalPlaces;
  final int? createdBy;
  final DateTime? created;
  final bool? status;
  final bool? delete;
  final bool? priceListModelDefault;

  PriceListModel({
    this.id,
    this.name,
    this.priceListTypeId,
    this.priceListType,
    this.priceSchemeTypeId,
    this.priceSchemeType,
    this.hasAllItems,
    this.description,
    this.currency,
    this.hasDiscount,
    this.percentageTypeId,
    this.percentageType,
    this.percentageValue,
    this.roundOffId,
    this.roundOff,
    this.decimalPlaces,
    this.priceListModelDefault,
    this.status,
    this.delete,
    this.created,
    this.createdBy,
  });

  factory PriceListModel.fromJson(Map<String, dynamic> json) => PriceListModel(
        id: json["id"],
        name: json["name"],
        priceListTypeId: json["price_list_type_id"],
        priceListType: json["price_list_type"],
        priceSchemeTypeId: json["price_scheme_type_id"],
        priceSchemeType: json["price_scheme_type"],
        hasAllItems: json["has_all_items"],
        description: json["description"],
        currency: json["currency"],
        hasDiscount: json["has_discount"],
        percentageTypeId: json["percentage_type_id"],
        percentageType: json["percentage_type"],
        percentageValue: json["percentage_value"]?.toDouble(),
        roundOffId: json["round_off_id"],
        roundOff: json["round_off"]?.toDouble(),
        decimalPlaces: json["decimal_places"],
        priceListModelDefault: json["default"],
        status: json["status"],
        delete: json["delete"],
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        createdBy: json["created_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price_list_type_id": priceListTypeId,
        "price_list_type": priceListType,
        "price_scheme_type_id": priceSchemeTypeId,
        "price_scheme_type": priceSchemeType,
        "has_all_items": hasAllItems,
        "description": description,
        "currency": currency,
        "has_discount": hasDiscount,
        "percentage_type_id": percentageTypeId,
        "percentage_type": percentageType,
        "percentage_value": percentageValue,
        "round_off_id": roundOffId,
        "round_off": roundOff,
        "decimal_places": decimalPlaces,
        "default": priceListModelDefault,
        "status": status,
        "delete": delete,
        "created": created?.toIso8601String(),
        "created_by": createdBy,
      };
}
