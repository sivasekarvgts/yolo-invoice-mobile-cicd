import 'dart:convert';

import 'package:equatable/equatable.dart';
import '../../../../app/constants/app_constants.dart';

import '../../../../core/extension/datetime_extension.dart';
import '../../../../core/models/address_detail.dart';
import '../sales_order/sales_order_detail_model.dart';
import '../../../bill_preview/models/bill_preview_model.dart';

SalesInvoiceDetailModel salesInvoiceDetailModelFromJson(String str) =>
    SalesInvoiceDetailModel.fromJson(json.decode(str));

String salesInvoiceDetailModelToJson(SalesInvoiceDetailModel data) =>
    json.encode(data.toJson());

class SalesInvoiceDetailModel extends Equatable {
  final int? id;
  final int? branchId;
  final String? branch;
  final String? invoiceNumber;
  final String? referenceNumber;
  final int? clientId;
  final String? client;
  final int? vendorId;
  final String? vendor;
  final int? priceListId;
  final String? priceList;
  final bool? hasPriceList;
  final List<AddressDetail>? addressDetail;
  final int? placeOfSupply;
  final double? roundOff;
  final dynamic logo;
  final String? billDate;
  final String? dueDate;
  final String? dueStatus;
  final String? colorCode;
  final int? dueTermId;
  final String? dueTerm;
  final dynamic salesPersonId;
  final String? salesPerson;
  final String? file;
  final double? salesInvoiceDetailModelSubTotal;
  final double? subTotal;
  final double? balanceDue;
  final double? discount;
  final bool? isDiscountPercentage;
  final bool? isDiscountBeforeTax;
  final int? discountAccount;
  final String? discountAccountName;
  final double? taxAmount;
  final double? shippingCharge;
  final double? adjustment;
  final double? total;
  final Map<dynamic, dynamic>? customField;
  final TaxSource? taxSource;
  final double? exchangeRate;
  final bool? isRecurring;
  final dynamic notes;
  final String? terms;
  final int? billStatusId;
  final String? billStatus;
  final int? createdBy;
  final bool? status;
  final bool? delete;
  final List<int>? warehouse;
  final int? itemCount;
  final List<ItemDetail>? itemDetails;

  SalesInvoiceDetailModel({
    this.id,
    this.branchId,
    this.branch,
    this.invoiceNumber,
    this.referenceNumber,
    this.clientId,
    this.client,
    this.vendorId,
    this.vendor,
    this.priceListId,
    this.priceList,
    this.hasPriceList,
    this.addressDetail,
    this.placeOfSupply,
    this.roundOff,
    this.logo,
    this.billDate,
    this.dueDate,
    this.dueStatus,
    this.colorCode,
    this.dueTermId,
    this.dueTerm,
    this.salesPersonId,
    this.salesPerson,
    this.file,
    this.salesInvoiceDetailModelSubTotal,
    this.subTotal,
    this.balanceDue,
    this.discount,
    this.isDiscountPercentage,
    this.isDiscountBeforeTax,
    this.discountAccount,
    this.discountAccountName,
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
    this.billStatusId,
    this.billStatus,
    this.createdBy,
    this.status,
    this.delete,
    this.warehouse,
    this.itemCount,
    this.itemDetails,
  });

  DateTime? get dueDateFormatted =>
      dueDate != null ? dueDate!.toFormattedDateTime() : null;

  DateTime? get billDateFormatted =>
      billDate != null ? billDate!.toFormattedDateTime() : null;

  factory SalesInvoiceDetailModel.fromJson(Map<String, dynamic> value) {
    final json = AppConstants.isNotNullJson(value);
    return SalesInvoiceDetailModel(
      id: json["id"],
      branchId: json["branch_id"],
      branch: json["branch"],
      invoiceNumber: json["invoice_number"],
      referenceNumber: json["reference_number"],
      clientId: json["client_id"],
      client: json["client"],
      vendorId: json["vendor_id"],
      vendor: json["vendor"],
      priceListId: int.tryParse("${json["price_list_id"] ?? "0"}"),
      priceList: json["price_list"],
      hasPriceList: json["has_price_list"],
      addressDetail: json["address_detail"] == null
          ? []
          : List<AddressDetail>.from(
              json["address_detail"]!.map((x) => AddressDetail.fromJson(x))),
      placeOfSupply: json["place_of_supply"],
      roundOff: json["round_off"]?.toDouble(),
      logo: json["logo"],
      billDate: json["bill_date"],
      dueDate: json["due_date"],
      dueStatus: json["due_status"],
      colorCode: json["color_code"],
      dueTermId: json["due_term_id"],
      dueTerm: json["due_term"],
      salesPersonId: json["sales_person_id"],
      salesPerson: json["sales_person"],
      file: json["file"],
      salesInvoiceDetailModelSubTotal: json["sub_total"]?.toDouble(),
      subTotal: json["_sub_total"],
      balanceDue: json["balance_due"],
      discount: json["discount"],
      isDiscountPercentage: json["is_discount_percentage"],
      isDiscountBeforeTax: json["is_discount_before_tax"],
      discountAccount: json["discount_account"],
      discountAccountName: json["discount_account_name"],
      taxAmount: json["tax_amount"]?.toDouble(),
      shippingCharge: json["shipping_charge"],
      adjustment: json["adjustment"],
      total: json["total"],
      customField: json["custom_field"] == null
          ? null
          : Map<dynamic, dynamic>.from(json["custom_field"]),
      taxSource: json["tax_source"] == null
          ? null
          : TaxSource.fromJson(json["tax_source"]),
      exchangeRate: json["exchange_rate"],
      isRecurring: json["is_recurring"],
      notes: json["notes"],
      terms: json["terms"],
      billStatusId: json["bill_status_id"],
      billStatus: json["bill_status"],
      createdBy: json["created_by"],
      status: json["status"],
      delete: json["delete"],
      warehouse: json["warehouse"] == null
          ? []
          : List<int>.from(json["warehouse"]!.map((x) => x)),
      itemCount: json["item_count"],
      itemDetails: json["item_details"] == null
          ? []
          : List<ItemDetail>.from(
              json["item_details"]!.map((x) => ItemDetail.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "discount_account": discountAccount,
        "discount_account_name": discountAccountName,
        "id": id,
        "branch_id": branchId,
        "branch": branch,
        "invoice_number": invoiceNumber,
        "reference_number": referenceNumber,
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
        "place_of_supply": placeOfSupply,
        "round_off": roundOff,
        "logo": logo,
        "bill_date": billDate,
        "due_date": dueDate,
        "due_status": dueStatus,
        "color_code": colorCode,
        "due_term_id": dueTermId,
        "due_term": dueTerm,
        "sales_person_id": salesPersonId,
        "sales_person": salesPerson,
        "file": file,
        "sub_total": salesInvoiceDetailModelSubTotal,
        "_sub_total": subTotal,
        "balance_due": balanceDue,
        "discount": discount,
        "is_discount_percentage": isDiscountPercentage,
        "is_discount_before_tax": isDiscountBeforeTax,
        "tax_amount": taxAmount,
        "shipping_charge": shippingCharge,
        "adjustment": adjustment,
        "total": total,
        "custom_field": customField == null ? null : Map.from(customField!),
        "tax_source": taxSource?.toJson(),
        "exchange_rate": exchangeRate,
        "is_recurring": isRecurring,
        "notes": notes,
        "terms": terms,
        "bill_status_id": billStatusId,
        "bill_status": billStatus,
        "created_by": createdBy,
        "status": status,
        "delete": delete,
        "warehouse": warehouse == null
            ? []
            : List<dynamic>.from(warehouse!.map((x) => x)),
        "item_count": itemCount,
        "item_details": itemDetails == null
            ? []
            : List<dynamic>.from(itemDetails!.map((x) => x.toJson())),
      };

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class CustomField {
  CustomField();

  factory CustomField.fromJson(Map<String, dynamic> json) => CustomField();

  Map<String, dynamic> toJson() => {};
}

class SalesInvoiceDetailItemDetail {
  final int? id;
  final int? pk;
  final bool? isCredited;
  final int? invoiceId;
  final int? warehouse;
  final int? unitId;
  final String? unit;
  final dynamic hsnCode;
  final String? skuCode;
  final dynamic image;
  final int? itemId;
  final bool? isTaxable;
  final String? item;
  final int? quantity;
  final int? rate;
  final int? taxId;
  final int? tax;
  final String? taxName;
  final dynamic cessId;
  final dynamic cess;
  final dynamic cessName;
  final int? discount;
  final int? discountAmount;
  final int? priceDifference;
  final int? originalPrice;
  final bool? isDiscountPercentage;
  final bool? isExclusiveTax;
  final List<dynamic>? scheme;
  final List<ItemUnit>? itemUnits;
  final double? totalAmount;
  final double? taxAmount;
  final int? subTotal;
  final dynamic itemNotes;
  final bool? status;
  final bool? delete;
  final DateTime? created;
  final int? createdBy;

  SalesInvoiceDetailItemDetail({
    this.id,
    this.pk,
    this.isCredited,
    this.invoiceId,
    this.warehouse,
    this.unitId,
    this.unit,
    this.hsnCode,
    this.skuCode,
    this.image,
    this.itemId,
    this.isTaxable,
    this.item,
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
    this.priceDifference,
    this.originalPrice,
    this.isDiscountPercentage,
    this.isExclusiveTax,
    this.scheme,
    this.itemUnits,
    this.totalAmount,
    this.taxAmount,
    this.subTotal,
    this.itemNotes,
    this.status,
    this.delete,
    this.created,
    this.createdBy,
  });

  factory SalesInvoiceDetailItemDetail.fromJson(Map<String, dynamic> json) =>
      SalesInvoiceDetailItemDetail(
        id: json["id"],
        pk: json["pk"],
        isCredited: json["is_credited"],
        invoiceId: json["invoice_id"],
        warehouse: json["warehouse"],
        unitId: json["unit_id"],
        unit: json["unit"],
        hsnCode: json["hsn_code"],
        skuCode: json["sku_code"],
        image: json["image"],
        itemId: json["item_id"],
        isTaxable: json["is_taxable"],
        item: json["item"],
        quantity: json["quantity"],
        rate: json["rate"],
        taxId: json["tax_id"],
        tax: json["tax"],
        taxName: json["tax_name"],
        cessId: json["cess_id"],
        cess: json["cess"],
        cessName: json["cess_name"],
        discount: json["discount"],
        discountAmount: json["discount_amount"],
        priceDifference: json["price_difference"],
        originalPrice: json["original_price"],
        isDiscountPercentage: json["is_discount_percentage"],
        isExclusiveTax: json["is_exclusive_tax"],
        scheme: json["scheme"] == null
            ? []
            : List<dynamic>.from(json["scheme"]!.map((x) => x)),
        itemUnits: json["item_units"] == null
            ? []
            : List<ItemUnit>.from(
                json["item_units"]!.map((x) => ItemUnit.fromJson(x))),
        totalAmount: json["total_amount"]?.toDouble(),
        taxAmount: json["tax_amount"]?.toDouble(),
        subTotal: json["sub_total"],
        itemNotes: json["item_notes"],
        status: json["status"],
        delete: json["delete"],
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        createdBy: json["created_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "pk": pk,
        "is_credited": isCredited,
        "invoice_id": invoiceId,
        "warehouse": warehouse,
        "unit_id": unitId,
        "unit": unit,
        "hsn_code": hsnCode,
        "sku_code": skuCode,
        "image": image,
        "item_id": itemId,
        "is_taxable": isTaxable,
        "item": item,
        "quantity": quantity,
        "rate": rate,
        "tax_id": taxId,
        "tax": tax,
        "tax_name": taxName,
        "cess_id": cessId,
        "cess": cess,
        "cess_name": cessName,
        "discount": discount,
        "discount_amount": discountAmount,
        "price_difference": priceDifference,
        "original_price": originalPrice,
        "is_discount_percentage": isDiscountPercentage,
        "is_exclusive_tax": isExclusiveTax,
        "scheme":
            scheme == null ? [] : List<dynamic>.from(scheme!.map((x) => x)),
        "item_units": itemUnits == null
            ? []
            : List<dynamic>.from(itemUnits!.map((x) => x.toJson())),
        "total_amount": totalAmount,
        "tax_amount": taxAmount,
        "sub_total": subTotal,
        "item_notes": itemNotes,
        "status": status,
        "delete": delete,
        "created": created?.toIso8601String(),
        "created_by": createdBy,
      };
}

class ItemUnit {
  final int? id;
  final int? unitId;
  final String? unit;
  final bool? isPrimary;
  final int? sellingPrice;
  final int? purchasePrice;
  final int? quantity;
  final int? baseQuantity;

  ItemUnit({
    this.id,
    this.unitId,
    this.unit,
    this.isPrimary,
    this.sellingPrice,
    this.purchasePrice,
    this.quantity,
    this.baseQuantity,
  });

  factory ItemUnit.fromJson(Map<String, dynamic> json) => ItemUnit(
        id: json["id"],
        unitId: json["unit_id"],
        unit: json["unit"],
        isPrimary: json["is_primary"],
        sellingPrice: json["selling_price"],
        purchasePrice: json["purchase_price"],
        quantity: json["quantity"],
        baseQuantity: json["base_quantity"],
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
