// To parse this JSON data, do
//
//     final itemListModel = itemListModelFromJson(jsonString);

import 'dart:convert';

InventoryItemListModel itemListModelFromJson(String str) =>
    InventoryItemListModel.fromJson(json.decode(str));

String itemListModelToJson(InventoryItemListModel data) =>
    json.encode(data.toJson());

class InventoryItemListModel {
  final int? count;
  final int? numPages;
  final int? pageSize;
  final int? currentPage;
  final List<int>? pageRange;
  final int? perPage;
  final List<InventoryItemDatum>? data;

  InventoryItemListModel({
    this.count,
    this.numPages,
    this.pageSize,
    this.currentPage,
    this.pageRange,
    this.perPage,
    this.data,
  });

  factory InventoryItemListModel.fromJson(Map<String, dynamic> json) =>
      InventoryItemListModel(
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
            : List<InventoryItemDatum>.from(
                json["data"]!.map((x) => InventoryItemDatum.fromJson(x))),
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

class InventoryItemDatum {
  final int? id;
  final String? image;
  final dynamic groupId;
  final dynamic group;
  final int? categoryId;
  final String? category;
  final int? itemTypeId;
  final ItemType? itemType;
  final String? name;
  final dynamic description;
  final String? taxDescription;
  final dynamic skuImage;
  final String? skuCode;
  final dynamic barCode;
  final double? rate;
  final int? taxPreference;
  final TaxPreferenceName? taxPreferenceName;
  final dynamic exemptionReason;
  final dynamic exemptionReasonName;
  final bool? isTaxable;
  final String? hsnCode;
  final dynamic sacCode;
  final dynamic cessRateId;
  final dynamic cessRate;
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
  final double? openingStock;
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
  final dynamic salesAccountName;
  final dynamic purchaseAccountName;
  final dynamic inventoryAccountName;
  final bool? status;
  final bool? delete;
  final DateTime? created;
  final int? createdBy;

  InventoryItemDatum({
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
  });

  factory InventoryItemDatum.fromJson(Map<String, dynamic> json) =>
      InventoryItemDatum(
        id: json["id"],
        image: json["image"],
        groupId: json["group_id"],
        group: json["group"],
        categoryId: json["category_id"],
        category: json["category"],
        itemTypeId: json["item_type_id"],
        itemType: itemTypeValues.map[json["item_type"]]!,
        name: json["name"],
        description: json["description"],
        taxDescription: json["tax_description"],
        skuImage: json["sku_image"],
        skuCode: json["sku_code"],
        barCode: json["bar_code"],
        rate: json["rate"],
        taxPreference: json["tax_preference"],

        taxPreferenceName:
            taxPreferenceNameValues.map[json["tax_preference_name"]],
        exemptionReason: json["exemption_reason"],
        exemptionReasonName: json["exemption_reason_name"],
        isTaxable: json["is_taxable"],
        hsnCode: json["hsn_code"],
        sacCode: json["sac_code"],
        cessRateId: json["cess_rate_id"],
        cessRate: json["cess_rate"],
        isTaxPreferenceIntra: json["is_tax_preference_intra"],
        isSalesTaxExclusive: json["is_sales_tax_exclusive"],
        isPurchaseTaxExclusive: json["is_purchase_tax_exclusive"],
        taxId: json["tax_id"],
        tax: json["tax"],
        hasInventory: json["has_inventory"],
        isComposite: json["is_composite"],
        hasTransaction: json["has_transaction"],
        itemUnits: json["item_units"] == null
            ? []
            : List<ItemUnit>.from(
                json["item_units"]!.map((x) => ItemUnit.fromJson(x))),
        itemTracking: json["item_tracking"],
        sellingPrice: double.tryParse("${json["selling_price"] ?? 0}"),
        purchasePrice: json["purchase_price"],
        openingStock: json["opening_stock"],
        prefix: json["prefix"],
        suffixDigitLimit: json["suffix_digit_limit"],
        isAutoIncrement: json["is_auto_increment"],
        reorderPoint: json["reorder_point"],
        reorderPointValue: json["reorder_point_value"],
        stockOnHand: json["stock_on_hand"],
        warehouseStocks: json["warehouse_stocks"] == null
            ? []
            : List<WarehouseStock>.from(json["warehouse_stocks"]!
                .map((x) => WarehouseStock.fromJson(x))),
        stockOnHandPcs: json["stock_on_hand_pcs"],
        stockTransaction: json["stock_transaction"],
        accountingStock: json["accounting_stock"],
        // allocatedStock: allocatedStockValues.map[json["allocated_stock"]]!,
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
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        createdBy: json["created_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "group_id": groupId,
        "group": group,
        "category_id": categoryId,
        "category": category,
        "item_type_id": itemTypeId,
        "item_type": itemTypeValues.reverse[itemType],
        "name": name,
        "description": description,
        "tax_description": taxDescription,
        "sku_image": skuImage,
        "sku_code": skuCode,
        "bar_code": barCode,
        "rate": rate,
        "tax_preference": taxPreference,
        "tax_preference_name":
            taxPreferenceNameValues.reverse[taxPreferenceName],
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
        "item_units": itemUnits == null
            ? []
            : List<dynamic>.from(itemUnits!.map((x) => x.toJson())),
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
        "warehouse_stocks": warehouseStocks == null
            ? []
            : List<dynamic>.from(warehouseStocks!.map((x) => x.toJson())),
        "stock_on_hand_pcs": stockOnHandPcs,
        "stock_transaction": stockTransaction,
        "accounting_stock": accountingStock,
        "allocated_stock": allocatedStockValues.reverse[allocatedStock],
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
      };
}

enum AllocatedStock { THE_0_BOX, THE_0_KG, THE_0_PCS }

final allocatedStockValues = EnumValues({
  "0 box": AllocatedStock.THE_0_BOX,
  "0 kg": AllocatedStock.THE_0_KG,
  "0 pcs": AllocatedStock.THE_0_PCS
});

enum ItemType { PRODUCT }

final itemTypeValues = EnumValues({"Product": ItemType.PRODUCT});

class ItemUnit {
  final int? id;
  final String? name;
  final int? itemId;
  final int? unitId;
  final String? unit;
  final int? baseUnitId;
  final String? baseUnit;
  final int? quantity;
  final int? quantity2;
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
        quantity: json["quantity"],
        quantity2: json["quantity2"],
        sellingPrice: json["selling_price"],
        purchasePrice: json["purchase_price"],
        isPrimary: json["is_primary"],
        isForPurchase: json["is_for_purchase"],
        code: json["code"],
        status: json["status"],
        delete: json["delete"],
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
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

enum TaxPreferenceName { TAXABLE }

final taxPreferenceNameValues =
    EnumValues({"Taxable": TaxPreferenceName.TAXABLE});

class WarehouseStock {
  final String? warehouseName;
  final List<String>? itemDetails;

  WarehouseStock({
    this.warehouseName,
    this.itemDetails,
  });

  factory WarehouseStock.fromJson(Map<String, dynamic> json) => WarehouseStock(
        warehouseName: json["warehouse_name"],
        itemDetails: json["item_details"] == null
            ? []
            : List<String>.from(json["item_details"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "warehouse_name": warehouseName,
        "item_details": itemDetails == null
            ? []
            : List<dynamic>.from(itemDetails!.map((x) => x)),
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
