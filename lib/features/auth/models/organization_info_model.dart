import 'package:equatable/equatable.dart';

import '../../../core/models/address_detail.dart';
import '../../../locator.dart';
import '../../dashboard/models/customer/country_model.dart';

class OrganizationInfoModel extends Equatable {
  OrganizationInfoModel({
    this.id,
    this.name,
    this.contactName,
    this.logo,
    this.email,
    this.registrationType,
    this.registrationTypeName,
    this.gstNum,
    this.phone,
    this.website,
    this.isStoreEnabled,
    this.country,
    this.timeZone,
    this.compositionSchemePercentage,
    this.businessType,
    this.businessTypeName,
    this.businessCategory,
    this.businessCategoryName,
    this.sameAsShipping,
    this.addressDetail,
    this.fiscalYear,
    this.panNumber,
    this.tanNumber,
    this.createdBy,
    this.updatedBy,
    this.created,
    this.status,
    this.deleted,
  });

  final String? id;
  final String? name;
  final String? contactName;
  final String? logo;
  final String? email;
  final int? registrationType;
  final String? registrationTypeName;
  final String? gstNum;
  final String? phone;
  final dynamic website;
  final bool? isStoreEnabled;
  final CountryModel? country;
  final TimeZone? timeZone;
  final dynamic compositionSchemePercentage;
  final int? businessType;
  final String? businessTypeName;
  final int? businessCategory;
  final String? businessCategoryName;
  final bool? sameAsShipping;
  final List<AddressDetail>? addressDetail;
  final String? fiscalYear;
  final dynamic panNumber;
  final dynamic tanNumber;
  final int? createdBy;
  final int? updatedBy;
  final DateTime? created;
  final bool? status;
  final bool? deleted;

  factory OrganizationInfoModel.fromJson(Map<String, dynamic> json) {
    return OrganizationInfoModel(
      id: json["id"],
      name: json["name"],
      contactName: json["contact_name"],
      logo: json["logo"] ?? businessIndividualImages.randomBusinessImage,
      email: json["email"],
      registrationType: json["registration_type"],
      registrationTypeName: json["registration_type_name"],
      gstNum: json["gst_num"],
      phone: json["phone"],
      website: json["website"],
      isStoreEnabled: json["is_store_enabled"],
      country: json["country"] == null
          ? null
          : CountryModel.fromJson(json["country"]),
      timeZone: json["time_zone"] == null
          ? null
          : TimeZone.fromJson(json["time_zone"]),
      compositionSchemePercentage: json["composition_scheme_percentage"],
      businessType: json["business_type"],
      businessTypeName: json["business_type_name"],
      businessCategory: json["business_category"],
      businessCategoryName: json["business_category_name"],
      sameAsShipping: json["same_as_shipping"],
      addressDetail: json["address_detail"] == null
          ? []
          : List<AddressDetail>.from(json["address_detail"]!
              .where((e) => e != null)
              .map((x) => AddressDetail.fromJson(x))),
      fiscalYear: json["fiscal_year"],
      panNumber: json["pan_number"],
      tanNumber: json["tan_number"],
      createdBy: json["created_by"],
      updatedBy: json["updated_by"],
      created: DateTime.tryParse(json["created"] ?? ""),
      status: json["status"],
      deleted: json["deleted"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "contact_name": contactName,
        "logo": logo,
        "email": email,
        "registration_type": registrationType,
        "registration_type_name": registrationTypeName,
        "gst_num": gstNum,
        "phone": phone,
        "website": website,
        "is_store_enabled": isStoreEnabled,
        "country": country?.toJson(),
        "time_zone": timeZone?.toJson(),
        "composition_scheme_percentage": compositionSchemePercentage,
        "business_type": businessType,
        "business_type_name": businessTypeName,
        "business_category": businessCategory,
        "business_category_name": businessCategoryName,
        "same_as_shipping": sameAsShipping,
        "address_detail": addressDetail?.map((x) => x.toJson()).toList(),
        "fiscal_year": fiscalYear,
        "pan_number": panNumber,
        "tan_number": tanNumber,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created": created?.toIso8601String(),
        "status": status,
        "deleted": deleted,
      };

  @override
  String toString() {
    return "$id, $name, $contactName, $logo, $email, $registrationType, $registrationTypeName, $gstNum, $phone, $website, $isStoreEnabled, $country, $timeZone, $compositionSchemePercentage, $businessType, $businessTypeName, $businessCategory, $businessCategoryName, $sameAsShipping, $addressDetail, $fiscalYear, $panNumber, $tanNumber, $createdBy, $updatedBy, $created, $status, $deleted, ";
  }

  @override
  List<Object?> get props => [
        id,
        name,
        contactName,
        logo,
        email,
        registrationType,
        registrationTypeName,
        gstNum,
        phone,
        website,
        isStoreEnabled,
        country,
        timeZone,
        compositionSchemePercentage,
        businessType,
        businessTypeName,
        businessCategory,
        businessCategoryName,
        sameAsShipping,
        addressDetail,
        fiscalYear,
        panNumber,
        tanNumber,
        createdBy,
        updatedBy,
        created,
        status,
        deleted,
      ];
}

class TimeZone extends Equatable {
  TimeZone({
    this.id,
    this.zoneName,
    this.gmtOffset,
    this.gmtOffsetName,
    this.abbreviation,
    this.tzName,
  });

  final int? id;
  final String? zoneName;
  final int? gmtOffset;
  final String? gmtOffsetName;
  final String? abbreviation;
  final String? tzName;

  factory TimeZone.fromJson(Map<String, dynamic> json) {
    return TimeZone(
      id: json["id"],
      zoneName: json["zone_name"],
      gmtOffset: json["gmt_offset"],
      gmtOffsetName: json["gmt_offset_name"],
      abbreviation: json["abbreviation"],
      tzName: json["tz_name"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "zone_name": zoneName,
        "gmt_offset": gmtOffset,
        "gmt_offset_name": gmtOffsetName,
        "abbreviation": abbreviation,
        "tz_name": tzName,
      };

  @override
  String toString() {
    return "$id, $zoneName, $gmtOffset, $gmtOffsetName, $abbreviation, $tzName, ";
  }

  @override
  List<Object?> get props => [
        id,
        zoneName,
        gmtOffset,
        gmtOffsetName,
        abbreviation,
        tzName,
      ];
}
