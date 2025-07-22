import 'package:yoloworks_invoice/core/enums/order_type.dart';

import '../../../item/model/item_tax_list_model.dart';

class SalesParamsRequestModel {
  final int? order;
  final bool? edit;
  final bool? covert;
  final int? clientId;
  final bool isVendor;
  final BillType? billType;

  SalesParamsRequestModel(
      {this.clientId,
      this.order,
      this.edit = false,
      this.covert = false,
      this.isVendor = false,
      required this.billType});
}

class AddItemRequestModel {
  final int? clientId;
  final int? warehouseId;
  final int discountType;
  final int? priceListId;
  final int selectedIndex;
  final bool isEdit;
  final bool isValidate;
  final bool isSalesInvoice;
  final bool isSalesOrder;
  final bool isPurchaseInvoice;
  final bool isExcludingTax;
  final bool isGstRegistered;
  final List<ItemTaxListModel> taxList;
  final List<ItemTaxListModel> cessList;
  final List<Map<String, dynamic>> selectedItemList;

  AddItemRequestModel({
    required this.clientId,
    required this.warehouseId,
    required this.discountType,
    required this.cessList,
    required this.taxList,
    required this.priceListId,
    required this.selectedItemList,
    this.selectedIndex = 0,
    this.isEdit = false,
    this.isValidate = false,
    this.isSalesInvoice = false,
    this.isSalesOrder = false,
    this.isExcludingTax = false,
    this.isGstRegistered = false,
    this.isPurchaseInvoice = false,
  });
}
