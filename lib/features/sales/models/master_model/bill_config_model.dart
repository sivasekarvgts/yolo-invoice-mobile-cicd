import 'dart:convert';

BillConfigurationModel billConfigurationModelFromJson(String str) =>
    BillConfigurationModel.fromJson(json.decode(str));

String billConfigurationModelToJson(BillConfigurationModel data) =>
    json.encode(data.toJson());

class BillConfigurationModel {
  final int? id;
  final int? discountType;
  final bool? isDiscountBeforeTax;
  final bool? hasNegativeStock;
  final bool? hasNegativeAmount;
  final bool? hasRoundingOff;
  final bool? isExclusiveTax;
  final bool? hasEstimates;
  final bool? hasSalesOrders;
  final bool? hasPurchaseOrders;
  final bool? hasRecurringInvoice;
  final bool? hasRecurringBills;
  final bool? hasCreditNote;
  final bool? hasDeliveryChallans;
  final bool? hasBatch;
  final bool? hasSerialNumber;
  final bool? hasBatchTracking;
  final bool? hasPhysicalStock;
  final String? salesTerms;
  final String? purchaseTerms;
  final String? receiptTerms;
  final String? paymentTerms;
  final int? createdBy;
  final bool? status;
  final bool? delete;

  BillConfigurationModel({
    this.id,
    this.discountType,
    this.isDiscountBeforeTax,
    this.hasNegativeStock,
    this.hasNegativeAmount,
    this.hasRoundingOff,
    this.isExclusiveTax,
    this.hasEstimates,
    this.hasSalesOrders,
    this.hasPurchaseOrders,
    this.hasRecurringInvoice,
    this.hasRecurringBills,
    this.hasCreditNote,
    this.hasDeliveryChallans,
    this.hasBatch,
    this.hasSerialNumber,
    this.hasBatchTracking,
    this.hasPhysicalStock,
    this.salesTerms,
    this.purchaseTerms,
    this.receiptTerms,
    this.paymentTerms,
    this.createdBy,
    this.status,
    this.delete,
  });

  factory BillConfigurationModel.fromJson(Map<String, dynamic> json) =>
      BillConfigurationModel(
        id: json["id"],
        discountType: json["discount_type"],
        isDiscountBeforeTax: json["is_discount_before_tax"],
        hasNegativeStock: json["has_negative_stock"],
        hasNegativeAmount: json["has_negative_amount"],
        hasRoundingOff: json["has_rounding_off"],
        isExclusiveTax: json["is_exclusive_tax"],
        hasEstimates: json["has_estimates"],
        hasSalesOrders: json["has_sales_orders"],
        hasPurchaseOrders: json["has_purchase_orders"],
        hasRecurringInvoice: json["has_recurring_invoice"],
        hasRecurringBills: json["has_recurring_bills"],
        hasCreditNote: json["has_credit_note"],
        hasDeliveryChallans: json["has_delivery_challans"],
        hasBatch: json["has_batch"],
        hasSerialNumber: json["has_serial_number"],
        hasBatchTracking: json["has_batch_tracking"],
        hasPhysicalStock: json["has_physical_stock"],
        salesTerms: json["sales_terms"],
        purchaseTerms: json["purchase_terms"],
        receiptTerms: json["receipt_terms"],
        paymentTerms: json["payment_terms"],
        createdBy: json["created_by"],
        status: json["status"],
        delete: json["delete"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "discount_type": discountType,
        "is_discount_before_tax": isDiscountBeforeTax,
        "has_negative_stock": hasNegativeStock,
        "has_negative_amount": hasNegativeAmount,
        "has_rounding_off": hasRoundingOff,
        "is_exclusive_tax": isExclusiveTax,
        "has_estimates": hasEstimates,
        "has_sales_orders": hasSalesOrders,
        "has_purchase_orders": hasPurchaseOrders,
        "has_recurring_invoice": hasRecurringInvoice,
        "has_recurring_bills": hasRecurringBills,
        "has_credit_note": hasCreditNote,
        "has_delivery_challans": hasDeliveryChallans,
        "has_batch": hasBatch,
        "has_serial_number": hasSerialNumber,
        "has_batch_tracking": hasBatchTracking,
        "has_physical_stock": hasPhysicalStock,
        "sales_terms": salesTerms,
        "purchase_terms": purchaseTerms,
        "receipt_terms": receiptTerms,
        "payment_terms": paymentTerms,
        "created_by": createdBy,
        "status": status,
        "delete": delete,
      };
}
