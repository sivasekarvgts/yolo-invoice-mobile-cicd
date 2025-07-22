import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/transaction_request.dart';
import '../../../core/models/client_vendor_request_model.dart';
import '../../../locator.dart';
import '../models/transaction_statement_list_model.dart';

class TransactionRepository {
  final TransactionRequest transactionRequest;

  TransactionRepository({required this.transactionRequest});

  Future<TransactionStatementListModel> getClientTransactionStatement(
      ClientVendorRequestModel input) async {
    return apiBaseService.request<TransactionStatementListModel>(
        transactionRequest.getClientTransactionStatement(input),
        (res) => TransactionStatementListModel.fromJson(res));
  }

  Future<TransactionStatementListModel> getVendorTransactionStatement(
      ClientVendorRequestModel input) async {
    return apiBaseService.request<TransactionStatementListModel>(
        transactionRequest.getVendorTransactionStatement(input),
        (res) => TransactionStatementListModel.fromJson(res));
  }
}

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepository(transactionRequest: TransactionRequest());
});
