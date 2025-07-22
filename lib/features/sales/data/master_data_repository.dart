import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/master_data_api_request.dart';
import '../../../locator.dart';
import '../models/master_model/bill_config_model.dart';
import '../models/master_model/due_period_list_model.dart';
import '../models/master_model/price_list_model.dart';
import '../models/master_model/sales_person_list_model.dart';
import '../models/master_model/tax_model.dart';
import '../models/master_model/tds_tcs_section_model.dart';
import '../models/master_model/transport_mode_model.dart';
import '../models/master_model/warehouse_list_model.dart';

class MasterDataRepository {
  final MasterDataApiRequest masterDataApiRequest;

  MasterDataRepository({required this.masterDataApiRequest});

  Future<BillConfigurationModel> getBillConfig() {
    return apiBaseService.request<BillConfigurationModel>(
        masterDataApiRequest.getBillConfig(),
        (res) => BillConfigurationModel.fromJson(res));
  }

  Future<Map<String, dynamic>?> getBillNoGenerator({required int type}) {
    return apiBaseService.request<Map<String, dynamic>?>(
        masterDataApiRequest.getBillNoGenerator(type: type), (res) {
      if (res == null) return null;
      return res as Map<String, dynamic>;
    });
  }

  Future<List<PriceListModel>> getPriceList({required int clientId}) {
    return apiBaseService.requestList<PriceListModel>(
        masterDataApiRequest.getPriceList(clientId: clientId),
        (res) => (res as List<dynamic>)
            .map(
                (item) => PriceListModel.fromJson(item as Map<String, dynamic>))
            .toList());
  }

  Future<List<DuePeriodListModel>> getDuePeriodList() {
    return apiBaseService.requestList<DuePeriodListModel>(
        masterDataApiRequest.getDuePeriodList(),
        (res) => (res as List<dynamic>)
            .map((item) =>
                DuePeriodListModel.fromJson(item as Map<String, dynamic>))
            .toList());
  }

  Future<List<TransportModeModel>> getTransportModeList() {
    return apiBaseService.requestList<TransportModeModel>(
        masterDataApiRequest.getTransportModeList(),
        (res) => (res as List<dynamic>)
            .map((item) =>
                TransportModeModel.fromJson(item as Map<String, dynamic>))
            .toList());
  }

  Future<List<SalesPersonListModel>> getSalesPersonList() {
    return apiBaseService.requestList<SalesPersonListModel>(
        masterDataApiRequest.getSalesPersonList(),
        (res) => (res as List<dynamic>)
            .map((item) =>
                SalesPersonListModel.fromJson(item as Map<String, dynamic>))
            .toList());
  }

  Future<List<TaxModel>> getTcsList() {
    return apiBaseService.requestList<TaxModel>(
        masterDataApiRequest.getTcsList(),
        (res) => (res as List<dynamic>)
            .map((item) => TaxModel.fromJson(item as Map<String, dynamic>))
            .toList());
  }

  Future<List<TaxModel>> getTdsList() {
    return apiBaseService.requestList<TaxModel>(
        masterDataApiRequest.getTdsList(),
        (res) => (res as List<dynamic>)
            .map((item) => TaxModel.fromJson(item as Map<String, dynamic>))
            .toList());
  }

  Future<List<TdsTcsSectionModel>> getTdsSectionList() {
    return apiBaseService.requestList<TdsTcsSectionModel>(
        masterDataApiRequest.getTdsSectionList(),
        (res) => (res as List<dynamic>)
            .map((item) =>
                TdsTcsSectionModel.fromJson(item as Map<String, dynamic>))
            .toList());
  }

  Future<List<TdsTcsSectionModel>> getTcsSectionList() {
    return apiBaseService.requestList<TdsTcsSectionModel>(
        masterDataApiRequest.getTcsSectionList(),
        (res) => (res as List<dynamic>)
            .map((item) =>
                TdsTcsSectionModel.fromJson(item as Map<String, dynamic>))
            .toList());
  }

  Future<TaxModel?> createTdsSection({Map<String, dynamic>? input}) {
    return apiBaseService.request<TaxModel?>(
        masterDataApiRequest.createTds(params: input), (res) {
      if (res == null) return null;
      return TaxModel.fromJson(res);
    });
  }

  Future<TaxModel?> createTcsSection({Map<String, dynamic>? input}) {
    return apiBaseService.request<TaxModel?>(
        masterDataApiRequest.createTcs(params: input), (res) {
      if (res == null) return null;
      return TaxModel.fromJson(res);
    });
  }

  Future<List<WarehouseListModel>>? getWarehouseList() =>
      apiBaseService.requestList<WarehouseListModel>(
          masterDataApiRequest.getWarehouseList(),
          (data) => (data as List<dynamic>)
              .map((item) =>
                  WarehouseListModel.fromJson(item as Map<String, dynamic>))
              .toList());
}

final masterDataRepositoryProvider = Provider<MasterDataRepository>((ref) {
  return MasterDataRepository(masterDataApiRequest: MasterDataApiRequest());
});
