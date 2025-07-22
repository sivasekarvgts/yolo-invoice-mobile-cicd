import 'dart:convert';

CustomerRequestModel customerRequestModelFromJson(String str) =>
    CustomerRequestModel.fromJson(json.decode(str));

String customerRequestModelToJson(CustomerRequestModel data) =>
    json.encode(data.toJson());

class CustomerRequestModel {
  final String? name;
  final int? salutation;
  final String? businessType;
  final String? businessCategory;
  final String? openingBalanceType;
  final double? openingBalance;
  final String? country;
  final bool? isDebit;
  final String? phone;
  final String? email;
  final Address? shipping;
  final Address? billing;
  final bool? sameAsShipping;
  final int? registrationType;
  final String? gstNum;
  final int? clientType;
  final int? vendorType;

  CustomerRequestModel({
    this.name,
    this.salutation,
    this.businessType,
    this.businessCategory,
    this.openingBalanceType,
    this.openingBalance,
    this.country,
    this.isDebit,
    this.phone,
    this.email,
    this.shipping,
    this.billing,
    this.sameAsShipping,
    this.registrationType,
    this.gstNum,
    this.clientType,
    this.vendorType,
  });

  factory CustomerRequestModel.fromJson(Map<String, dynamic> json) =>
      CustomerRequestModel(
        name: json["name"],
        salutation: json["salutation"],
        businessType: json["business_type"],
        businessCategory: json["business_category"],
        openingBalanceType: json["opening_balance_type"],
        openingBalance: (json["opening_balance"] as num?)?.toDouble(),
        country: json["country"],
        isDebit: json["is_debit"],
        phone: json["phone"],
        email: json["email"],
        shipping: json["shipping"] == null
            ? null
            : Address.fromJson(json["shipping"]),
        billing:
            json["billing"] == null ? null : Address.fromJson(json["billing"]),
        sameAsShipping: json["same_as_shipping"],
        registrationType: json["registration_type"],
        gstNum: json["gst_num"],
        clientType: json["client_type"],
        vendorType: json["vendor_type"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (_isNotEmpty(name)) data["name"] = name;
    if (salutation != null) data["salutation"] = salutation;
    if (_isNotEmpty(businessType)) data["business_type"] = businessType;
    if (_isNotEmpty(businessCategory))
      data["business_category"] = businessCategory;
    if (_isNotEmpty(openingBalanceType))
      data["opening_balance_type"] = openingBalanceType;
    if (openingBalance != null) data["opening_balance"] = openingBalance;
    if (_isNotEmpty(country)) data["country"] = country;
    if (isDebit != null) data["is_debit"] = isDebit;
    if (_isNotEmpty(phone)) data["phone"] = phone;
    data["email"] = email;
    if (shipping != null) data["shipping"] = shipping!.toJson();
    if (billing != null) data["billing"] = billing!.toJson();
    if (sameAsShipping != null) data["same_as_shipping"] = sameAsShipping;
    if (registrationType != null) data["registration_type"] = registrationType;
    if (_isNotEmpty(gstNum)) data["gst_num"] = gstNum;
    if (clientType != null) data["client_type"] = clientType;
    if (vendorType != null) data["vendor_type"] = vendorType;

    return data;
  }

  // Helper method to check for null or empty string
  bool _isNotEmpty(String? value) => value != null && value.isNotEmpty;
}

class Address {
  final String? address1;
  final String? address2;
  final String? city;
  final String? state;
  final String? pincode;

  Address({
    this.address1,
    this.address2,
    this.city,
    this.state,
    this.pincode,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        address1: json["address1"],
        address2: json["address2"],
        city: json["city"],
        state: json["state"],
        pincode: json["pincode"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (_isNotEmpty(address1)) data["address1"] = address1;
    if (_isNotEmpty(address2)) data["address2"] = address2;
    if (_isNotEmpty(city)) data["city"] = city;
    if (_isNotEmpty(state)) data["state"] = state;
    if (_isNotEmpty(pincode)) data["pincode"] = pincode;

    return data;
  }

  // Helper method to check for null or empty string
  bool _isNotEmpty(String? value) => value != null && value.isNotEmpty;
}
