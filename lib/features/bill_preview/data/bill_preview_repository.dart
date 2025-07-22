import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/bills_request.dart';
import '../../../locator.dart';
import '../models/bill_preview_model.dart';
import '../models/bill_transaction_credit_list_model.dart';
import '../models/bill_transaction_statement_list_model.dart';

class BillPreviewRepository {
  final BillsRequest billsRequest;

  BillPreviewRepository({required this.billsRequest});

  Future<BillPreviewModel> getBillPreview(int order) async {
    return apiBaseService.request<BillPreviewModel>(
        billsRequest.getBillPreview(order: order),
        (res) => BillPreviewModel.fromJson(res));
  }

  Future<BillPreviewModel> getBillTemplate(int order) async {
    return apiBaseService.request<BillPreviewModel>(
        billsRequest.getBillTemplate(order: order),
        (res) => BillPreviewModel.fromJson(res));
  }

  Future<BillPreviewModel> getInvoiceBillPreview(int id) async {
    return apiBaseService.request<BillPreviewModel>(
        billsRequest.getInvoiceBillPreview(id: id),
        (res) => BillPreviewModel.fromJson(res));
  }

  Future<BillPreviewModel> getInvoiceBillTemplate(int id) async {
    return apiBaseService.request<BillPreviewModel>(
        billsRequest.getInvoiceBillTemplate(id: id),
        (res) => BillPreviewModel.fromJson(res));
  }

  Future<BillTransactionCreditListModel> getTransactions(int id) async {
    return apiBaseService.request<BillTransactionCreditListModel>(
        billsRequest.getTransactions(id: id),
        (res) => BillTransactionCreditListModel.fromJson(res));
  }

  Future<List<BillTransactionStatementListModel>> getTransactionStatement(
      int id) {
    return apiBaseService.requestList<BillTransactionStatementListModel>(
        billsRequest.getTransactionStatement(id: id),
        (res) => (res as List<dynamic>)
            .map((item) => BillTransactionStatementListModel.fromJson(
                item as Map<String, dynamic>))
            .toList());
  }

  Future<Map<String, dynamic>?> deleteOrder(int order) async {
    return apiBaseService.request<Map<String, dynamic>?>(
        billsRequest.deleteOrder(order: order), (res) {
      if (res == null) return null;
      return res as Map<String, dynamic>;
    });
  }

  Future<Map<String, dynamic>?> deletePayment(int id) async {
    return apiBaseService.request<Map<String, dynamic>?>(
        billsRequest.deletePayment(id: id), (res) {
      if (res == null) return null;
      return res as Map<String, dynamic>;
    });
  }

  Future<Map<String, dynamic>?> deleteCreditNote(int id) async {
    return apiBaseService.request<Map<String, dynamic>?>(
        billsRequest.deleteCreditNote(id: id), (res) {
      if (res == null) return null;
      return res as Map<String, dynamic>;
    });
  }
}

final billPreviewRepositoryProvider = Provider<BillPreviewRepository>((ref) {
  return BillPreviewRepository(billsRequest: BillsRequest());
});
