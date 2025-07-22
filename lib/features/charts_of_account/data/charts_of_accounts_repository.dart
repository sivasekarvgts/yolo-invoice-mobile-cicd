import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/charts_of_accounts_request.dart';
import '../../../locator.dart';

import '../models/charts_of_accounts_list_model.dart';

class ChartsOfAccountsRepository {
  final ChartsOfAccountsRequest chartsOfAccountsRequest;

  ChartsOfAccountsRepository({required this.chartsOfAccountsRequest});

  Future<List<ChartsOfAccountListModel>> getChartsOfAccountList() async {
    return apiBaseService.requestList<ChartsOfAccountListModel>(
        chartsOfAccountsRequest.getChartsOfAccountList(),
        (res) => (res as List)
            .map((e) => ChartsOfAccountListModel.fromJson(e))
            .toList());
  }

  Future<Map?> saveChartsOfAccount(Map data) async {
    return apiBaseService.request<Map>(
        chartsOfAccountsRequest.saveChartsOfAccount(data), (res) => res);
  }
}

final chartsOfAccountsRepositoryProvider =
    Provider<ChartsOfAccountsRepository>((ref) {
  return ChartsOfAccountsRepository(
      chartsOfAccountsRequest: ChartsOfAccountsRequest());
});
