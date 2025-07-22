part of '../../client/new_client/new_client_controller.dart';

extension NewCustomerController on NewClientController {
  Future createCustomers() async {
    setLoading;
    _setCustomerRequest();
    try {
      var res = await ref
          .read(customerRepositoryProvider)
          .createCustomer(customerRequestModel: newCustomerData);
      navigationService.pop(returnValue: true);
      SnackbarService.toastMsg("Customer Created Successfully!", false);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    state = AsyncValue.data(null);
  }

  Future updateCustomers() async {
    setLoading;
    _setCustomerUpdateRequest();
    try {
      var res = await ref.read(customerRepositoryProvider).updateCustomer(
          customerUpdateRequestModel: customerUpdateData,
          id: addNewCustomerRouteArg?.contactId ?? 0);
      navigationService.pop(returnValue: true);
      SnackbarService.toastMsg("Updated Successfully!", false);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    setState;
  }

  Future updateCustomerAddress() async {
    setLoading;
    _setCustomerRequest();
    try {
      var res = await ref
          .read(customerRepositoryProvider)
          .updateCustomerAddress(
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

  Future updateCustomerContact() async {
    setLoading;
    _setCustomerRequest();
    try {
      if (addNewCustomerRouteArg?.isEdit == true) {
        var res = await ref
            .read(customerRepositoryProvider)
            .updateCustomerContact(
                customerRequestModel: newCustomerData,
                contactId: addNewCustomerRouteArg?.contactId ?? 0);
        navigationService.pop(returnValue: true);
        SnackbarService.toastMsg("Contact Updated Successfully!", false);
      } else {
        var res = await ref.read(customerRepositoryProvider).addCustomerContact(
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
