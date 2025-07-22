import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yoloworks_invoice/features/dashboard/models/sales_purchase_model.dart';

import '../../../api/dashboard_request.dart';
import '../../../locator.dart';
import '../models/receivable_payable_model.dart';

class DioDashboardRepository {
  final DashboardRequest dashboardRequest;

  DioDashboardRepository({required this.dashboardRequest});

  Future<SalesPurchaseModel> getSalesPurchase({required startDate,required endDate,required type,}) => apiBaseService.request<SalesPurchaseModel>(dashboardRequest.getSalesPurchase(startDate: startDate, endDate: endDate, type: type), (data) => SalesPurchaseModel.fromJson(data));

  Future<ReceivablePayableModel> getReceivablesPayable() => apiBaseService.request<ReceivablePayableModel>(dashboardRequest.getReceivablesPayable(), (data) => ReceivablePayableModel.fromJson(data));


}

final dashboardRepositoryProvider = Provider<DioDashboardRepository>((ref) {
  return DioDashboardRepository(dashboardRequest: DashboardRequest());
});
