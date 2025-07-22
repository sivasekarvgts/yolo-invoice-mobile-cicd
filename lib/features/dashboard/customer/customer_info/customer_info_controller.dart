part of '../../client/client_info/client_info_controller.dart';

extension CustomerInfoController on ClientInfoController {
  Future fetchClientTransactionStatement({bool refresh = false}) async {
    if (refresh) {
      transactionData = null;
      if (index == 0) setLoading;
    }

    try {
      transactionData = await ref
          .read(transactionRepositoryProvider)
          .getClientTransactionStatement(ClientVendorRequestModel(
            id: clientId,
            startDate:
                selectedDateRange?.start.toFormattedYearMonthDate() ?? '',
            endDate: selectedDateRange?.end.toFormattedYearMonthDate() ?? '',
          ));
      final bool isOpening = transactionData?.transactionDetail?.first.name
              ?.toLowerCase()
              .contains("opening") ??
          false;
      final bool hasBalance =
          (transactionData?.transactionDetail?.first.balance ?? 0) > 0;
      if (isOpening && !hasBalance)
        transactionData?.transactionDetail?.removeAt(0);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    setState;
  }

  Future fetchSalesInvoiceList({bool refresh = false}) async {
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
          .read(salesInvoiceRepositoryProvider)
          .getSalesInvoiceList(ClientVendorRequestModel(
            page: currentPage + 1,
            addClient: usersType == UsersType.customer,
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



  Future navigateToBillPreview(id) async {
    await navigationService.pushNamed(Routes.billPreview,
        arguments: BillPreviewArgs(invoiceId: id,isSalesInvoice: true));
    // await refreshCalls(refresh: true);
  }

  Future navigateToPayment(id) async {
    await navigationService.pushNamed(Routes.paymentDetail,
        arguments: {'id': id, 'is_purchase': usersType != UsersType.customer});
    // await refreshCalls(refresh: true);
  }
}
