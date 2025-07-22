import 'dart:convert';

import 'package:yoloworks_invoice/core/extension/datetime_extension.dart';

import '../../../../core/models/address_detail.dart';
import '../../../../utils/json_builder.dart';
import 'item_request_model.dart';

String salesInvoiceRequestModelToJson(SalesInvoiceRequestModel data) =>
    json.encode(data.toJson());

class SalesInvoiceRequestModel with JsonBuilderMixin {
  final List<int>? warehouse;
  final DateTime? billDate;
  final bool? isDiscountBeforeTax;
  final int? placeOfSupply;
  final String? terms;
  final DateTime? dueDate;
  final DateTime? orderDate;
  final DateTime? deliveryDate;
  final DateTime? referenceDate;
  final DateTime? expectedDeliveryDate;
  final int? clientId;
  final int? vendorId;
  final int? dueTerm;
  final String? notes;
  final String? file;
  final bool? isDiscountPercentage;
  final double? discount;
  final double? adjustment;
  final double? totalAmount;
  final double? shippingCharge;
  final int? discountAccount;
  final Map<String, String>? customField;
  final List<ItemRequest>? items;
  final int? tds;
  final int? tcs;
  final int? billStatus;
  final int? priceListId;
  final int? salesPerson;
  final int? modeOfTransportation;
  final String? referenceNumber;
  final AddressDetail? shippingAddress;
  final AddressDetail? billingAddress;

  SalesInvoiceRequestModel({
    this.warehouse,
    this.vendorId,
    this.modeOfTransportation,
    this.billDate,
    this.orderDate,
    this.referenceDate,
    this.deliveryDate,
    this.expectedDeliveryDate,
    this.discountAccount,
    this.isDiscountBeforeTax,
    this.placeOfSupply,
    this.terms,
    this.dueDate,
    this.clientId,
    this.dueTerm,
    this.notes,
    this.file,
    this.isDiscountPercentage,
    this.discount,
    this.totalAmount,
    this.shippingCharge,
    this.adjustment,
    this.customField,
    this.salesPerson,
    this.priceListId,
    this.items,
    this.billStatus,
    this.tds,
    this.tcs,
    this.referenceNumber,
    this.shippingAddress,
    this.billingAddress,
  });

  Map<String, dynamic> toJson() => buildJson({
        "warehouse": warehouse == null
            ? []
            : List<dynamic>.from(warehouse!.map((x) => x)),
        "bill_date":
            billDate == null ? null : "${billDate.toFormattedYearMonthDate()}",
        "order_date": orderDate == null
            ? null
            : "${orderDate.toFormattedYearMonthDate()}",
        "reference_date": referenceDate == null
            ? null
            : "${referenceDate.toFormattedYearMonthDate()}",
        "delivery_date": deliveryDate == null
            ? null
            : "${deliveryDate.toFormattedYearMonthDate()}",
        "expected_delivery_date": expectedDeliveryDate == null
            ? null
            : "${expectedDeliveryDate.toFormattedYearMonthDate()}",
        "mode_of_transportation": modeOfTransportation,
        "is_discount_before_tax": isDiscountBeforeTax,
        "place_of_supply": placeOfSupply,
        "terms": terms,
        "discount_account": discountAccount,
        "due_date": "${dueDate!.toFormattedYearMonthDate()}",
        "client_id": clientId,
        "due_term": dueTerm,
        "notes": notes,
        "file": file,
        "vendor_id": vendorId,
        "is_discount_percentage": isDiscountPercentage,
        "discount": discount,
        "total_amount": totalAmount,
        "shipping_charge": shippingCharge,
        "adjustment": adjustment,
        "custom_field": customField,
        "price_list_id": priceListId,
        "sales_person": salesPerson,
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
        "bill_status": billStatus,
        "tds": tds,
        "tcs": tcs,
        "reference_number": referenceNumber,
        "shipping_address": shippingAddress?.toJson(),
        "billing_address": billingAddress?.toJson(),
      });
}
