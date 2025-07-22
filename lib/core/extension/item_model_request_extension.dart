import '../../features/sales/models/invoice/item_request_model.dart';

import '../../features/sales/models/item_model/sales_line_item.dart';

extension SalesLineItemToItemRequest on List<SalesLineItem> {
  List<ItemRequest> toItemRequestList({required int warehouseId}) {
    return map((item) {
      return ItemRequest(
        pk: item.pk,
        unit: item.itemUnitId,
        originalPrice: item.originalPrice,
        batch: null, // Assuming no mapping from SalesLineItem
        cess: item.cessId,
        quantity: item.qty,
        rate: item.price,
        tax: item.taxId,
        notes: item.notes,
        type: 1,
        isExclusiveTax: item.isSalesTaxExclusive,
        sellingPrice: item.price,
        isDiscountPercentage: item.lineItemDiscountType == 1,
        discount: item.discountValue,
        warehouse: warehouseId,
      );
    }).toList();
  }
}
