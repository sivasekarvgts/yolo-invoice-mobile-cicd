import 'package:yoloworks_invoice/app/constants/app_constants.dart';
import 'package:yoloworks_invoice/core/extension/currency_extension.dart';

import 'item_list_model.dart';
import '../../../item/model/item_units.dart';
import '../../../../utils/gst_calculation_utils.dart';

// ignore: must_be_immutable
class SalesLineItem {
  int? id;
  int? itemId;
  int? pk;
  int? taxId;
  int? cessId;

  String? skuCode;
  String? hsnCode;
  String? itemName;
  String? unitName;
  String? notes;

  int? lineItemDiscountType;
  String? lineItemDiscountValue;

  String? errorMsg;
  String? discountErrorMsg;

  double? qty;
  double? price;
  double? originalPrice;

  double? taxValue;
  double? itemUnitQty;
  double? cessRateName;
  double? primaryUnitQty;

  int? unitId;
  int? offers;
  int? itemUnitId;

  bool? isOffer;
  bool? isTaxInclusive;
  bool? isGstRegistered;
  bool? isFocItemPresent;
  bool? isSalesTaxExclusive;
  bool? isLineItemDisInclusive;

  ItemUnit? itemUnit;
  ItemDatum? itemData;
  List<ItemUnit>? itemUnitList;

  int schemeLength;
  List<int>? schemeList;

  String get formattedPrice => priceValue.toCurrencyFormat();
  String get formattedPriceQty => priceQtyValue.toCurrencyFormat();
  String get formattedSubTotal {
    if (lineItemDiscountValue != null) {
      final lineItemDisPrice = isLineItemDisInclusive == true
          ? lineItemDiscountAmt + gstTaxValue
          : lineItemDiscountAmt;
      return (lineItemDisPrice).toCurrencyFormat();
    }
    return (priceQtyValue).toCurrencyFormat();
  }

  String get singleItemPrice {
    if (lineItemDiscountValue != null) {
      final lineItemDisPrice = isLineItemDisInclusive == true
          ? lineItemDiscountAmt + gstTaxValue
          : lineItemDiscountAmt;
      return (lineItemDisPrice).toCurrencyFormat();
    }
    return priceValue.toCurrencyFormat();
  }

  double get taxPercentage {
    return (taxValue ?? 0.0) + cessRate;
  }

  double get qtyGstValue => gstTaxValue;

  double get gstTaxValue {
    double newPrice =
        (lineItemDiscountValue != null ? lineItemDiscountAmt : priceQtyValue);
    if (isLineItemDisInclusive == true || isSalesTaxExclusive == true) {
      return (newPrice) * (taxPercentage / 100);
    }
    return ((newPrice) * (taxPercentage / (100 + taxPercentage)));
  }

  double get cessRate => (cessRateName ?? 0.0);
  double get taxRate => (taxValue ?? 0.0);

  Map get taxBreakDown {
    final gstBreakDown = {
      'price':
          (lineItemDiscountValue != null ? lineItemDiscountAmt : priceQtyValue),
      'taxRate': taxRate,
      'cessRate': cessRate,
      'taxPercentage': taxPercentage,
      'isLineItemDisInclusive': isLineItemDisInclusive,
      'lineItemDiscountValue': lineItemDiscountValue,
      'isSalesTaxExclusive': isSalesTaxExclusive
    };
    return GSTCalculationUtils.taxBreakDown(gstBreakDown);
  }

  double get lineItemDiscountAmt {
    if (lineItemDiscountValue == null ||
        lineItemDiscountValue?.isEmpty == true) {
      return 0.0;
    }
    double discountValue = double.parse(lineItemDiscountValue!);
    if (isGstRegistered == false) {
      final value = isDiscountPercentage
          ? priceQtyValue * (discountValue / 100)
          : discountValue;
      return priceQtyValue - value;
    }

    if (isSalesTaxExclusive == false) {
      final taxAmt = (priceQtyValue * taxPercentage) / (100 + taxPercentage);
      final newPrice = priceQtyValue - taxAmt;
      if (!isDiscountPercentage) return (newPrice - discountValue);
      final disValue = newPrice * (discountValue / 100);
      return newPrice - disValue;
    }

    if (!isDiscountPercentage) {
      return (priceQtyValue - discountValue);
    }
    final disValue = priceQtyValue * (discountValue / 100);
    return priceQtyValue - disValue;
  }

  double? get discountValue {
    if (lineItemDiscountValue == null) return null;
    return double.parse(lineItemDiscountValue!);
  }

  double get discountAppliedTotalAmt {
    double discountValue = double.parse(lineItemDiscountValue!);
    if (!isDiscountPercentage) {
      return discountValue;
    }
    return priceQtyValue * (discountValue / 100);
  }

  double get priceValue => (price ?? 0);

  double get priceQtyValue => (price ?? 0) * (qtyValue);

  double get qtyValue => (qty ?? 0);

  String get qtyFormattedValue => AppConstants.removeZero(qtyValue);

  bool get isDiscountPercentage => lineItemDiscountType == 1;

  String get formattedGSTValue => gstTaxValue.toCurrencyFormat();

  SalesLineItem(
      {this.id,
      this.pk,
      this.qty,
      this.cessId,
      this.taxId,
      this.itemUnitQty,
      this.discountErrorMsg,
      this.price,
      this.originalPrice,
      this.itemName,
      this.notes,
      this.skuCode,
      this.hsnCode,
      this.itemId,
      this.unitId,
      this.itemUnitId,
      this.itemUnitList,
      this.unitName,
      this.cessRateName,
      this.taxValue,
      this.errorMsg,
      this.isOffer,
      this.primaryUnitQty,
      this.isFocItemPresent,
      this.schemeList,
      this.isTaxInclusive,
      this.isSalesTaxExclusive,
      this.itemUnit,
      this.itemData,
      this.schemeLength = 0,
      this.lineItemDiscountType = 1,
      this.isLineItemDisInclusive,
      this.lineItemDiscountValue,
      this.isGstRegistered = true});

  Map<String, dynamic> toJson() {
    return {
      'pk': pk,
      'id': id,
      'qty': qty,
      'price': price,
      'itemId': itemId,
      'unitId': unitId,
      'itemUnitId': itemUnitId,
      'taxValue': taxValue,
      'unitName': unitName,
      'primaryUnitQty': primaryUnitQty,
      'isTaxInclusive': isTaxInclusive,
      'isSalesTaxExclusive': isSalesTaxExclusive,
      'schemeList': schemeList,
      'isFocItemPresent': isFocItemPresent,
      "schemeLength": schemeLength,
      'lineItemDiscountType': lineItemDiscountType,
      'lineItemDiscountValue': lineItemDiscountValue,
      'taxId': taxId,
      'cessId': cessId,
      'itemUnitQty': itemUnitQty,
      'discountErrorMsg': discountErrorMsg,
      'originalPrice': originalPrice,
      'itemName': itemName,
      'notes': notes,
      'skuCode': skuCode,
      'hsnCode': hsnCode,
      'cessRateName': cessRateName,
      'errorMsg': errorMsg,
      'isOffer': isOffer,
      'isLineItemDisInclusive': isLineItemDisInclusive,
      'isGstRegistered': isGstRegistered,
      'itemUnit': itemUnit?.toJson(),
      'itemData': itemData?.toJson(),
      'itemUnitList': itemUnitList?.map((e) => e.toJson()).toList(),
    };
  }

  factory SalesLineItem.fromJson(Map<String, dynamic> json) {
    return SalesLineItem(
      id: json['id'],
      pk: json['pk'],
      qty: (json['qty'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble(),
      itemId: json['itemId'],
      unitId: json['unitId'],
      itemUnitId: json['itemUnitId'],
      taxValue: (json['taxValue'] as num?)?.toDouble(),
      unitName: json['unitName'],
      primaryUnitQty: (json['primaryUnitQty'] as num?)?.toDouble(),
      isTaxInclusive: json['isTaxInclusive'],
      isSalesTaxExclusive: json['isSalesTaxExclusive'],
      schemeList:
          (json['schemeList'] as List<dynamic>?)?.map((e) => e as int).toList(),
      isFocItemPresent: json['isFocItemPresent'],
      schemeLength: json['schemeLength'],
      lineItemDiscountType: json['lineItemDiscountType'],
      lineItemDiscountValue: json['lineItemDiscountValue'],
      taxId: json['taxId'],
      cessId: json['cessId'],
      itemUnitQty: (json['itemUnitQty'] as num?)?.toDouble(),
      discountErrorMsg: json['discountErrorMsg'],
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
      itemName: json['itemName'],
      notes: json['notes'],
      skuCode: json['skuCode'],
      hsnCode: json['hsnCode'],
      cessRateName: (json['cessRateName'] as num?)?.toDouble(),
      errorMsg: json['errorMsg'],
      isOffer: json['isOffer'],
      itemUnit:
          json['itemUnit'] != null ? ItemUnit.fromJson(json['itemUnit']) : null,
      itemData: json['itemData'] != null
          ? ItemDatum.fromJson(json['itemData'])
          : null,
      itemUnitList: json['itemUnitList'] != null
          ? (json['itemUnitList'] as List)
              .map((e) => ItemUnit.fromJson(e))
              .toList()
          : null,
      isLineItemDisInclusive: json['isLineItemDisInclusive'],
      isGstRegistered: json['isGstRegistered'] ?? true,
    );
  }
}
