import 'dart:convert';

List<WarehouseItemValidationModel> warehouseItemValidationModelFromJson(
        String str) =>
    List<WarehouseItemValidationModel>.from(
        json.decode(str).map((x) => WarehouseItemValidationModel.fromJson(x)));

String warehouseItemValidationModelToJson(
        List<WarehouseItemValidationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WarehouseItemValidationModel {
  final int? itemId;
  final int? itemUnit;
  final String? stocks;

  WarehouseItemValidationModel({
    this.itemId,
    this.itemUnit,
    this.stocks,
  });

  factory WarehouseItemValidationModel.fromJson(Map<String, dynamic> json) =>
      WarehouseItemValidationModel(
        itemId: json["item_id"],
        itemUnit: json["item_unit"],
        stocks: json["stocks"],
      );

  Map<String, dynamic> toJson() => {
        "item_id": itemId,
        "item_unit": itemUnit,
        "stocks": stocks,
      };
}
