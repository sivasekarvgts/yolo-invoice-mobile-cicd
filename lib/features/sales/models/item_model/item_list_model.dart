import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../../app/constants/app_constants.dart';
import '../../../item/model/item_units.dart';

ItemListModel itemListModelFromJson(String str) =>
    ItemListModel.fromJson(json.decode(str));

String itemListModelToJson(ItemListModel data) => json.encode(data.toJson());

class ItemListModel extends Equatable {
  final int? count;
  final int? numPages;
  final int? pageSize;
  final int? currentPage;
  final List<int>? pageRange;
  final int? perPage;
  final List<ItemDatum>? data;

  ItemListModel({
    this.count,
    this.numPages,
    this.pageSize,
    this.currentPage,
    this.pageRange,
    this.perPage,
    this.data,
  });

  factory ItemListModel.fromJson(Map<String, dynamic> json) => ItemListModel(
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
            : List<ItemDatum>.from(
                json["data"]!.map((x) => ItemDatum.fromJson(x))),
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

  @override
  List<Object?> get props => [numPages, pageRange, pageSize, data];
}

// ignore: must_be_immutable
class ItemDatum extends Equatable {
  final int? id;
  final int? itemId;
  final String? item;
  final String? name;
  final String? image;
  final int? taxId;
  final double? tax;
  final String? taxName;
  final int? cessId;
  final double? cess;
  final int? cessRateId;
  final double? cessRate;
  final String? cessName;
  final String? skuCode;
  final String? hsnCode;
  final int? unitId;
  final String? unit;
  final double? sellingPrice;
  final double? purchasePrice;
  final double? stocks;
  final double? soldStocks;
  final double? holding;
  final bool? status;
  final bool? delete;
  final String? created;
  final int? createdBy;
  bool? isOpen;
  final List<ItemUnit>? itemUnits;
  final bool? isSalesTaxExclusive;

  ItemDatum({
    this.id,
    this.itemId,
    this.item,
    this.name,
    this.image,
    this.isSalesTaxExclusive,
    this.taxId,
    this.tax,
    this.taxName,
    this.cessId,
    this.cess,
    this.cessRateId,
    this.cessRate,
    this.cessName,
    this.skuCode,
    this.hsnCode,
    this.unitId,
    this.unit,
    this.sellingPrice,
    this.purchasePrice,
    this.stocks,
    this.soldStocks,
    this.holding,
    this.isOpen,
    this.itemUnits,
    this.status,
    this.delete,
    this.created,
    this.createdBy,
  });

  factory ItemDatum.fromJson(Map<String, dynamic> value) {
    final json = AppConstants.isNotNullJson(value);
    return ItemDatum(
      id: json["id"],
      itemId: json["item_id"],
      item: json["item"],
      name: json["name"],
      image: json["image"],
      isSalesTaxExclusive: json["is_sales_tax_exclusive"],
      taxId: json["tax_id"],
      tax: json["tax"]?.toDouble(),
      taxName: json["tax_name"],
      cessId: json["cess_id"],
      cess: json["cess"]?.toDouble(),
      cessRateId: json["cess_rate_id"],
      cessRate: json["cess_rate"]?.toDouble(),
      cessName: json["cess_name"],
      skuCode: json["sku_code"],
      hsnCode: json["hsn_code"],
      unitId: json["unit_id"],
      unit: json["unit"],
      sellingPrice: json["selling_price"]?.toDouble(),
      purchasePrice: json["purchase_price"]?.toDouble(),
      stocks: json["stocks"]?.toDouble(),
      soldStocks: json["sold_stocks"]?.toDouble(),
      holding: json["holding"]?.toDouble(),
      itemUnits: json["item_units"] == null
          ? []
          : List<ItemUnit>.from(
              json["item_units"]!.map((x) => ItemUnit.fromJson(x))),
      status: json["status"],
      delete: json["delete"],
      created: json["created"],
      createdBy: json["created_by"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "item_id": itemId,
        "item": item,
        "image": image,
        "is_sales_tax_exclusive": isSalesTaxExclusive,
        "tax_id": taxId,
        "tax": tax,
        "tax_name": taxName,
        "cess_id": cessId,
        "cess": cess,
        "cess_name": cessName,
        "sku_code": skuCode,
        "hsn_code": hsnCode,
        "unit_id": unitId,
        "unit": unit,
        "selling_price": sellingPrice,
        "purchase_price": purchasePrice,
        "stocks": stocks,
        "sold_stocks": soldStocks,
        "holding": holding,
        "item_units": itemUnits == null
            ? []
            : List<dynamic>.from(itemUnits!.map((x) => x.toJson())),
        "status": status,
        "delete": delete,
        "created": created,
        "created_by": createdBy,
      };

  @override
  List<Object?> get props => [
        id,
        itemId,
        item,
        image,
        isSalesTaxExclusive,
        taxId,
        tax,
        taxName,
        cessId,
        cess,
        cessName,
        skuCode,
        hsnCode,
        unitId,
        unit,
        sellingPrice,
        purchasePrice,
        stocks,
        soldStocks,
        holding,
        itemUnits,
        status,
        delete,
        created,
        createdBy,
      ];
}
