import '../../../../utils/json_builder.dart';

class ItemRequest with JsonBuilderMixin {
  final int? pk;
  final int? tax;
  final int? cess;
  final int? unit;
  final int? batch;
  final int? type;
  final int? uniqueId;
  final int? warehouse;
  final String? notes;
  final double? rate;
  final double? quantity;
  final double? discount;
  final double? originalPrice;
  final double? sellingPrice;
  final bool? isExclusiveTax;
  final bool? isDiscountPercentage;

  ItemRequest({
    this.pk,
    this.notes,
    this.unit,
    this.uniqueId,
    this.originalPrice,
    this.batch,
    this.cess,
    this.quantity,
    this.rate,
    this.tax,
    this.isExclusiveTax,
    this.sellingPrice,
    this.isDiscountPercentage,
    this.type,
    this.discount,
    this.warehouse,
  });

  Map<String, dynamic> toJson() => buildJson({
        "unit": unit,
        "pk": pk,
        "unique_id": uniqueId,
        "original_price": originalPrice,
        "batch": batch,
        "notes": notes,
        "cess": cess,
        "quantity": quantity,
        "rate": rate,
        "tax": tax,
        "type": type,
        "is_exclusive_tax": isExclusiveTax,
        "selling_price": sellingPrice,
        "is_discount_percentage": isDiscountPercentage,
        "discount": discount,
        "warehouse": warehouse,
      });
}
