import 'package:yoloworks_invoice/locator.dart';

import '../core/enums/request_method.dart';
import '../core/models/request_setting.dart';
import '../features/dashboard/models/customer/customer_request_model.dart';
import '../features/dashboard/models/customer/customer_update_request_model.dart';
import 'api_endpoints.dart';

class CustomerRequest {
  RequestSettings getCustomerList({required int page, required String search}) {
    return RequestSettings(
        "client/client-list/?page=$page&page_size=12&search=$search",
        RequestMethod.GET,
        params: null,
        authenticated: true);
  }

  RequestSettings getVendorList({required int page, required String search}) {
    return RequestSettings(
        "vendor/vendor-list/?page=$page&page_size=12&search=$search",
        RequestMethod.GET,
        params: null,
        authenticated: true);
  }

  RequestSettings getCustomerInfo(int id) {
    return RequestSettings(
        "client/${ApiEndPoint.clientInfo}$id/", RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getVendorInfo(int id) {
    return RequestSettings("vendor/vendor-info/$id/", RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getBusinessType() {
    return RequestSettings("core/business-type/", RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getBusinessCategory({int type = 1}) {
    return RequestSettings(
        "core/business-category/?type=$type&code=1", RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getGstRegistrationType() {
    return RequestSettings("core/registration-type/", RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getStates() {
   String? countryId = preferenceService.getUserInfo()?.country?.id.toString();
    return RequestSettings("core/state/$countryId/", RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getCountries() {
    return RequestSettings("core/country/", RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings verifyGstNo(String gstNum) {
    Map params = {};
    params["gst_num"] = gstNum;

    return RequestSettings("client/gst-verify/", RequestMethod.POST,
        params: params, authenticated: true);
  }

  RequestSettings createCustomer(
      {required CustomerRequestModel customerRequestModel}) {
    return RequestSettings("client/client/", RequestMethod.POST,
        params: customerRequestModel.toJson(), authenticated: true);
  }

  RequestSettings createVendor(
      {required CustomerRequestModel customerRequestModel}) {
    return RequestSettings("vendor/vendor/", RequestMethod.POST,
        params: customerRequestModel.toJson(), authenticated: true);
  }

  RequestSettings updateCustomer(
      {required CustomerUpdateRequestModel customerUpdateRequestModel,
      required int id}) {
    return RequestSettings("client/client/$id/", RequestMethod.PATCH,
        params: customerUpdateRequestModel.toJson(), authenticated: true);
  }

  RequestSettings updateVendor(
      {required CustomerUpdateRequestModel customerUpdateRequestModel,
      required int id}) {
    return RequestSettings("vendor/vendor/$id/", RequestMethod.PATCH,
        params: customerUpdateRequestModel.toJson(), authenticated: true);
  }

  RequestSettings deleteCustomer({required int id}) {
    return RequestSettings("client/client-info/$id/", RequestMethod.DELETE,
        params: null, authenticated: true);
  }

  RequestSettings deleteVendor({required int id}) {
    return RequestSettings("vendor/vendor-info/$id/", RequestMethod.DELETE,
        params: null, authenticated: true);
  }

  RequestSettings updateCustomerAddress(
      {required CustomerRequestModel customerRequestModel, required int id}) {
    return RequestSettings("client/client-address/$id/", RequestMethod.PUT,
        params: customerRequestModel.toJson(), authenticated: true);
  }

  RequestSettings updateVendorAddress(
      {required CustomerRequestModel customerRequestModel, required int id}) {
    return RequestSettings("vendor/vendor-address/$id/", RequestMethod.PUT,
        params: customerRequestModel.shipping?.toJson(), authenticated: true);
  }

  RequestSettings addCustomerContact(
      {required CustomerRequestModel customerRequestModel, required int id}) {
    return RequestSettings("client/client-contact/$id/", RequestMethod.POST,
        params: customerRequestModel.toJson(), authenticated: true);
  }

  RequestSettings addVendorContact(
      {required CustomerRequestModel customerRequestModel, required int id}) {
    return RequestSettings("vendor/vendor-contact/$id/", RequestMethod.POST,
        params: customerRequestModel.toJson(), authenticated: true);
  }

  RequestSettings updateCustomerContact(
      {required CustomerRequestModel customerRequestModel,
      required int contactId}) {
    return RequestSettings(
        "client/client-contact-info/$contactId/", RequestMethod.PUT,
        params: customerRequestModel.toJson(), authenticated: true);
  }

  RequestSettings updateVendorContact(
      {required CustomerRequestModel customerRequestModel,
      required int contactId}) {
    return RequestSettings(
        "vendor/vendor-contact-info/$contactId/", RequestMethod.PUT,
        params: customerRequestModel.toJson(), authenticated: true);
  }

  RequestSettings deleteCustomerContact({required int contactId}) {
    return RequestSettings(
        "client/client-contact-info/$contactId/", RequestMethod.DELETE,
        params: null, authenticated: true);
  }

  RequestSettings deleteVendorContact({required int contactId}) {
    return RequestSettings(
        "vendor/vendor-contact-info/$contactId/", RequestMethod.DELETE,
        params: null, authenticated: true);
  }
}
