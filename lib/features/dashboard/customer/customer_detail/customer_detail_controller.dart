part of '../../client/client_detail/client_detail_controller.dart';

extension CustomerDetailController on ClientDetailController {
  fetchCustomerDetail({bool refresh = false}) async {
    if (refresh) {
      customerData = null;
      setLoading;
    }
    try {
      customerData = await ref
          .read(customerRepositoryProvider)
          .getCustomerInfo(id: clientId);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    setState;
  }
}
