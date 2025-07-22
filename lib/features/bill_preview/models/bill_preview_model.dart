import 'dart:convert';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:yoloworks_invoice/app/constants/app_constants.dart';
import 'package:yoloworks_invoice/core/extension/color_extension.dart';

import '../../../app/styles/colors.dart';
import '../../../core/models/address_detail.dart';
import '../../item/model/item_units.dart';

BillPreviewModel billPreviewModelFromJson(String str) =>
    BillPreviewModel.fromJson(json.decode(str));

String billPreviewModelToJson(BillPreviewModel data) =>
    json.encode(data.toJson());

// ignore: must_be_immutable
class BillPreviewModel extends Equatable {
  final int? id;
  final int? branchId;
  final String? branch;
  final List<AddressDetail>? organizationAddress;
  final String? orgGst;
  final String? logo;
  final String? website;
  final String? orgPhone;
  final String? orgPanNumber;
  final String? orderNumber;
  final String? referenceNumber;
  final String? gst;
  final String? panNumber;
  final int? clientId;
  final String? client;
  final String? clientPhone;
  final String? clientEmail;
  final int? vendorId;
  final String? vendor;
  final String? vendorPhone;
  final String? vendorEmail;
  final List<AddressDetail>? addressDetail;
  final String? orderDate;
  final String? deliveryDate;
  final bool? immediate;
  final int? modeOfTransportationId;
  final String? modeOfTransportation;
  final String? dueDate;
  final int? dueTermId;
  final String? dueTerm;
  final double? billPreviewModelSubTotal;
  final double? subTotal;
  final double? balanceDue;
  final double? discount;
  final double? discountAmount;
  final bool? isDiscountPercentage;
  final bool? isDiscountBeforeTax;
  final double? taxAmount;
  final double? shippingCharge;
  final double? adjustment;
  final double? total;
  final dynamic customField;
  final String? totalInWords;
  final bool? isApproved;
  final int? orderStatusId;
  final String? orderStatusName;
  final String? colorCode;
  final String? notes;
  final String? terms;
  final int? createdBy;
  final bool? status;
  final bool? delete;
  final List<ItemDetail>? itemDetails;
  List<Breakdown>? breakdown;

  Color? get colorValue {
    if (orderStatusId == 4) return AppColors.lightGreenColor;
    return colorCode?.toGetColor();
  }

  BillPreviewModel({
    this.id,
    this.branchId,
    this.branch,
    this.organizationAddress,
    this.orgGst,
    this.logo,
    this.balanceDue,
    this.website,
    this.orgPhone,
    this.orgPanNumber,
    this.orderNumber,
    this.referenceNumber,
    this.gst,
    this.panNumber,
    this.clientId,
    this.client,
    this.clientPhone,
    this.clientEmail,
    this.vendorId,
    this.vendor,
    this.vendorPhone,
    this.vendorEmail,
    this.addressDetail,
    this.orderDate,
    this.deliveryDate,
    this.immediate,
    this.modeOfTransportationId,
    this.modeOfTransportation,
    this.dueDate,
    this.dueTermId,
    this.dueTerm,
    this.billPreviewModelSubTotal,
    this.subTotal,
    this.discount,
    this.discountAmount,
    this.isDiscountPercentage,
    this.isDiscountBeforeTax,
    this.taxAmount,
    this.shippingCharge,
    this.adjustment,
    this.total,
    this.customField,
    this.totalInWords,
    this.isApproved,
    this.orderStatusId,
    this.orderStatusName,
    this.colorCode,
    this.notes,
    this.terms,
    this.createdBy,
    this.status,
    this.delete,
    this.itemDetails,
    this.breakdown,
  });

  factory BillPreviewModel.fromJson(Map<String, dynamic> value) {
    final json = AppConstants.isNotNullJson(value);
    return BillPreviewModel(
      id: json["id"],
      branchId: json["branch_id"],
      branch: json["branch"],
      organizationAddress: json["organization_address"] == null
          ? []
          : List<AddressDetail>.from(json["organization_address"]!
              .map((x) => AddressDetail.fromJson(x))),
      orgGst: json["org_gst"],
      logo: json["logo"],
      website: json["website"],
      orgPhone: json["org_phone"],
      orgPanNumber: json["org_pan_number"],
      orderNumber: json["order_number"] ?? json["invoice_number"],
      referenceNumber: json["reference_number"],
      gst: json["gst"],
      panNumber: json["pan_number"],
      clientId: json["client_id"],
      client: json["client"],
      clientPhone: json["client_phone"],
      clientEmail: json["client_email"],
      vendorId: json["vendor_id"],
      vendor: json["vendor"],
      vendorPhone: json["vendor_phone"],
      vendorEmail: json["vendor_email"],
      addressDetail: json["address_detail"] == null
          ? []
          : List<AddressDetail>.from((json["address_detail"] ?? [])
              .where((element) => element != null)
              .map((x) => AddressDetail.fromJson(x))),
      orderDate: json["order_date"] ?? json["bill_date"],
      deliveryDate: json["delivery_date"],
      immediate: json["immediate"],
      modeOfTransportationId: json["mode_of_transportation_id"],
      modeOfTransportation: json["mode_of_transportation"],
      dueDate: json["due_date"],
      dueTermId: json["due_term_id"],
      dueTerm: json["due_term"],
      billPreviewModelSubTotal: json["sub_total"]?.toDouble(),
      subTotal: double.tryParse("${json["_sub_total"] ?? 0}"),
      balanceDue: json["balance_due"],
      discount: json["discount"]?.toDouble(),
      discountAmount: json["discount_amount"]?.toDouble(),
      isDiscountPercentage: json["is_discount_percentage"],
      isDiscountBeforeTax: json["is_discount_before_tax"],
      taxAmount: json["tax_amount"]?.toDouble(),
      shippingCharge: json["shipping_charge"]?.toDouble(),
      adjustment: json["adjustment"]?.toDouble(),
      total:
          json["total"] != null ? double.parse(json["total"].toString()) : 0.0,
      customField: json["custom_field"] == null ? null : json["custom_field"],
      totalInWords: json["total_in_words"],
      isApproved: json["is_approved"],
      orderStatusId: json["order_status_id"] ?? json['bill_status_id'],
      orderStatusName: json["order_status_name"] ?? json["bill_status"],
      colorCode: json["color_code"],
      notes: json["notes"],
      terms: json["terms"],
      createdBy: json["created_by"],
      status: json["status"],
      delete: json["delete"],
      itemDetails: json["item_details"] == null
          ? []
          : List<ItemDetail>.from(
              json["item_details"]!.map((x) => ItemDetail.fromJson(x))),
      breakdown: json["breakdown"] == null
          ? []
          : List<Breakdown>.from(
              json["breakdown"]!.map((x) => Breakdown.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "branch_id": branchId,
        "branch": branch,
        "balance_due": balanceDue,
        "organization_address": organizationAddress == null
            ? []
            : List<dynamic>.from(organizationAddress!.map((x) => x.toJson())),
        "org_gst": orgGst,
        "logo": logo,
        "website": website,
        "org_phone": orgPhone,
        "org_pan_number": orgPanNumber,
        "order_number": orderNumber,
        "reference_number": referenceNumber,
        "gst": gst,
        "pan_number": panNumber,
        "client_id": clientId,
        "client": client,
        "client_phone": clientPhone,
        "client_email": clientEmail,
        "vendor_id": vendorId,
        "vendor": vendor,
        "vendor_phone": vendorPhone,
        "vendor_email": vendorEmail,
        "address_detail": addressDetail == null
            ? []
            : List<dynamic>.from(addressDetail!.map((x) => x.toJson())),
        "order_date": orderDate,
        "delivery_date": deliveryDate,
        "immediate": immediate,
        "mode_of_transportation_id": modeOfTransportationId,
        "mode_of_transportation": modeOfTransportation,
        "due_date": dueDate,
        "due_term_id": dueTermId,
        "due_term": dueTerm,
        "sub_total": billPreviewModelSubTotal,
        "_sub_total": subTotal,
        "discount": discount,
        "discount_amount": discountAmount,
        "is_discount_percentage": isDiscountPercentage,
        "is_discount_before_tax": isDiscountBeforeTax,
        "tax_amount": taxAmount,
        "shipping_charge": shippingCharge,
        "adjustment": adjustment,
        "total": total,
        "custom_field": customField?.toJson(),
        "total_in_words": totalInWords,
        "is_approved": isApproved,
        "order_status_id": orderStatusId,
        "order_status_name": orderStatusName,
        "color_code": colorCode,
        "notes": notes,
        "terms": terms,
        "created_by": createdBy,
        "status": status,
        "delete": delete,
        "item_details": itemDetails == null
            ? []
            : List<dynamic>.from(itemDetails!.map((x) => x.toJson())),
        "breakdown": breakdown == null
            ? []
            : List<dynamic>.from(breakdown!.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [
        this.id,
        this.branchId,
        this.branch,
        this.organizationAddress,
        this.orgGst,
        this.logo,
        this.balanceDue,
        this.website,
        this.orgPhone,
        this.orgPanNumber,
        this.orderNumber,
        this.referenceNumber,
        this.gst,
        this.panNumber,
        this.clientId,
        this.client,
        this.clientPhone,
        this.clientEmail,
        this.vendorId,
        this.vendor,
        this.vendorPhone,
        this.vendorEmail,
        this.addressDetail,
        this.orderDate,
        this.deliveryDate,
        this.immediate,
        this.modeOfTransportationId,
        this.modeOfTransportation,
        this.dueDate,
        this.dueTermId,
        this.dueTerm,
        this.billPreviewModelSubTotal,
        this.subTotal,
        this.discount,
        this.discountAmount,
        this.isDiscountPercentage,
        this.isDiscountBeforeTax,
        this.taxAmount,
        this.shippingCharge,
        this.adjustment,
        this.total,
        this.customField,
        this.totalInWords,
        this.isApproved,
        this.orderStatusId,
        this.orderStatusName,
        this.colorCode,
        this.notes,
        this.terms,
        this.createdBy,
        this.status,
        this.delete,
        this.itemDetails,
        this.breakdown,
      ];
}

class Breakdown extends Equatable {
  final String? hsnCode;
  final String? taxValue;
  final String? taxType;
  final double? taxAmount;

  Breakdown({
    this.hsnCode,
    this.taxValue,
    this.taxType,
    this.taxAmount,
  });

  factory Breakdown.fromJson(Map<String, dynamic> value) {
    final json = AppConstants.isNotNullJson(value);
    return Breakdown(
      hsnCode: json["hsn_code"],
      taxValue: json["tax_value"],
      taxType: json["tax_type"],
      taxAmount: json["tax_amount"]?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        "hsn_code": hsnCode,
        "tax_value": taxValue,
        "tax_type": taxType,
        "tax_amount": taxAmount,
      };

  @override
  List<Object?> get props => [
        this.hsnCode,
        this.taxValue,
        this.taxType,
        this.taxAmount,
      ];
}

class CustomField {
  CustomField();

  factory CustomField.fromJson(Map<String, dynamic> json) => CustomField();

  Map<String, dynamic> toJson() => {};
}

// ignore: must_be_immutable
class ItemDetail extends Equatable {
  final int? id;
  final int? orderId;
  final int? invoiceId;
  final int? unitId;
  final String? unit;
  final String? image;
  final int? itemId;
  final String? item;
  final String? hsnCode;
  final String? skuCode;
  final String? description;
  final double? quantity;
  final double? rate;
  final double? originalPrice;
  final int? taxId;
  final double? tax;
  final String? taxName;
  final int? cessId;
  final double? cess;
  final String? cessName;
  final double? discount;
  final double? discountAmount;
  final List<ItemUnit>? itemUnits;
  final List<Scheme>? scheme;
  final bool? isDiscountPercentage;
  final bool? isExclusiveTax;
  final double? totalAmount;
  final double? taxAmount;
  final double? subTotal;
  final String? itemNotes;
  final bool? status;
  final bool? delete;
  final DateTime? created;
  final int? createdBy;
  final bool? isProduct;
  final bool? isVolume;
  final int? schemeRuleId;
  final int? schemeId;
  final String? schemeName;
  final double? value;
  final int? combineWithId;
  final String? combineWith;
  bool? isFocOpen;

  ItemDetail(
      {this.id,
      this.orderId,
      this.invoiceId,
      this.unitId,
      this.unit,
      this.image,
      this.itemId,
      this.item,
      this.hsnCode,
      this.skuCode,
      this.description,
      this.quantity,
      this.rate,
      this.originalPrice,
      this.taxId,
      this.tax,
      this.taxName,
      this.cessId,
      this.cess,
      this.cessName,
      this.discount,
      this.discountAmount,
      this.itemUnits,
      this.scheme,
      this.isDiscountPercentage,
      this.isExclusiveTax,
      this.totalAmount,
      this.taxAmount,
      this.subTotal,
      this.itemNotes,
      this.status,
      this.delete,
      this.created,
      this.createdBy,
      this.isProduct,
      this.isVolume,
      this.schemeRuleId,
      this.schemeId,
      this.schemeName,
      this.value,
      this.combineWithId,
      this.combineWith,
      this.isFocOpen = true});

  factory ItemDetail.fromJson(Map<String, dynamic> value) {
    final json = AppConstants.isNotNullJson(value);
    return ItemDetail(
      id: json["id"],
      orderId: json["order_id"],
      invoiceId: json["invoice_id"],
      unitId: json["unit_id"],
      unit: json["unit"],
      image: json["image"],
      itemId: json["item_id"],
      item: json["item"],
      hsnCode: json["hsn_code"],
      skuCode: json["sku_code"],
      description: json["description"],
      quantity: json["quantity"]?.toDouble(),
      originalPrice: json["original_price"]?.toDouble(),
      rate: json["rate"],
      taxId: json["tax_id"],
      tax: json["tax"]?.toDouble(),
      taxName: json["tax_name"],
      cessId: json["cess_id"],
      cess: json["cess"]?.toDouble(),
      cessName: json["cess_name"],
      discount: json["discount"]?.toDouble(),
      discountAmount: json["discount_amount"]?.toDouble(),
      itemUnits: json["item_units"] == null
          ? []
          : List<ItemUnit>.from(
              json["item_units"]!.map((x) => ItemUnit.fromJson(x))),
      scheme: json["scheme"] == null
          ? []
          : List<Scheme>.from(json["scheme"]!.map((x) => Scheme.fromJson(x))),
      isDiscountPercentage: json["is_discount_percentage"],
      isExclusiveTax: json["is_exclusive_tax"],
      totalAmount: json["total_amount"]?.toDouble(),
      taxAmount: json["tax_amount"]?.toDouble(),
      subTotal: json["sub_total"]?.toDouble(),
      itemNotes: json["item_notes"],
      status: json["status"],
      delete: json["delete"],
      created: json["created"] == null ? null : DateTime.parse(json["created"]),
      createdBy: json["created_by"],
      isProduct: json["is_product"],
      isVolume: json["is_volume"],
      schemeRuleId: json["scheme_rule_id"],
      schemeId: json["scheme_id"],
      schemeName: json["scheme_name"],
      value: json["value"]?.toDouble(),
      combineWithId: json["combine_with_id"],
      combineWith: json["combine_with"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "unit_id": unitId,
        "unit": unit,
        "image": image,
        "item_id": itemId,
        "item": item,
        "hsn_code": hsnCode,
        "sku_code": skuCode,
        "description": description,
        "quantity": quantity,
        "rate": rate,
        "original_price": originalPrice,
        "tax_id": taxId,
        "tax": tax,
        "tax_name": taxName,
        "cess_id": cessId,
        "cess": cess,
        "cess_name": cessName,
        "discount": discount,
        "discount_amount": discountAmount,
        "item_units": itemUnits == null
            ? []
            : List<dynamic>.from(itemUnits!.map((x) => x.toJson())),
        "scheme": scheme == null
            ? []
            : List<dynamic>.from(scheme!.map((x) => x.toJson())),
        "is_discount_percentage": isDiscountPercentage,
        "is_exclusive_tax": isExclusiveTax,
        "total_amount": totalAmount,
        "tax_amount": taxAmount,
        "sub_total": subTotal,
        "item_notes": itemNotes,
        "status": status,
        "delete": delete,
        "created": created?.toIso8601String(),
        "created_by": createdBy,
        "is_product": isProduct,
        "is_volume": isVolume,
        "scheme_rule_id": schemeRuleId,
        "scheme_id": schemeId,
        "scheme_name": schemeName,
        "value": value,
        "combine_with_id": combineWithId,
        "combine_with": combineWith,
      };

  @override
  List<Object?> get props => [
        this.id,
        this.orderId,
        this.unitId,
        this.unit,
        this.image,
        this.itemId,
        this.item,
        this.hsnCode,
        this.skuCode,
        this.description,
        this.quantity,
        this.rate,
        this.taxId,
        this.tax,
        this.taxName,
        this.cessId,
        this.cess,
        this.cessName,
        this.discount,
        this.discountAmount,
        this.itemUnits,
        this.scheme,
        this.isDiscountPercentage,
        this.isExclusiveTax,
        this.totalAmount,
        this.taxAmount,
        this.subTotal,
        this.itemNotes,
        this.status,
        this.delete,
        this.created,
        this.createdBy,
        this.isProduct,
        this.isVolume,
        this.schemeRuleId,
        this.schemeId,
        this.schemeName,
        this.value,
        this.combineWithId,
        this.combineWith,
        this.isFocOpen = true
      ];
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

  factory Scheme.fromJson(Map<String, dynamic> value) {
    final json = AppConstants.isNotNullJson(value);
    return Scheme(
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
      created: json["created"] == null ? null : DateTime.parse(json["created"]),
      createdBy: json["created_by"],
    );
  }

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
  List<Object?> get props => [
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
      ];
}
