import 'dart:convert';

import '../view/new_item/edit_item/item_edit_view.dart';



InventoryItemDetailsModel inventoryItemDetailsModelFromJson(String str) => InventoryItemDetailsModel.fromJson(json.decode(str));

String inventoryItemDetailsModelToJson(InventoryItemDetailsModel data) => json.encode(data.toJson());



class InventoryItemDetailsModel {
  final int? id;
  final dynamic image;
  final dynamic groupId;
  final dynamic group;
  final dynamic categoryId;
  final dynamic category;
  final int? itemTypeId;
  final String? itemType;
  final String? name;
  final dynamic description;
  final String? taxDescription;
  final dynamic skuImage;
  final dynamic skuCode;
  final dynamic barCode;
  final double? rate;
  final int? taxPreference;
  final String? taxPreferenceName;
  final dynamic exemptionReason;
  final dynamic exemptionReasonName;
  final bool? isTaxable;
  final String? hsnCode;
  final dynamic sacCode;
  final int? cessRateId;
  final double? cessRate;
  final bool? isTaxPreferenceIntra;
  final bool? isSalesTaxExclusive;
  final bool? isPurchaseTaxExclusive;
  final int? taxId;
  final double? tax;
  final bool? hasInventory;
  final bool? isComposite;
  final bool? hasTransaction;
  final List<ItemUnit>? itemUnits;
  final int? itemTracking;
  final double? sellingPrice;
  final double? purchasePrice;
  final num? openingStock;
  final dynamic prefix;
  final int? suffixDigitLimit;
  final bool? isAutoIncrement;
  final String? reorderPoint;
  final String? reorderPointValue;
  final String? stockOnHand;
  final List<WarehouseStock>? warehouseStocks;
  final String? stockOnHandPcs;
  final String? stockTransaction;
  final String? accountingStock;
  final String? allocatedStock;
  final double? initialStockRate;
  final bool? isFixedAsset;
  final dynamic itemStatus;
  final int? salesAccount;
  final int? purchaseAccount;
  final int? inventoryAccount;
  final String? salesAccountName;
  final String? purchaseAccountName;
  final String? inventoryAccountName;
   bool? status;
  final bool? delete;
  final DateTime? created;
  final int? createdBy;
  final bool? isEditable;
  ItemEditType? itemUpdateType;

  InventoryItemDetailsModel({
    this.id,
    this.image,
    this.groupId,
    this.group,
    this.categoryId,
    this.category,
    this.itemTypeId,
    this.itemType,
    this.name,
    this.description,
    this.taxDescription,
    this.skuImage,
    this.skuCode,
    this.barCode,
    this.rate,
    this.taxPreference,
    this.taxPreferenceName,
    this.exemptionReason,
    this.exemptionReasonName,
    this.isTaxable,
    this.hsnCode,
    this.sacCode,
    this.cessRateId,
    this.cessRate,
    this.isTaxPreferenceIntra,
    this.isSalesTaxExclusive,
    this.isPurchaseTaxExclusive,
    this.taxId,
    this.tax,
    this.hasInventory,
    this.isComposite,
    this.hasTransaction,
    this.itemUnits,
    this.itemTracking,
    this.sellingPrice,
    this.purchasePrice,
    this.openingStock,
    this.prefix,
    this.suffixDigitLimit,
    this.isAutoIncrement,
    this.reorderPoint,
    this.reorderPointValue,
    this.stockOnHand,
    this.warehouseStocks,
    this.stockOnHandPcs,
    this.stockTransaction,
    this.accountingStock,
    this.allocatedStock,
    this.initialStockRate,
    this.isFixedAsset,
    this.itemStatus,
    this.salesAccount,
    this.purchaseAccount,
    this.inventoryAccount,
    this.salesAccountName,
    this.purchaseAccountName,
    this.inventoryAccountName,
    this.status,
    this.delete,
    this.created,
    this.createdBy,
    this.isEditable,
    this.itemUpdateType,
  });

  factory InventoryItemDetailsModel.fromJson(Map<String, dynamic> json) => InventoryItemDetailsModel(
    id: json["id"],
    image: json["image"],
    groupId: json["group_id"],
    group: json["group"],
    categoryId: json["category_id"],
    category: json["category"],
    itemTypeId: json["item_type_id"],
    itemType: json["item_type"],
    name: json["name"],
    description: json["description"],
    taxDescription: json["tax_description"],
    skuImage: json["sku_image"],
    skuCode: json["sku_code"],
    barCode: json["bar_code"],
    rate: double.tryParse("${json["rate"]??0}"),
    taxPreference: json["tax_preference"],
    taxPreferenceName: json["tax_preference_name"],
    exemptionReason: json["exemption_reason"],
    exemptionReasonName: json["exemption_reason_name"],
    isTaxable: json["is_taxable"],
    hsnCode: json["hsn_code"],
    sacCode: json["sac_code"],
    cessRateId: json["cess_rate_id"],
    cessRate: double.tryParse("${json["cess_rate"]??0}"),
    isTaxPreferenceIntra: json["is_tax_preference_intra"],
    isSalesTaxExclusive: json["is_sales_tax_exclusive"],
    isPurchaseTaxExclusive: json["is_purchase_tax_exclusive"],
    taxId: json["tax_id"],
    tax: double.tryParse("${json["tax"]??0}"),
    hasInventory: json["has_inventory"],
    isComposite: json["is_composite"],
    hasTransaction: json["has_transaction"],
    itemUnits: json["item_units"] == null ? [] : List<ItemUnit>.from(json["item_units"]!.map((x) => ItemUnit.fromJson(x))),
    itemTracking: json["item_tracking"],
    sellingPrice: double.tryParse("${json["selling_price"]??0}"),
    purchasePrice:double.tryParse("${json["purchase_price"]??0}"),
    openingStock: json["opening_stock"],
    prefix: json["prefix"],
    suffixDigitLimit: json["suffix_digit_limit"],
    isAutoIncrement: json["is_auto_increment"],
    reorderPoint: json["reorder_point"],
    reorderPointValue: json["reorder_point_value"],
    stockOnHand: json["stock_on_hand"],
    warehouseStocks: json["warehouse_stocks"] == null ? [] : List<WarehouseStock>.from(json["warehouse_stocks"]!.map((x) => WarehouseStock.fromJson(x))),
    stockOnHandPcs: json["stock_on_hand_pcs"],
    stockTransaction: json["stock_transaction"],
    accountingStock: json["accounting_stock"],
    allocatedStock: json["allocated_stock"],
    initialStockRate: json["initial_stock_rate"],
    isFixedAsset: json["is_fixed_asset"],
    itemStatus: json["item_status"],
    salesAccount: json["sales_account"],
    purchaseAccount: json["purchase_account"],
    inventoryAccount: json["inventory_account"],
    salesAccountName: json["sales_account_name"],
    purchaseAccountName: json["purchase_account_name"],
    inventoryAccountName: json["inventory_account_name"],
    status: json["status"],
    delete: json["delete"],
    created: json["created"] == null ? null : DateTime.parse(json["created"]),
    createdBy: json["created_by"],
    isEditable: json["is_editable"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "group_id": groupId,
    "group": group,
    "category_id": categoryId,
    "category": category,
    "item_type_id": itemTypeId,
    "item_type": itemType,
    "name": name,
    "description": description,
    "tax_description": taxDescription,
    "sku_image": skuImage,
    "sku_code": skuCode,
    "bar_code": barCode,
    "rate": rate,
    "tax_preference": taxPreference,
    "tax_preference_name": taxPreferenceName,
    "exemption_reason": exemptionReason,
    "exemption_reason_name": exemptionReasonName,
    "is_taxable": isTaxable,
    "hsn_code": hsnCode,
    "sac_code": sacCode,
    "cess_rate_id": cessRateId,
    "cess_rate": cessRate,
    "is_tax_preference_intra": isTaxPreferenceIntra,
    "is_sales_tax_exclusive": isSalesTaxExclusive,
    "is_purchase_tax_exclusive": isPurchaseTaxExclusive,
    "tax_id": taxId,
    "tax": tax,
    "has_inventory": hasInventory,
    "is_composite": isComposite,
    "has_transaction": hasTransaction,
    "item_units": itemUnits == null ? [] : List<dynamic>.from(itemUnits!.map((x) => x.toJson())),
    "item_tracking": itemTracking,
    "selling_price": sellingPrice,
    "purchase_price": purchasePrice,
    "opening_stock": openingStock,
    "prefix": prefix,
    "suffix_digit_limit": suffixDigitLimit,
    "is_auto_increment": isAutoIncrement,
    "reorder_point": reorderPoint,
    "reorder_point_value": reorderPointValue,
    "stock_on_hand": stockOnHand,
    "warehouse_stocks": warehouseStocks == null ? [] : List<dynamic>.from(warehouseStocks!.map((x) => x.toJson())),
    "stock_on_hand_pcs": stockOnHandPcs,
    "stock_transaction": stockTransaction,
    "accounting_stock": accountingStock,
    "allocated_stock": allocatedStock,
    "initial_stock_rate": initialStockRate,
    "is_fixed_asset": isFixedAsset,
    "item_status": itemStatus,
    "sales_account": salesAccount,
    "purchase_account": purchaseAccount,
    "inventory_account": inventoryAccount,
    "sales_account_name": salesAccountName,
    "purchase_account_name": purchaseAccountName,
    "inventory_account_name": inventoryAccountName,
    "status": status,
    "delete": delete,
    "created": created?.toIso8601String(),
    "created_by": createdBy,
    "is_editable": isEditable,
  };
}

class ItemUnit {
  final int? id;
  final String? name;
  final int? itemId;
  final int? unitId;
  final String? unit;
  final dynamic baseUnitId;
  final dynamic baseUnit;
  final double? quantity;
  final dynamic quantity2;
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

  factory ItemUnit.fromJson(Map<String, dynamic> json) => ItemUnit(
    id: json["id"],
    name: json["name"],
    itemId: json["item_id"],
    unitId: json["unit_id"],
    unit: json["unit"],
    baseUnitId: json["base_unit_id"],
    baseUnit: json["base_unit"],
    quantity:double.tryParse("${json["quantity"]??0}"),
    quantity2: json["quantity2"],
    sellingPrice: double.tryParse("${json["selling_price"]??0}"),
    purchasePrice: double.tryParse("${json["purchase_price"]??0}"),
    isPrimary: json["is_primary"],
    isForPurchase: json["is_for_purchase"],
    code: json["code"],
    status: json["status"],
    delete: json["delete"],
    created: json["created"] == null ? null : DateTime.parse(json["created"]),
    createdBy: json["created_by"],
  );

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
}

class WarehouseStock {
  final String? warehouseName;
  final List<String>? itemDetails;

  WarehouseStock({
    this.warehouseName,
    this.itemDetails,
  });

  factory WarehouseStock.fromJson(Map<String, dynamic> json) => WarehouseStock(
    warehouseName: json["warehouse_name"],
    itemDetails: json["item_details"] == null ? [] : List<String>.from(json["item_details"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "warehouse_name": warehouseName,
    "item_details": itemDetails == null ? [] : List<dynamic>.from(itemDetails!.map((x) => x)),
  };
}
