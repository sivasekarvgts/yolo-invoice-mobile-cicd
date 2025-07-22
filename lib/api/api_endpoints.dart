sealed class ApiEndPoint {
  static const String page = 'page=';
  static const String pageSize = 'page_size=';
  static const String search = 'search=';
  static const String salesOrder = 'bills/sales-order/';

  //SALES
  static const String billInvoice = 'bills/invoice/';
  static const String salesInvoice = 'bills/sales-invoice/';
  static const String salesInvoiceV2 = 'bills/v2/sales-invoice/';
  static const String salesInvoiceUpdate = 'bills/sales-invoice-update/';
  static const String billInvoiceTransaction = 'bills/invoice-transaction/';

  // PURCHASE
  static const String purchaseInvoice = 'bills/v2/purchase-invoice/';
  static const String purchaseOrder = 'bills/purchase-order/';
  static const String purchaseOrderUpdate = 'bills/purchase-order-update/';
  static const String billPurchaseInvoice = 'bills/purchase-invoice/';
  static const String billPurchaseInvoiceUpdate =
      'bills/purchase-invoice-update/';

  // Payment
  static const String creditNoteCancel = 'bills/creditnote-cancel/';

  // Preview
  static const String invoiceDownload = 'bills/invoice-download/';

  // BILLS
  static const String billInvoiceDetail = 'bills/invoice-detail/';
  static const String billInvoiceTemplate = 'bills/bill-template/';
  static const String billTransactionStatement = 'bills/transaction-statement/';

  static const String clientBill = 'bills/client-bill/';
  static const String vendorBill = 'bills/vendor-bill/';

  static const String endDate = 'end_date=';
  static const String startDate = 'start_date=';
  static const String clientInfo = 'client-info/';
  static const String tdsSection = 'core/section/';
  static const String tcsSection = 'core/tcs-collection/';
  static const String paymentModeList = 'core/payment-mode/';

  static const String billsTcs = 'bills/tcs/';
  static const String billsTds = 'bills/tds/';

  static const String duePeriod = 'bills/due-period/';
  static const String billNo = 'bills/number-generator/';
  static const String priceList = 'bills/price-list-dropdown/';
  static const String salesPerson = 'bills/sales-person/';
  static const String billsConfiguration = 'bills/bills-configuration/';
  static const String schemeList = 'bills/scheme-applied/';
  static const String applyPriceList = 'bills/price-list-applied/';
  static const String billOrder = 'bills/order/';
  static const String billOrderTemplate = 'bills/order-template/';

  static const String billItemList = 'bills/item-list/';
  static const String billOrderDelete = 'bills/order-cancel/';
  static const String orderDetail = 'bills/order-detail/';
  static const String billOrderUpdate = 'bills/sales-order-update/';
  static const String clientPaymentList = 'bills/client-payment/';
  static const String vendorPaymentList = 'bills/vendor-payment/';
  static const String vendorPaymentDueInvoice = 'bills/vendor-bill-list/';
  static const String vendorPaymentCreate = 'bills/vendor-payment/';
  static const String vendorPaymentUpdate = 'bills/vendor-payment-update/';
  static const String paymentDueInvoice = 'bills/client-bill-list/';
  static const String paymentCreate = 'bills/client-payment/';
  static const String paymentCancel = 'bills/payment-cancel/';
  static const String paymentDetails = 'bills/payment-detail/';
  static const String paymentTemplate = 'bills/payment-template/';
  static const String paymentDelete = 'bills/payment-delete/';
  static const String paymentRetrieve = 'bills/payment-retrieve/';
  static const String paymentUpdate = 'bills/client-payment-update/';
  static const String warehouseItemValidate = 'bills/invoice-stocks/';
  static const String warehouseList = 'core/warehouse-list/';
  static const String transportMode = 'core/transportation-mode/';

  // Items
  static const String item = 'item/item/';
  static const String purchaseItemList = 'item/product-list/';
  static const String itemUnit = 'item/unit/';
  static const String taxPreference = 'item/tax-preference/';
  static const String itemGst = 'item/tax/';
  static const String itemCess = 'item/cess/';
  static const String itemExemptionReason = 'item/exemption-reason/';

  //accounts
  static const String saveAccounts = '/bills/chart-of-accounts/';
  static const String chartsOfAccounts = 'bills/chart-of-accounts-dropdown/';
  static const String itemCategoryList = 'item/category-list/';
  static const String hsn = 'core/hsn/';
}
