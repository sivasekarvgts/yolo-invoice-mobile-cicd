import 'dart:convert';

import 'package:equatable/equatable.dart';
import '../../../core/models/address_detail.dart';
import '../../../locator.dart';

OrganizationModel organizationModelFromJson(String str) =>
    OrganizationModel.fromJson(json.decode(str));

String organizationModelToJson(OrganizationModel data) =>
    json.encode(data.toJson());

class OrganizationModel extends Equatable {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? gender;
  final int? genderId;
  final String? salutation;
  final int? salutationId;
  final int? countryId;
  final String? countryName;
  final String? currencySymbol;
  final dynamic dateOfBirth;
  final List<Organization>? organization;

  OrganizationModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.gender,
    this.genderId,
    this.salutation,
    this.salutationId,
    this.countryId,
    this.countryName,
    this.currencySymbol,
    this.dateOfBirth,
    this.organization,
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) =>
      OrganizationModel(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        phone: json["phone"],
        gender: json["gender"],
        genderId: json["gender_id"],
        salutation: json["salutation"],
        salutationId: json["salutation_id"],
        countryId: json["country_id"],
        countryName: json["country_name"],
        currencySymbol: json["currency_symbol"],
        dateOfBirth: json["date_of_birth"],
        organization: json["organization"] == null
            ? []
            : List<Organization>.from(
                json["organization"]!.map((x) => Organization.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "gender": gender,
        "gender_id": genderId,
        "salutation": salutation,
        "salutation_id": salutationId,
        "country_id": countryId,
        "country_name": countryName,
        "currency_symbol": currencySymbol,
        "date_of_birth": dateOfBirth,
        "organization": organization == null
            ? []
            : List<dynamic>.from(organization!.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        phone,
        gender,
        genderId,
        salutation,
        salutationId,
        countryId,
        countryName,
        currencySymbol,
        dateOfBirth,
        organization,
      ];
}

Organization organizationFromJson(String str) =>
    Organization.fromJson(json.decode(str));

String organizationToJson(Organization data) => json.encode(data.toJson());

class Organization extends Equatable {
  final String? id;
  final String? name;
  final String? logo;
  final String? contactName;
  final String? email;
  final int? registrationType;
  final String? registrationTypeName;
  final String? gstNum;
  final String? phone;
  final dynamic website;
  final int? country;
  final int? timeZone;
  final dynamic compositionSchemePercentage;
  final int? businessType;
  final String? businessTypeName;
  final int? businessCategory;
  final String? businessCategoryName;
  final int? createdBy;
  final dynamic updatedBy;
  final DateTime? created;
  final bool? status;
  final bool? deleted;
  final RoleModel? roleModel;
  final List<AddressDetail>? addressDetail;

  Organization({
    this.id,
    this.addressDetail,
    this.name,
    this.logo,
    this.contactName,
    this.email,
    this.registrationType,
    this.registrationTypeName,
    this.gstNum,
    this.phone,
    this.website,
    this.country,
    this.timeZone,
    this.roleModel,
    this.compositionSchemePercentage,
    this.businessType,
    this.businessTypeName,
    this.businessCategory,
    this.businessCategoryName,
    this.createdBy,
    this.updatedBy,
    this.created,
    this.status,
    this.deleted,
  });

  factory Organization.fromJson(Map<String, dynamic> json) => Organization(
        id: json["id"],
        addressDetail: json["address_detail"] == null
            ? []
            : List<AddressDetail>.from(
                json["address_detail"]!.map((x) => AddressDetail.fromJson(x))),
        name: json["name"],
        logo: json["logo"] ?? businessIndividualImages.randomBusinessImage,
        contactName: json["contact_name"],
        email: json["email"],
        registrationType: json["registration_type"],
        registrationTypeName: json["registration_type_name"],
        gstNum: json["gst_num"],
        phone: json["phone"],
        website: json["website"],
        country: json["country"],
        timeZone: json["time_zone"],
        roleModel:
            json["role"] == null ? null : RoleModel.fromJson(json['role']),
        compositionSchemePercentage: json["composition_scheme_percentage"],
        businessType: json["business_type"],
        businessTypeName: json["business_type_name"],
        businessCategory: json["business_category"],
        businessCategoryName: json["business_category_name"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        status: json["status"],
        deleted: json["deleted"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "logo": logo,
        "contact_name": contactName,
        "email": email,
        "registration_type": registrationType,
        "registration_type_name": registrationTypeName,
        "gst_num": gstNum,
        "phone": phone,
        "website": website,
        "country": country,
        "role": roleModel?.toJson(),
        "time_zone": timeZone,
        "address_detail": addressDetail == null
            ? []
            : List<dynamic>.from(addressDetail!.map((x) => x.toJson())),
        "composition_scheme_percentage": compositionSchemePercentage,
        "business_type": businessType,
        "business_type_name": businessTypeName,
        "business_category": businessCategory,
        "business_category_name": businessCategoryName,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created": created?.toIso8601String(),
        "status": status,
        "deleted": deleted
      };

  @override
  List<Object?> get props => [
        id,
        name,
        logo,
        contactName,
        email,
        registrationType,
        registrationTypeName,
        gstNum,
        phone,
        website,
        country,
        timeZone,
        compositionSchemePercentage,
        businessType,
        businessTypeName,
        businessCategory,
        businessCategoryName,
        createdBy,
        updatedBy,
        created,
        status,
        deleted,
        roleModel,
        addressDetail,
      ];
}

class RoleModel {
  final String? roleName;
  final int? roleId;
  final int? roleCode;

  RoleModel({
    this.roleName,
    this.roleId,
    this.roleCode,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) => RoleModel(
        roleName: json["role__name"],
        roleId: json["role_id"],
        roleCode: json["role__code"],
      );

  Map<String, dynamic> toJson() => {
        "role__name": roleName,
        "role_id": roleId,
        "role__code": roleCode,
      };
}
