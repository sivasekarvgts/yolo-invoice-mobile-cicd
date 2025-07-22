part of 'package:yoloworks_invoice/services/sales_purchase_master_services/sales_purchase_master_services.dart';

extension SalesPurchaseRefreshEvent on SalesPurchaseMasterService {
  void fireRefreshEvent() {
    final List<String> primaryRefreshPages = [
      Routes.dashboard,
      Routes.customerDetail,
      Routes.vendorDetail,
      Routes.billPreview,
      Routes.salesOrderList,
      Routes.purchaseOrderList,
      Routes.salesInvoiceList,
      Routes.purchaseInvoiceList
    ];

    eventBusService.eventBus
        .fire(PageRefreshEvent(pageNames: primaryRefreshPages));
  }
}
