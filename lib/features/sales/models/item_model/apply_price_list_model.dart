import 'dart:convert';

List<ApplyPriceListModel> priceListAppliedModelFromJson(String str) =>
    List<ApplyPriceListModel>.from(
        json.decode(str).map((x) => ApplyPriceListModel.fromJson(x)));

String priceListAppliedModelToJson(List<ApplyPriceListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ApplyPriceListModel {
  final int? itemBatchId;
  final String? itemUnit;
  final List<ItemUnitList>? unitsList;

  ApplyPriceListModel({
    this.itemBatchId,
    this.itemUnit,
    this.unitsList,
  });

  factory ApplyPriceListModel.fromJson(Map<String, dynamic> json) =>
      ApplyPriceListModel(
        itemBatchId: json["item_batch_id"],
        itemUnit: json["item_unit"],
        unitsList: json["units"] == null
            ? []
            : List<ItemUnitList>.from(
                json["units"]!.map((x) => ItemUnitList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "item_batch_id": itemBatchId,
        "item_unit": itemUnit,
        "units": unitsList == null
            ? []
            : List<dynamic>.from(unitsList!.map((x) => x.toJson())),
      };
}

class ItemUnitList {
  final int? id;
  final int? unitId;
  final String? unit;
  final bool? isPrimary;
  final double? sellingPrice;
  final double? purchasePrice;
  final double? quantity;
  final double? baseQuantity;

  ItemUnitList({
    this.id,
    this.unitId,
    this.unit,
    this.isPrimary,
    this.sellingPrice,
    this.purchasePrice,
    this.quantity,
    this.baseQuantity,
  });

  factory ItemUnitList.fromJson(Map<String, dynamic> json) => ItemUnitList(
        id: json["id"],
        unitId: json["unit_id"],
        unit: json["unit"],
        isPrimary: json["is_primary"],
        sellingPrice: json["selling_price"]?.toDouble(),
        purchasePrice: json["purchase_price"]?.toDouble(),
        quantity: json["quantity"]?.toDouble(),
        baseQuantity: json["base_quantity"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "unit_id": unitId,
        "unit": unit,
        "is_primary": isPrimary,
        "selling_price": sellingPrice,
        "purchase_price": purchasePrice,
        "quantity": quantity,
        "base_quantity": baseQuantity,
      };
}
