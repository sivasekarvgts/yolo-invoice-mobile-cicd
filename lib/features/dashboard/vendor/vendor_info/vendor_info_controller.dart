part of '../../client/client_info/client_info_controller.dart';

extension VendorInfoController on ClientInfoController {
  Future fetchVendorTransactionStatement({bool refresh = false}) async {
    if (refresh) {
      transactionData = null;
      if (index == 0) setLoading;
    }
    try {
      transactionData = await ref
          .read(transactionRepositoryProvider)
          .getVendorTransactionStatement(ClientVendorRequestModel(
            id: clientId,
            startDate:
                selectedDateRange?.start.toFormattedYearMonthDate() ?? '',
            endDate: selectedDateRange?.end.toFormattedYearMonthDate() ?? '',
          ));
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    setState;
  }

  Future fetchPurchaseInvoiceList({bool refresh = false}) async {
    if (refresh) {
      invoiceList.clear();
      invoiceData = null;
      if (index == 1) setLoading;
    }

    int currentPage = (invoiceData?.currentPage ?? 0);
    int numPages = invoiceData?.numPages ?? 1;
    if (currentPage >= numPages) {
      setState;
      return IndicatorResult.none;
    }

    try {
      invoiceData = await ref
          .read(purchaseInvoiceRepositoryProvider)
          .getPurchaseInvoiceList(ClientVendorRequestModel(
            page: currentPage + 1,
            addVendor: true,
            id: clientId,
            startDate:
                selectedDateRange?.start.toFormattedYearMonthDate() ?? '',
            endDate: selectedDateRange?.end.toFormattedYearMonthDate() ?? '',
          ));
      invoiceList.addAll(invoiceData?.data ?? []);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    setState;
  }
}
