part of '../../client/client_detail/client_detail_controller.dart';

extension VendorDetailController on ClientDetailController {
  fetchVendorDetail({bool refresh = false}) async {
    if (refresh) {
      customerData = null;
      setLoading;
    }
    try {
      customerData = await ref
          .read(customerRepositoryProvider)
          .getVendorInfo(id: clientId);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    setState;
  }
}
