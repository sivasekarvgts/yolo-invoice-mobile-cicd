import 'package:equatable/equatable.dart';

import '../../../app/constants/app_constants.dart';

class ItemUnit extends Equatable {
  final int? id;
  final String? name;
  final int? itemId;
  final int? unitId;
  final String? unit;
  final int? baseUnitId;
  final String? baseUnit;
  final double? quantity;
  final double? quantity2;
  final double? baseQuantity;
  final double? sellingPrice;
  final double? purchasePrice;
  final bool? isPrimary;
  final bool? isForPurchase;
  final int? code;
  final bool? status;
  final bool? delete;
  final DateTime? created;
  final int? createdBy;

  ItemUnit({
    this.id,
    this.name,
    this.itemId,
    this.unitId,
    this.unit,
    this.baseUnitId,
    this.baseUnit,
    this.quantity,
    this.baseQuantity,
    this.quantity2,
    this.sellingPrice,
    this.purchasePrice,
    this.isPrimary,
    this.isForPurchase,
    this.code,
    this.status,
    this.delete,
    this.created,
    this.createdBy,
  });

  factory ItemUnit.fromJson(Map<String, dynamic> value) {
    final json = AppConstants.isNotNullJson(value);
    return ItemUnit(
      id: json["id"],
      name: json["name"],
      itemId: json["item_id"],
      unitId: json["unit_id"],
      unit: json["unit"],
      baseUnitId: json["base_unit_id"],
      baseUnit: json["base_unit"],
      baseQuantity: json["base_quantity"]?.toDouble(),
      quantity: json["quantity"]?.toDouble(),
      quantity2: json["quantity2"]?.toDouble(),
      sellingPrice: json["selling_price"]?.toDouble(),
      purchasePrice: json["purchase_price"]?.toDouble(),
      isPrimary: json["is_primary"],
      isForPurchase: json["is_for_purchase"],
      code: json["code"],
      status: json["status"],
      delete: json["delete"],
      created: json["created"] == null ? null : DateTime.parse(json["created"]),
      createdBy: json["created_by"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "item_id": itemId,
        "unit_id": unitId,
        "unit": unit,
        "base_unit_id": baseUnitId,
        "base_unit": baseUnit,
        "quantity": quantity,
        "quantity2": quantity2,
        "base_quantity": baseQuantity,
        "selling_price": sellingPrice,
        "purchase_price": purchasePrice,
        "is_primary": isPrimary,
        "is_for_purchase": isForPurchase,
        "code": code,
        "status": status,
        "delete": delete,
        "created": created?.toIso8601String(),
        "created_by": createdBy,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        itemId,
        unitId,
        unit,
        baseUnitId,
        baseUnit,
        quantity,
        quantity2,
        sellingPrice,
        purchasePrice,
        isPrimary,
        isForPurchase,
        code,
        baseQuantity,
        status,
        delete,
        created,
        createdBy,
      ];
}
