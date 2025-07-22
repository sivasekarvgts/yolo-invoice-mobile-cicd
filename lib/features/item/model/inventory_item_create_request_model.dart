import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:yoloworks_invoice/utils/json_builder.dart';

import 'item_drop_down_list_model.dart';

InventoryItemCreateRequestModel inventoryItemCreateRequestModelFromJson(
    String str) =>
    InventoryItemCreateRequestModel.fromJson(json.decode(str));

String inventoryItemCreateRequestModelToJson(
    InventoryItemCreateRequestModel data) =>
    json.encode(data.toJson());

class InventoryItemCreateRequestModel with JsonBuilderMixin {
  final int? itemType;
  final String? name;
  final String? description;
  final String? skuCode;
  final String? hsnCode;
  final int? category;
  final int? cessRate;
  final int? tax;
  final bool? isSalesTaxExclusive;
  final bool? hasInventory;
  final double? openingStock;
  final double? reorderPoint;
  final double? initialStockRate;
  final int? purchaseAccount;
  final int? inventoryAccount;
  final List<AddUnitModel>? units;
  final bool? isPurchaseTaxExclusive;
  final int? itemTracking;
  final bool? isAutoIncrement;
  final int? taxPreference;
  final int? reason;
  final int? salesAccount;

  InventoryItemCreateRequestModel({
    this.itemType,
    this.name,
    this.category,
    this.description,
    this.skuCode,
    this.hsnCode,
    this.cessRate,
    this.tax,
    this.isSalesTaxExclusive,
    this.hasInventory,
    this.openingStock,
    this.reorderPoint,
    this.initialStockRate,
    this.purchaseAccount,
    this.inventoryAccount,
    this.units,
    this.isPurchaseTaxExclusive,
    this.itemTracking,
    this.isAutoIncrement,
    this.taxPreference,
    this.salesAccount,
    this.reason,
  });

  factory InventoryItemCreateRequestModel.fromJson(Map<String, dynamic> json) =>
      InventoryItemCreateRequestModel(
        itemType: json["item_type"],
        name: json["name"],
        category: json["category"],
        description: json["description"],
        skuCode: json["sku_code"],
        hsnCode: json["hsn_code"],
        cessRate: json["cess_rate"],
        tax: json["tax"],
        isSalesTaxExclusive: json["is_sales_tax_exclusive"],
        hasInventory: json["has_inventory"],
        openingStock: json["opening_stock"],
        reorderPoint: json["reorder_point"],
        initialStockRate: json["initial_stock_rate"],
        purchaseAccount: json["purchase_account"],
        inventoryAccount: json["inventory_account"],
        units: json["units"] == null
            ? []
            : List<AddUnitModel>.from(json["units"]!.map((x) => AddUnitModel.fromJson(x))),
        isPurchaseTaxExclusive: json["is_purchase_tax_exclusive"],
        itemTracking: json["item_tracking"],
        isAutoIncrement: json["is_auto_increment"],
        taxPreference: json["tax_preference"],
        salesAccount: json["sales_account"],
        reason: json["exemption_reason"],
      );

  Map<String, dynamic> toJsonBasicDetail() => {
    "name": name,
    "category": category,
    "description": description,
    "sku_code": skuCode,
    "hsn_code": hsnCode,
};

  Map<String, dynamic> toJsonTaxPref() => {
    "cess_rate": cessRate,
    "tax": tax,
    "tax_preference": taxPreference,
    "exemption_reason": reason,
};



  Map<String, dynamic> toJson() => buildJson({
    "item_type": itemType,
    "name": name,
    "category": category,
    "description": description,
    "sku_code": skuCode,
    "hsn_code": hsnCode,
    "cess_rate": cessRate,
    "tax": tax,
    "is_sales_tax_exclusive": isSalesTaxExclusive,
    "has_inventory": hasInventory,
    "opening_stock": openingStock,
    "reorder_point": reorderPoint,
    "initial_stock_rate": initialStockRate,
    "purchase_account": purchaseAccount,
    "inventory_account": inventoryAccount,
    "units": units == null
        ? null
        // ? []
        :
    List<dynamic>.from(units!.map((x) => x.toJson())),
    "is_purchase_tax_exclusive": isPurchaseTaxExclusive,
    "item_tracking": itemTracking,
    "is_auto_increment": isAutoIncrement,
    "tax_preference": taxPreference,
    "exemption_reason": reason,
    "sales_account": salesAccount,
  });
}

class AddUnitModel with JsonBuilderMixin{
  final int? unit;
  final double? sellingPrice;
  final int? type;
  final double? quantity;
  final bool? isPrimary;
  final bool? isForPurchase;
  final int? salesAccount;
  final double? purchasePrice;
  final int? baseUnit;
  final int? quantity2;


  bool isManuallyChanged;
  ItemDropDownListModel? selectedUom;
  final TextEditingController uomListCtrl = TextEditingController();
  final TextEditingController quantityListCtrl = TextEditingController();
  final TextEditingController salesPriceListCtrl = TextEditingController();


  AddUnitModel({
    this.unit,
    this.sellingPrice,
    this.type,
    this.quantity,
    this.isPrimary,
    this.isForPurchase,
    this.salesAccount,
    this.purchasePrice,
    this.baseUnit,
    this.quantity2,



     // this.uomListCtrl,
     // this.quantityListCtrl,
     // this.salesPriceListCtrl,
    this.isManuallyChanged = false,
    this.selectedUom,

  });

  factory AddUnitModel.fromJson(Map<String, dynamic> json) =>  AddUnitModel(
    unit: json["unit"],
    sellingPrice: json["selling_price"],
    type: json["type"],
    quantity: json["quantity"],
    isPrimary: json["is_primary"],
    isForPurchase: json["is_for_purchase"],
    salesAccount: json["sales_account"],
    purchasePrice: json["purchase_price"],
    baseUnit: json["base_unit"],
    quantity2: json["quantity2"],
  );

  Map<String, dynamic> toJson() => buildJson({
    "unit": unit,
    "selling_price": sellingPrice,
    "type": type,
    "quantity": quantity,
    "is_primary": isPrimary,
    "is_for_purchase": isForPurchase,
    "sales_account": salesAccount,
    "purchase_price": purchasePrice,
    "base_unit": baseUnit,
    "quantity2": quantity2,
  });
}

