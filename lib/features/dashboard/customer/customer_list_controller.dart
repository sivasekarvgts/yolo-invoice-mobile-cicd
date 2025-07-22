part of '../client/client_list_controller.dart';

extension CustomerListController on ClientListController {
  fetchCustomer({bool refresh = false}) async {
    if (refresh) {
      clientList.clear();
      customerData = null;
      setLoading;
    }

    int currentPage = (customerData?.currentPage ?? 0);
    int numPages = customerData?.numPages ?? 1;
    if (currentPage < numPages) {
      try {
        customerData = await ref
            .read(customerRepositoryProvider)
            .getCustomerList(
                page: currentPage + 1, search: searchTextCtrl.text);
        clientList.addAll(customerData?.customerList ?? []);
      } catch (e, s) {
        state = AsyncValue.error(e, s);
      }
    } else {
      return IndicatorResult.none;
    }
    setState;
  }
}
