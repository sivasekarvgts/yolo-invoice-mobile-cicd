import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../locator.dart';
import '../../../core/models/message.dart';
import '../../../api/customer_request.dart';

import '../models/customer/type_model.dart';
import '../models/customer/state_model.dart';
import '../models/customer/customer_list.dart';
import '../models/customer/country_model.dart';
import '../models/customer/customer_request_model.dart';
import '../models/customer/customer_detail_model.dart';
import '../models/customer/customer_update_request_model.dart';

class CustomerRepository {
  final CustomerRequest customerRequest;
  CustomerRepository({required this.customerRequest});

  Future<CustomerListModel> getCustomerList(
          {required int page, required String search}) =>
      apiBaseService.request<CustomerListModel>(
          customerRequest.getCustomerList(page: page, search: search),
          (data) => CustomerListModel.fromJson(data));
  Future<CustomerListModel> getVendorList(
          {required int page, required String search}) =>
      apiBaseService.request<CustomerListModel>(
          customerRequest.getVendorList(page: page, search: search),
          (data) => CustomerListModel.fromJson(data));

  Future<CustomerDetailModel> getCustomerInfo({required int id}) =>
      apiBaseService.request<CustomerDetailModel>(
          customerRequest.getCustomerInfo(id),
          (data) => CustomerDetailModel.fromJson(data));
  Future<CustomerDetailModel> getVendorInfo({required int id}) =>
      apiBaseService.request<CustomerDetailModel>(
          customerRequest.getVendorInfo(id),
          (data) => CustomerDetailModel.fromJson(data));

  Future<List<TypeModel>> getBusinessType() =>
      apiBaseService.requestList<TypeModel>(
          customerRequest.getBusinessType(),
          (data) => (data as List<dynamic>)
              .map((item) => TypeModel.fromJson(item as Map<String, dynamic>))
              .toList());

  Future<List<TypeModel>> getBusinessCategory(int type) =>
      apiBaseService.requestList<TypeModel>(
          customerRequest.getBusinessCategory(type: type),
          (data) => (data as List<dynamic>)
              .map((item) => TypeModel.fromJson(item as Map<String, dynamic>))
              .toList());

  Future<List<TypeModel>> getRegistrationType() =>
      apiBaseService.requestList<TypeModel>(
          customerRequest.getGstRegistrationType(),
          (data) => (data as List<dynamic>)
              .map((item) => TypeModel.fromJson(item as Map<String, dynamic>))
              .toList());

  Future<List<StateModel>> getStates() =>
      apiBaseService.requestList<StateModel>(
          customerRequest.getStates(),
          (data) => (data as List<dynamic>)
              .map((item) => StateModel.fromJson(item as Map<String, dynamic>))
              .toList());

  Future<List<CountryModel>> getCountries() =>
      apiBaseService.requestList<CountryModel>(
          customerRequest.getCountries(),
          (data) => (data as List<dynamic>)
              .map(
                  (item) => CountryModel.fromJson(item as Map<String, dynamic>))
              .toList());

  Future<Message> verifyGstNo(String gstNum) => apiBaseService.request<Message>(
      customerRequest.verifyGstNo(gstNum), (data) => Message.fromJson(data));

  Future<Message> createCustomer(
          {required CustomerRequestModel customerRequestModel}) =>
      apiBaseService.request<Message>(
          customerRequest.createCustomer(
              customerRequestModel: customerRequestModel),
          (data) => Message.fromJson(data));
  Future<Message> createVendor(
          {required CustomerRequestModel customerRequestModel}) =>
      apiBaseService.request<Message>(
          customerRequest.createVendor(
              customerRequestModel: customerRequestModel),
          (data) => Message.fromJson(data));

  Future<Message> updateCustomer(
          {required CustomerUpdateRequestModel customerUpdateRequestModel,
          required int id}) =>
      apiBaseService.request<Message>(
          customerRequest.updateCustomer(
              customerUpdateRequestModel: customerUpdateRequestModel, id: id),
          (data) => Message.fromJson(data));
  Future<Message> updateVendor(
          {required CustomerUpdateRequestModel customerUpdateRequestModel,
          required int id}) =>
      apiBaseService.request<Message>(
          customerRequest.updateVendor(
              customerUpdateRequestModel: customerUpdateRequestModel, id: id),
          (data) => Message.fromJson(data));

  Future<Message> deleteCustomer({required int id}) =>
      apiBaseService.request<Message>(customerRequest.deleteCustomer(id: id),
          (data) => Message.fromJson(data));
  Future<Message> deleteVendor({required int id}) =>
      apiBaseService.request<Message>(customerRequest.deleteVendor(id: id),
          (data) => Message.fromJson(data));

  Future<dynamic> updateCustomerAddress(
          {required CustomerRequestModel customerRequestModel,
          required int id}) =>
      apiBaseService.request<dynamic>(
          customerRequest.updateCustomerAddress(
              customerRequestModel: customerRequestModel, id: id),
          (data) => (data));
  Future<dynamic> updateVendorAddress(
          {required CustomerRequestModel customerRequestModel,
          required int id}) =>
      apiBaseService.request<dynamic>(
          customerRequest.updateVendorAddress(
              customerRequestModel: customerRequestModel, id: id),
          (data) => (data));

  Future<Message> addCustomerContact(
          {required CustomerRequestModel customerRequestModel,
          required int id}) =>
      apiBaseService.request<Message>(
          customerRequest.addCustomerContact(
              customerRequestModel: customerRequestModel, id: id),
          (data) => Message.fromJson(data));
  Future<Message> addVendorContact(
          {required CustomerRequestModel customerRequestModel,
          required int id}) =>
      apiBaseService.request<Message>(
          customerRequest.addVendorContact(
              customerRequestModel: customerRequestModel, id: id),
          (data) => Message.fromJson(data));

  Future<Message> updateCustomerContact(
          {required CustomerRequestModel customerRequestModel,
          required int contactId}) =>
      apiBaseService.request<Message>(
          customerRequest.updateCustomerContact(
              customerRequestModel: customerRequestModel, contactId: contactId),
          (data) => Message.fromJson(data));
  Future<Message> updateVendorContact(
          {required CustomerRequestModel customerRequestModel,
          required int contactId}) =>
      apiBaseService.request<Message>(
          customerRequest.updateVendorContact(
              customerRequestModel: customerRequestModel, contactId: contactId),
          (data) => Message.fromJson(data));

  Future<Message> deleteCustomerContact({required int contactId}) =>
      apiBaseService.request<Message>(
          customerRequest.deleteCustomerContact(contactId: contactId),
          (data) => Message.fromJson(data));
  Future<Message> deleteVendorContact({required int contactId}) =>
      apiBaseService.request<Message>(
          customerRequest.deleteVendorContact(contactId: contactId),
          (data) => Message.fromJson(data));
}

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  return CustomerRepository(customerRequest: CustomerRequest());
});
