
import 'dart:convert';

CustomerUpdateRequestModel customerRequestModelFromJson(String str) => CustomerUpdateRequestModel.fromJson(json.decode(str));

String customerRequestModelToJson(CustomerUpdateRequestModel data) => json.encode(data.toJson());

class CustomerUpdateRequestModel {
  final String? displayName;
  final String? clientName;
  final String? organizationName;
  final String? businessType;
  final String? businessCategory;
  final String? openingBalanceType;
  final double? openingBalance;
  final bool? isDebit;
  final String? phone;
  final String? email;
  final int? registrationType;
  final String? gstNum;
  final int? clientType;
  final int? vendorType;

  CustomerUpdateRequestModel({
    this.displayName,
    this.clientName,
    this.organizationName,
    this.businessType,
    this.businessCategory,
    this.openingBalanceType,
    this.openingBalance,
    this.isDebit,
    this.phone,
    this.email,
    this.registrationType,
    this.gstNum,
    this.clientType,
    this.vendorType,
  });

  factory CustomerUpdateRequestModel.fromJson(Map<String, dynamic> json) => CustomerUpdateRequestModel(
    displayName: json["display_name"],
    clientName: json["client_name"],
    organizationName: json["organization_name"],
    openingBalanceType: json["opening_balance_type"],
    openingBalance: (json["opening_balance"] as num?)?.toDouble(),
    isDebit: json["is_debit"],
    phone: json["phone"],
    email: json["email"],
    gstNum: json["gst_num"],
    registrationType: json["registration_type"],
    clientType: json["client_type"] ,
    vendorType: json["vendor_type"],

  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (_isNotEmpty(displayName)) data["display_name"] = displayName;
    if (_isNotEmpty(clientName)) data["client_name"] = clientName;
    if (_isNotEmpty(organizationName)) data["organization_name"] = organizationName;
    if (_isNotEmpty(businessType)) data["business_type"] = businessType;
    if (_isNotEmpty(businessCategory)) data["business_category"] = businessCategory;
    if (_isNotEmpty(openingBalanceType)) data["opening_balance_type"] = openingBalanceType;
    if (openingBalance != null) data["opening_balance"] = openingBalance;
    if (isDebit != null) data["is_debit"] = isDebit;
    if (_isNotEmpty(phone)) data["phone"] = phone;
    if (_isNotEmpty(email)) data["email"] = email;
    if (registrationType != null) data["registration_type"] = registrationType;
    if (_isNotEmpty(gstNum)) data["gst_num"] = gstNum;
    if (clientType != null) data["client_type"] = clientType;
    if (vendorType != null) data["vendor_type"] = vendorType;

    return data;
  }

  // Helper method to check for null or empty string
  bool _isNotEmpty(String? value) => value != null && value.isNotEmpty;
}

