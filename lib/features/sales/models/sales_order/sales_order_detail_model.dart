import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:yoloworks_invoice/app/constants/app_constants.dart';
import 'package:yoloworks_invoice/core/extension/datetime_extension.dart';

import '../../../../core/models/address_detail.dart';
import '../../../bill_preview/models/bill_preview_model.dart';

SalesOrderDetailModel salesOrderDetailModelFromJson(String str) =>
    SalesOrderDetailModel.fromJson(json.decode(str));

String salesOrderDetailModelToJson(SalesOrderDetailModel data) =>
    json.encode(data.toJson());

class SalesOrderDetailModel extends Equatable {
  final int? id;
  final int? branchId;
  final String? branch;
  final String? orderNumber;
  final List<int>? warehouse;
  final int? clientId;
  final String? client;
  final int? vendorId;
  final String? vendor;
  final int? discountAccount;
  final String? discountAccountName;
  final dynamic priceListId;
  final String? priceList;
  final bool? hasPriceList;
  final List<AddressDetail>? addressDetail;
  final String? logo;
  final String? orderDate;
  final String? dueDate;
  final String? deliveryDate;
  final String? expectedDeliveryDate;
  final String? referenceDate;
  final String? referenceNo;
  final int? placeOfSupply;
  final int? dueTermId;
  final String? dueTerm;
  final dynamic salesPersonId;
  final String? salesPerson;
  final String? file;
  final double? salesOrderDetailModelSubTotal;
  final double? subTotal;
  final double? balanceDue;
  final double? discount;
  final bool? isDiscountPercentage;
  final bool? isDiscountBeforeTax;
  final double? taxAmount;
  final double? shippingCharge;
  final double? adjustment;
  final double? total;
  final dynamic customField;
  final TaxSource? taxSource;
  final double? exchangeRate;
  final bool? isRecurring;
  final dynamic notes;
  final String? terms;
  final dynamic modeOfTransportationId;
  final dynamic modeOfTransportation;
  final bool? isApproved;
  final int? orderStatusId;
  final String? orderStatusName;
  final String? colorCode;
  final int? createdBy;
  final bool? status;
  final bool? delete;
  final int? itemCount;
  final List<ItemDetail>? itemDetails;

  SalesOrderDetailModel(
      {this.id,
      this.referenceDate,
      this.referenceNo,
      this.expectedDeliveryDate,
      this.warehouse,
      this.branchId,
      this.branch,
      this.orderNumber,
      this.clientId,
      this.client,
      this.vendorId,
      this.vendor,
      this.priceListId,
      this.priceList,
      this.hasPriceList,
      this.addressDetail,
      this.logo,
      this.orderDate,
      this.dueDate,
      this.deliveryDate,
      this.dueTermId,
      this.dueTerm,
      this.salesPersonId,
      this.salesPerson,
      this.file,
      this.salesOrderDetailModelSubTotal,
      this.subTotal,
      this.balanceDue,
      this.discount,
      this.isDiscountPercentage,
      this.isDiscountBeforeTax,
      this.taxAmount,
      this.shippingCharge,
      this.adjustment,
      this.total,
      this.customField,
      this.taxSource,
      this.exchangeRate,
      this.isRecurring,
      this.notes,
      this.terms,
      this.modeOfTransportationId,
      this.modeOfTransportation,
      this.isApproved,
      this.orderStatusId,
      this.orderStatusName,
      this.colorCode,
      this.createdBy,
      this.status,
      this.delete,
      this.itemCount,
      this.itemDetails,
      this.discountAccount,
      this.discountAccountName,
      this.placeOfSupply});

  DateTime? get deliveryDateFormatted =>
      deliveryDate != null && deliveryDate != ""
          ? deliveryDate!.toFormattedDateTime()
          : null;

  DateTime? get exceptedDeliveryDateFormatted =>
      expectedDeliveryDate != null && expectedDeliveryDate != ""
          ? expectedDeliveryDate!.toFormattedDateTime()
          : null;

  DateTime? get referenceDateFormatted =>
      referenceDate != null && referenceDate != ""
          ? DateTime.parse(referenceDate!)
          : null;

  DateTime? get dueDateFormatted =>
      dueDate != null && dueDate != "" ? dueDate!.toFormattedDateTime() : null;

  DateTime? get billDateFormatted => orderDate != null && orderDate != ""
      ? orderDate!.toFormattedDateTime()
      : null;

  factory SalesOrderDetailModel.fromJson(Map<String, dynamic> value) {
    final json = AppConstants.isNotNullJson(value);
    return SalesOrderDetailModel(
      warehouse: json["warehouse"] == null
          ? []
          : List<int>.from(json["warehouse"]!.map((x) => x)),
      id: json["id"],
      branchId: json["branch_id"],
      branch: json["branch"],
      orderNumber: json["order_number"],
      clientId: json["client_id"],
      client: json["client"],
      vendorId: json["vendor_id"],
      vendor: json["vendor"],
      referenceDate: json["reference_date"],
      referenceNo: json["reference_number"],
      discountAccount: json["discount_account"],
      discountAccountName: json["discount_account_name"],
      priceListId: int.tryParse("${json["price_list_id"] ?? ""}"),
      priceList: json["price_list"],
      placeOfSupply: json["place_of_supply"],
      hasPriceList: json["has_price_list"],
      addressDetail: json["address_detail"] == null
          ? []
          : List<AddressDetail>.from(
              json["address_detail"]!.map((x) => AddressDetail.fromJson(x))),
      logo: json["logo"],
      orderDate: json["order_date"],
      expectedDeliveryDate: json["expected_delivery_date"],
      dueDate: json["due_date"],
      deliveryDate: json["delivery_date"],
      dueTermId: json["due_term_id"],
      dueTerm: json["due_term"],
      salesPersonId: json["sales_person_id"],
      salesPerson: json["sales_person"],
      file: json["file"],
      salesOrderDetailModelSubTotal: json["sub_total"]?.toDouble(),
      subTotal: json["_sub_total"]?.toDouble(),
      balanceDue: json["balance_due"]?.toDouble(),
      discount: json["discount"]?.toDouble(),
      isDiscountPercentage: json["is_discount_percentage"],
      isDiscountBeforeTax: json["is_discount_before_tax"],
      taxAmount: json["tax_amount"]?.toDouble(),
      shippingCharge: json["shipping_charge"]?.toDouble(),
      adjustment: json["adjustment"]?.toDouble(),
      total: json["total"]?.toDouble(),
      customField: json["custom_field"] == null ? null : (json["custom_field"]),
      taxSource: json["tax_source"] == null
          ? null
          : TaxSource.fromJson(json["tax_source"]),
      exchangeRate: json["exchange_rate"]?.toDouble(),
      isRecurring: json["is_recurring"],
      notes: json["notes"],
      terms: json["terms"],
      modeOfTransportationId: json["mode_of_transportation_id"],
      modeOfTransportation: json["mode_of_transportation"],
      isApproved: json["is_approved"],
      orderStatusId: json["order_status_id"],
      orderStatusName: json["order_status_name"],
      colorCode: json["color_code"],
      createdBy: json["created_by"],
      status: json["status"],
      delete: json["delete"],
      itemCount: json["item_count"],
      itemDetails: json["item_details"] == null
          ? []
          : List<ItemDetail>.from(
              json["item_details"]!.map((x) => ItemDetail.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "reference_number": referenceNo,
        "reference_date": referenceDate,
        "place_of_supply": placeOfSupply,
        "expected_delivery_date": expectedDeliveryDate,
        "discount_account": discountAccount,
        "discount_account_name": discountAccountName,
        "warehouse": warehouse == null
            ? []
            : List<dynamic>.from(warehouse!.map((x) => x)),
        "id": id,
        "branch_id": branchId,
        "branch": branch,
        "order_number": orderNumber,
        "client_id": clientId,
        "client": client,
        "vendor_id": vendorId,
        "vendor": vendor,
        "price_list_id": priceListId,
        "price_list": priceList,
        "has_price_list": hasPriceList,
        "address_detail": addressDetail == null
            ? []
            : List<dynamic>.from(addressDetail!.map((x) => x.toJson())),
        "logo": logo,
        "order_date": orderDate,
        "due_date": dueDate,
        "delivery_date": deliveryDate,
        "due_term_id": dueTermId,
        "due_term": dueTerm,
        "sales_person_id": salesPersonId,
        "sales_person": salesPerson,
        "file": file,
        "sub_total": salesOrderDetailModelSubTotal,
        "_sub_total": subTotal,
        "balance_due": balanceDue,
        "discount": discount,
        "is_discount_percentage": isDiscountPercentage,
        "is_discount_before_tax": isDiscountBeforeTax,
        "tax_amount": taxAmount,
        "shipping_charge": shippingCharge,
        "adjustment": adjustment,
        "total": total,
        "custom_field": customField?.toJson(),
        "tax_source": taxSource?.toJson(),
        "exchange_rate": exchangeRate,
        "is_recurring": isRecurring,
        "notes": notes,
        "terms": terms,
        "mode_of_transportation_id": modeOfTransportationId,
        "mode_of_transportation": modeOfTransportation,
        "is_approved": isApproved,
        "order_status_id": orderStatusId,
        "order_status_name": orderStatusName,
        "color_code": colorCode,
        "created_by": createdBy,
        "status": status,
        "delete": delete,
        "item_count": itemCount,
        "item_details": itemDetails == null
            ? []
            : List<dynamic>.from(itemDetails!.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [toJson()];
}

class Scheme extends Equatable {
  final int? id;
  final bool? isProduct;
  final bool? isVolume;
  final int? schemeRuleId;
  final int? schemeId;
  final String? schemeName;
  final double? value;
  final int? unitId;
  final String? unit;
  final int? itemId;
  final String? item;
  final String? hsnCode;
  final String? skuCode;
  final String? description;
  final String? image;
  final int? combineWithId;
  final String? combineWith;
  final bool? status;
  final bool? delete;
  final DateTime? created;
  final int? createdBy;

  Scheme({
    this.id,
    this.isProduct,
    this.isVolume,
    this.schemeRuleId,
    this.schemeId,
    this.schemeName,
    this.value,
    this.unitId,
    this.unit,
    this.itemId,
    this.item,
    this.hsnCode,
    this.skuCode,
    this.description,
    this.image,
    this.combineWithId,
    this.combineWith,
    this.status,
    this.delete,
    this.created,
    this.createdBy,
  });

  factory Scheme.fromJson(Map<String, dynamic> json) => Scheme(
        id: json["id"],
        isProduct: json["is_product"],
        isVolume: json["is_volume"],
        schemeRuleId: json["scheme_rule_id"],
        schemeId: json["scheme_id"],
        schemeName: json["scheme_name"],
        value: json["value"]?.toDouble(),
        unitId: json["unit_id"],
        unit: json["unit"],
        itemId: json["item_id"],
        item: json["item"],
        hsnCode: json["hsn_code"],
        skuCode: json["sku_code"],
        description: json["description"],
        image: json["image"],
        combineWithId: json["combine_with_id"],
        combineWith: json["combine_with"],
        status: json["status"],
        delete: json["delete"],
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        createdBy: json["created_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_product": isProduct,
        "is_volume": isVolume,
        "scheme_rule_id": schemeRuleId,
        "scheme_id": schemeId,
        "scheme_name": schemeName,
        "value": value,
        "unit_id": unitId,
        "unit": unit,
        "item_id": itemId,
        "item": item,
        "hsn_code": hsnCode,
        "sku_code": skuCode,
        "description": description,
        "image": image,
        "combine_with_id": combineWithId,
        "combine_with": combineWith,
        "status": status,
        "delete": delete,
        "created": created?.toIso8601String(),
        "created_by": createdBy,
      };

  @override
  List<Object?> get props => [toJson()];
}

class TaxSource extends Equatable {
  final int? id;
  final String? name;
  final double? rate;
  final int? code;
  final int? sectionId;
  final String? section;
  final String? description;
  final int? createdBy;
  final bool? status;
  final bool? delete;
  final int? type;

  TaxSource({
    this.id,
    this.name,
    this.rate,
    this.code,
    this.sectionId,
    this.section,
    this.description,
    this.createdBy,
    this.status,
    this.delete,
    this.type,
  });

  factory TaxSource.fromJson(Map<String, dynamic> json) => TaxSource(
        id: json["id"],
        name: json["name"],
        rate: json["rate"]?.toDouble(),
        code: json["code"],
        sectionId: json["section_id"],
        section: json["section"],
        description: json["description"],
        createdBy: json["created_by"],
        status: json["status"],
        delete: json["delete"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "rate": rate,
        "code": code,
        "section_id": sectionId,
        "section": section,
        "description": description,
        "created_by": createdBy,
        "status": status,
        "delete": delete,
        "type": type,
      };

  @override
  List<Object?> get props => [toJson()];
}
