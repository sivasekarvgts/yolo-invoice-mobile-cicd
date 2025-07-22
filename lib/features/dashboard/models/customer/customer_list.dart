import 'package:equatable/equatable.dart';

import '../../../../app/constants/app_constants.dart';
import '../../../../core/models/address_detail.dart';
import '../../../../locator.dart';

class CustomerListModel extends Equatable {
  CustomerListModel({
    required this.count,
    required this.numPages,
    required this.pageSize,
    required this.currentPage,
    required this.pageRange,
    required this.perPage,
    required this.customerList,
  });

  final int? count;
  final int? numPages;
  final int? pageSize;
  final int? currentPage;
  final List<int> pageRange;
  final int? perPage;
  final List<CustomerList> customerList;

  factory CustomerListModel.fromJson(Map<String, dynamic> json) {
    return CustomerListModel(
      count: json["count"],
      numPages: json["num_pages"],
      pageSize: json["page_size"],
      currentPage: json["current_page"],
      pageRange: json["page_range"] == null
          ? []
          : List<int>.from(json["page_range"]!.map((x) => x)),
      perPage: json["per_page"],
      customerList: json["data"] == null
          ? []
          : List<CustomerList>.from(
              json["data"]!.map((x) => CustomerList.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "count": count,
        "num_pages": numPages,
        "page_size": pageSize,
        "current_page": currentPage,
        "page_range": pageRange.map((x) => x).toList(),
        "per_page": perPage,
        "data": customerList.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$count, $numPages, $pageSize, $currentPage, $pageRange, $perPage, $customerList, ";
  }

  @override
  List<Object?> get props => [
        count,
        numPages,
        pageSize,
        currentPage,
        pageRange,
        perPage,
        customerList,
      ];
}

class CustomerList extends Equatable {
  CustomerList({
    required this.id,
    required this.branchId,
    required this.branch,
    required this.clientTypeId,
    required this.clientType,
    required this.salutationId,
    required this.salutation,
    required this.logo,
    required this.clientName,
    required this.organizationName,
    required this.displayName,
    required this.phone,
    required this.email,
    required this.currency,
    required this.country,
    required this.timeZone,
    required this.registrationType,
    required this.registrationTypeName,
    required this.gstNum,
    required this.website,
    required this.dueTerm,
    required this.businessType,
    required this.businessTypeName,
    required this.businessCategory,
    required this.businessCategoryName,
    required this.remarks,
    required this.openingBalance,
    required this.creditLimit,
    required this.balance,
    required this.sameAsShippingAddress,
    required this.addressDetail,
    required this.createdBy,
    required this.updatedBy,
    required this.created,
    required this.status,
    required this.deleted,
  });

  final int? id;
  final int? branchId;
  final String? branch;
  final int? clientTypeId;
  final String? clientType;
  final double? salutationId;
  final String? salutation;
  final dynamic logo;
  final String? clientName;
  final dynamic organizationName;
  final String? displayName;
  final dynamic phone;
  final dynamic email;
  final String? currency;
  final double? country;
  final double? timeZone;
  final double? registrationType;
  final String? registrationTypeName;
  final dynamic gstNum;
  final dynamic website;
  final dynamic dueTerm;
  final double? businessType;
  final String? businessTypeName;
  final double? businessCategory;
  final String? businessCategoryName;
  final dynamic remarks;
  final double? openingBalance;
  final double? creditLimit;
  final double? balance;
  final bool? sameAsShippingAddress;
  final List<AddressDetail>? addressDetail;
  final double? createdBy;
  final dynamic updatedBy;
  final DateTime? created;
  final bool? status;
  final bool? deleted;

  factory CustomerList.fromJson(Map<String, dynamic> json) {
    return CustomerList(
      id: json["id"],
      branchId: json["branch_id"],
      branch: json["branch"],
      clientTypeId: json["client_type_id"],
      clientType: json["client_type"],
      salutationId: (json["salutation_id"] as num?)?.toDouble(),
      salutation: json["salutation"],
      logo: json["logo"] ??
          (json["client_type_id"] == 2
              ? businessIndividualImages.randomIndividualImage
              : businessIndividualImages.randomBusinessImage),
      clientName: json["client_name"],
      organizationName: json["organization_name"],
      displayName: json["display_name"],
      phone: json["phone"],
      email: json["email"],
      currency: json["currency"],
      country: (json["country"] as num?)?.toDouble(),
      timeZone: (json["time_zone"] as num?)?.toDouble(),
      registrationType: (json["registration_type"] as num?)?.toDouble(),
      registrationTypeName: json["registration_type_name"],
      gstNum: json["gst_num"],
      website: json["website"],
      dueTerm: json["due_term"],
      businessType: (json["business_type"] as num?)?.toDouble(),
      businessTypeName: json["business_type_name"],
      businessCategory: (json["business_category"] as num?)?.toDouble(),
      businessCategoryName: json["business_category_name"],
      remarks: json["remarks"],
      openingBalance: (json["opening_balance"] as num?)?.toDouble(),
      creditLimit: (json["credit_limit"] as num?)?.toDouble(),
      balance: (json["balance"] as num?)?.toDouble(),
      sameAsShippingAddress: json["same_as_shipping_address"],
      addressDetail: (json["address_detail"] == null ||
              json["address_detail"].toString().isEmpty)
          ? []
          : json["address_detail"] is List // Check if it's a list
              ? List<AddressDetail>.from(
                  json["address_detail"]!.map((x) => AddressDetail.fromJson(x)))
              : [AddressDetail.fromJson(json["address_detail"])],
      createdBy: (json["created_by"] as num?)?.toDouble(),
      updatedBy: json["updated_by"],
      created: DateTime.tryParse(json["created"] ?? ""),
      status: json["status"],
      deleted: json["deleted"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "branch_id": branchId,
        "branch": branch,
        "client_type_id": clientTypeId,
        "client_type": clientType,
        "salutation_id": salutationId,
        "salutation": salutation,
        "logo": logo,
        "client_name": clientName,
        "organization_name": organizationName,
        "display_name": displayName,
        "phone": phone,
        "email": email,
        "currency": currency,
        "country": country,
        "time_zone": timeZone,
        "registration_type": registrationType,
        "registration_type_name": registrationTypeName,
        "gst_num": gstNum,
        "website": website,
        "due_term": dueTerm,
        "business_type": businessType,
        "business_type_name": businessTypeName,
        "business_category": businessCategory,
        "business_category_name": businessCategoryName,
        "remarks": remarks,
        "opening_balance": openingBalance,
        "credit_limit": creditLimit,
        "balance": balance,
        "same_as_shipping_address": sameAsShippingAddress,
        "address_detail": addressDetail?.map((x) => x.toJson()).toList(),
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created": created?.toIso8601String(),
        "status": status,
        "deleted": deleted,
      };

  @override
  String toString() {
    return "$id, $branchId, $branch, $clientTypeId, $clientType, $salutationId, $salutation, $logo, $clientName, $organizationName, $displayName, $phone, $email, $currency, $country, $timeZone, $registrationType, $registrationTypeName, $gstNum, $website, $dueTerm, $businessType, $businessTypeName, $businessCategory, $businessCategoryName, $remarks, $openingBalance, $creditLimit, $balance, $sameAsShippingAddress, $addressDetail, $createdBy, $updatedBy, $created, $status, $deleted, ";
  }

  @override
  List<Object?> get props => [
        id,
        branchId,
        branch,
        clientTypeId,
        clientType,
        salutationId,
        salutation,
        logo,
        clientName,
        organizationName,
        displayName,
        phone,
        email,
        currency,
        country,
        timeZone,
        registrationType,
        registrationTypeName,
        gstNum,
        website,
        dueTerm,
        businessType,
        businessTypeName,
        businessCategory,
        businessCategoryName,
        remarks,
        openingBalance,
        creditLimit,
        balance,
        sameAsShippingAddress,
        addressDetail,
        createdBy,
        updatedBy,
        created,
        status,
        deleted,
      ];
}
