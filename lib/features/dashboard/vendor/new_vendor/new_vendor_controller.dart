part of '../../client/new_client/new_client_controller.dart';

extension VendorListController on NewClientController {
  Future createVendor() async {
    setLoading;
    _setCustomerRequest();
    try {
      var res = await ref
          .read(customerRepositoryProvider)
          .createVendor(customerRequestModel: newCustomerData);
      navigationService.pop(returnValue: true);
      SnackbarService.toastMsg("Vendor Created Successfully!", false);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    setState;
  }

  Future updateVendor() async {
    setLoading;
    _setCustomerUpdateRequest();
    try {
      var res = await ref.read(customerRepositoryProvider).updateVendor(
          customerUpdateRequestModel: customerUpdateData,
          id: addNewCustomerRouteArg?.contactId ?? 0);
      navigationService.pop(returnValue: true);
      SnackbarService.toastMsg("Updated Successfully!", false);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    setState;
  }

  Future updateVendorAddress() async {
    setLoading;
    _setCustomerRequest();
    try {
      var res = await ref.read(customerRepositoryProvider).updateVendorAddress(
          customerRequestModel: newCustomerData,
          id: addNewCustomerRouteArg?.customerId ?? 0);
      navigationService.pop(returnValue: true);
      if (addNewCustomerRouteArg?.isEdit != true)
        SnackbarService.toastMsg("Address Created Successfully!", false);
      else
        SnackbarService.toastMsg("Address Updated Successfully!", false);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    setState;
  }

  Future updateVendorContact() async {
    setLoading;
    _setCustomerRequest();
    try {
      if (addNewCustomerRouteArg?.isEdit == true) {
        var res = await ref
            .read(customerRepositoryProvider)
            .updateVendorContact(
                customerRequestModel: newCustomerData,
                contactId: addNewCustomerRouteArg?.contactId ?? 0);
        navigationService.pop(returnValue: true);
        SnackbarService.toastMsg("Contact Updated Successfully!", false);
      } else {
        var res = await ref.read(customerRepositoryProvider).addVendorContact(
            customerRequestModel: newCustomerData,
            id: addNewCustomerRouteArg?.customerId ?? 0);
        navigationService.pop(returnValue: true);
        SnackbarService.toastMsg("Contact Created Successfully!", false);
      }
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    setState;
  }
}
