import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yoloworks_invoice/features/sales/models/item_model/warehouse_item_validation_model.dart';

import '../../../api/sales_invoice_request.dart';
import '../../../core/models/client_vendor_request_model.dart';

import '../models/invoice/invoice_list_model.dart';
import '../models/invoice/sales_invoice_details_model.dart';
import '../models/invoice/sales_invoice_request_model.dart';

import '../../../locator.dart';

class SalesInvoiceRepository {
  final SalesInvoiceRequest salesInvoiceRequest;

  SalesInvoiceRepository({required this.salesInvoiceRequest});

  Future<InvoiceListModel> getSalesInvoiceList(
      ClientVendorRequestModel input) async {
    return apiBaseService.request<InvoiceListModel>(
        salesInvoiceRequest.getSalesInvoiceList(input),
        (res) => InvoiceListModel.fromJson(res));
  }

  Future<List<WarehouseItemValidationModel>> warehouseItemValidate(
      List<int> items,
      List<int> itemUnits,
      List<double> quantities,
      int warehouse) async {
    return apiBaseService.requestList<WarehouseItemValidationModel>(
        salesInvoiceRequest.warehouseItemValidate(
            items, itemUnits, quantities, warehouse),
        (res) => (res as List<dynamic>)
            .map((item) => WarehouseItemValidationModel.fromJson(
                item as Map<String, dynamic>))
            .toList());
  }

  Future<dynamic> postSalesInvoice(SalesInvoiceRequestModel req) async {
    return apiBaseService.request<dynamic>(
        salesInvoiceRequest.postSalesInvoice(req), (res) => (res));
  }

  Future<dynamic> updateSalesInvoice(
      SalesInvoiceRequestModel req, int id) async {
    return apiBaseService.request<dynamic>(
        salesInvoiceRequest.updateSalesInvoice(req, id), (res) => (res));
  }

  Future<SalesInvoiceDetailModel> getSalesInvoiceDetail(
      {required int id}) async {
    return apiBaseService.request<SalesInvoiceDetailModel>(
        salesInvoiceRequest.getSalesInvoiceDetail(id),
        (res) => SalesInvoiceDetailModel.fromJson(res));
  }
}

final salesInvoiceRepositoryProvider = Provider<SalesInvoiceRepository>((ref) {
  return SalesInvoiceRepository(salesInvoiceRequest: SalesInvoiceRequest());
});
