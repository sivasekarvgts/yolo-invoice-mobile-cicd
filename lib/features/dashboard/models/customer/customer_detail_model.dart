import 'package:equatable/equatable.dart';

import '../../../../core/models/address_detail.dart';
import '../../../../locator.dart';
import 'country_model.dart';

class CustomerDetailModel extends Equatable {
  CustomerDetailModel({
    this.id,
    this.branchId,
    this.branch,
    this.clientTypeId,
    this.clientType,
    this.salutationId,
    this.salutation,
    this.logo,
    this.clientName,
    this.organizationName,
    this.displayName,
    this.phone,
    this.email,
    this.currency,
    this.country,
    this.timeZone,
    this.registrationType,
    this.registrationTypeName,
    this.gstNum,
    this.website,
    this.dueTerm,
    this.businessType,
    this.businessTypeName,
    this.businessCategory,
    this.businessCategoryName,
    this.remarks,
    this.customerDetailModelOpeningBalance,
    this.openingBalance,
    this.creditLimit,
    this.panNumber,
    this.tanNumber,
    this.balance,
    this.sameAsShippingAddress,
    this.addressDetail,
    this.contactDetail,
    this.documentDetail,
    this.bankDetail,
    this.unpaidBill,
    this.clientImage,
    this.createdBy,
    this.updatedBy,
    this.created,
    this.status,
    this.deleted,
  });

  final int? id;
  final int? branchId;
  final String? branch;
  final int? clientTypeId;
  final String? clientType;
  final int? salutationId;
  final double? salutation;
  final String? logo;
  final String? clientName;
  final String? organizationName;
  final String? displayName;
  final String? phone;
  final String? email;
  final String? currency;
  final CountryModel? country;
  final TimeZone? timeZone;
  final int? registrationType;
  final String? registrationTypeName;
  final String? gstNum;
  final dynamic website;
  final DueTerm? dueTerm;
  final int? businessType;
  final String? businessTypeName;
  final int? businessCategory;
  final String? businessCategoryName;
  final dynamic remarks;
  final double? customerDetailModelOpeningBalance;
  final double? openingBalance;
  final double? creditLimit;
  final String? panNumber;
  final dynamic tanNumber;
  final double? balance;
  final bool? sameAsShippingAddress;
  final List<AddressDetail>? addressDetail;
  final List<ContactDetail>? contactDetail;
  final List<DocumentDetail>? documentDetail;
  final List<BankDetail>? bankDetail;
  final double? unpaidBill;
  final List<dynamic>? clientImage;
  final int? createdBy;
  final int? updatedBy;
  final DateTime? created;
  final bool? status;
  final bool? deleted;

  factory CustomerDetailModel.fromJson(Map<String, dynamic> json) {
    return CustomerDetailModel(
      id: json["id"],
      branchId: json["branch_id"],
      branch: json["branch"],
      clientTypeId: json["client_type_id"] == null
          ? json["vendor_type_id"]
          : json["client_type_id"],
      clientType: json["client_type"],
      salutationId: json["salutation_id"],
      salutation: (json["salutation"] as num?)?.toDouble(),
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
      country: json["country"] == null
          ? null
          : CountryModel.fromJson(json["country"]),
      timeZone: json["time_zone"] == null
          ? null
          : TimeZone.fromJson(json["time_zone"]),
      registrationType: json["registration_type"],
      registrationTypeName: json["registration_type_name"],
      gstNum: json["gst_num"],
      website: json["website"],
      dueTerm:
          json["due_term"] == null ? null : DueTerm.fromJson(json["due_term"]),
      businessType: json["business_type"],
      businessTypeName: json["business_type_name"],
      businessCategory: json["business_category"],
      businessCategoryName: json["business_category_name"],
      remarks: json["remarks"],
      customerDetailModelOpeningBalance:
          (json["opening_balance"] as num?)?.toDouble(),
      openingBalance: (json["_opening_balance"] as num?)?.toDouble(),
      creditLimit: (json["credit_limit"] as num?)?.toDouble(),
      panNumber: json["pan_number"],
      tanNumber: json["tan_number"],
      balance: json["balance"],
      sameAsShippingAddress: json["same_as_shipping_address"],
      addressDetail: (json["address_detail"] == null ||
              json["address_detail"].toString().isEmpty)
          ? []
          : json["address_detail"] is List // Check if it's a list
              ? List<AddressDetail>.from(
                  json["address_detail"]!.map((x) => AddressDetail.fromJson(x)))
              : [
                  AddressDetail.fromJson(json["address_detail"])
                ], // Handle the case when it's a map

      contactDetail: json["contact_detail"] == null
          ? []
          : List<ContactDetail>.from(
              json["contact_detail"]!.map((x) => ContactDetail.fromJson(x))),
      documentDetail: json["document_detail"] == null
          ? []
          : List<DocumentDetail>.from(
              json["document_detail"]!.map((x) => DocumentDetail.fromJson(x))),
      bankDetail: json["bank_detail"] == null
          ? []
          : List<BankDetail>.from(
              json["bank_detail"]!.map((x) => BankDetail.fromJson(x))),
      unpaidBill: (json["unpaid_bill"] as num?)?.toDouble(),
      clientImage: json["client_image"] == null
          ? []
          : List<dynamic>.from(json["client_image"]!.map((x) => x)),
      createdBy: json["created_by"],
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
        "country": country?.toJson(),
        "time_zone": timeZone?.toJson(),
        "registration_type": registrationType,
        "registration_type_name": registrationTypeName,
        "gst_num": gstNum,
        "website": website,
        "due_term": dueTerm?.toJson(),
        "business_type": businessType,
        "business_type_name": businessTypeName,
        "business_category": businessCategory,
        "business_category_name": businessCategoryName,
        "remarks": remarks,
        "opening_balance": customerDetailModelOpeningBalance,
        "_opening_balance": openingBalance,
        "credit_limit": creditLimit,
        "pan_number": panNumber,
        "tan_number": tanNumber,
        "balance": balance,
        "same_as_shipping_address": sameAsShippingAddress,
        "address_detail": addressDetail?.map((x) => x.toJson()).toList(),
        "contact_detail": contactDetail?.map((x) => x.toJson()).toList(),
        "document_detail": documentDetail?.map((x) => x.toJson()).toList(),
        "bank_detail": bankDetail?.map((x) => x.toJson()).toList(),
        "unpaid_bill": unpaidBill,
        "client_image": clientImage?.map((x) => x).toList(),
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created": created?.toIso8601String(),
        "status": status,
        "deleted": deleted,
      };

  @override
  String toString() {
    return "$id, $branchId, $branch, $clientTypeId, $clientType, $salutationId, $salutation, $logo, $clientName, $organizationName, $displayName, $phone, $email, $currency, $country, $timeZone, $registrationType, $registrationTypeName, $gstNum, $website, $dueTerm, $businessType, $businessTypeName, $businessCategory, $businessCategoryName, $remarks, $customerDetailModelOpeningBalance, $openingBalance, $creditLimit, $panNumber, $tanNumber, $balance, $sameAsShippingAddress, $addressDetail, $contactDetail, $documentDetail, $bankDetail, $unpaidBill, $clientImage, $createdBy, $updatedBy, $created, $status, $deleted, ";
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
        customerDetailModelOpeningBalance,
        openingBalance,
        creditLimit,
        panNumber,
        tanNumber,
        balance,
        sameAsShippingAddress,
        addressDetail,
        contactDetail,
        documentDetail,
        bankDetail,
        unpaidBill,
        clientImage,
        createdBy,
        updatedBy,
        created,
        status,
        deleted,
      ];
}

class BankDetail extends Equatable {
  BankDetail({
    this.id,
    this.clientId,
    this.clientName,
    this.bankName,
    this.accountNo,
    this.ifscCode,
    this.accountName,
    this.accountTypeId,
    this.accountType,
    this.swiftCode,
    this.createdBy,
    this.updatedBy,
    this.created,
    this.deleted,
    this.status,
  });

  final int? id;
  final int? clientId;
  final String? clientName;
  final String? bankName;
  final String? accountNo;
  final String? ifscCode;
  final String? accountName;
  final String? accountTypeId;
  final String? accountType;
  final dynamic swiftCode;
  final int? createdBy;
  final dynamic updatedBy;
  final DateTime? created;
  final bool? deleted;
  final bool? status;

  factory BankDetail.fromJson(Map<String, dynamic> json) {
    return BankDetail(
      id: json["id"],
      clientId: json["client_id"],
      clientName: json["client_name"],
      bankName: json["bank_name"],
      accountNo: json["account_no"],
      ifscCode: json["ifsc_code"],
      accountName: json["account_name"],
      accountTypeId: json["account_type_id"],
      accountType: json["account_type"],
      swiftCode: json["swift_code"],
      createdBy: json["created_by"],
      updatedBy: json["updated_by"],
      created: DateTime.tryParse(json["created"] ?? ""),
      deleted: json["deleted"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "client_id": clientId,
        "client_name": clientName,
        "bank_name": bankName,
        "account_no": accountNo,
        "ifsc_code": ifscCode,
        "account_name": accountName,
        "account_type_id": accountTypeId,
        "account_type": accountType,
        "swift_code": swiftCode,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created": created?.toIso8601String(),
        "deleted": deleted,
        "status": status,
      };

  @override
  String toString() {
    return "$id, $clientId, $clientName, $bankName, $accountNo, $ifscCode, $accountName, $accountTypeId, $accountType, $swiftCode, $createdBy, $updatedBy, $created, $deleted, $status, ";
  }

  @override
  List<Object?> get props => [
        id,
        clientId,
        clientName,
        bankName,
        accountNo,
        ifscCode,
        accountName,
        accountTypeId,
        accountType,
        swiftCode,
        createdBy,
        updatedBy,
        created,
        deleted,
        status,
      ];
}

class ContactDetail extends Equatable {
  ContactDetail({
    this.id,
    this.client,
    this.clientName,
    this.logo,
    this.name,
    this.phone,
    this.uuid,
    this.email,
    this.inviteStatus,
    this.contactDetailDefault,
    this.createdBy,
    this.updatedBy,
    this.created,
    this.deleted,
    this.status,
  });

  final int? id;
  final int? client;
  final String? clientName;
  final dynamic logo;
  final String? name;
  final String? phone;
  final dynamic uuid;
  final String? email;
  final dynamic inviteStatus;
  final bool? contactDetailDefault;
  final int? createdBy;
  final dynamic updatedBy;
  final DateTime? created;
  final bool? deleted;
  final bool? status;

  factory ContactDetail.fromJson(Map<String, dynamic> json) {
    return ContactDetail(
      id: json["id"],
      client: json["client"],
      clientName: json["client_name"],
      logo: json["logo"] ?? businessIndividualImages.randomIndividualImage,
      name: json["name"],
      phone: json["phone"],
      uuid: json["uuid"],
      email: json["email"],
      inviteStatus: json["invite_status"],
      contactDetailDefault: json["default"],
      createdBy: json["created_by"],
      updatedBy: json["updated_by"],
      created: DateTime.tryParse(json["created"] ?? ""),
      deleted: json["deleted"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "client": client,
        "client_name": clientName,
        "logo": logo,
        "name": name,
        "phone": phone,
        "uuid": uuid,
        "email": email,
        "invite_status": inviteStatus,
        "default": contactDetailDefault,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created": created?.toIso8601String(),
        "deleted": deleted,
        "status": status,
      };

  @override
  String toString() {
    return "$id, $client, $clientName, $logo, $name, $phone, $uuid, $email, $inviteStatus, $contactDetailDefault, $createdBy, $updatedBy, $created, $deleted, $status, ";
  }

  @override
  List<Object?> get props => [
        id,
        client,
        clientName,
        logo,
        name,
        phone,
        uuid,
        email,
        inviteStatus,
        contactDetailDefault,
        createdBy,
        updatedBy,
        created,
        deleted,
        status,
      ];
}

class DocumentDetail extends Equatable {
  DocumentDetail({
    this.id,
    this.client,
    this.clientName,
    this.panNumber,
    this.tanNumber,
    this.documentType,
    this.documentTypeName,
    this.file,
    this.fileSize,
    this.fileName,
    this.createdBy,
    this.updatedBy,
    this.created,
    this.updated,
    this.status,
    this.delete,
  });

  final int? id;
  final int? client;
  final String? clientName;
  final String? panNumber;
  final dynamic tanNumber;
  final int? documentType;
  final String? documentTypeName;
  final String? file;
  final String? fileSize;
  final String? fileName;
  final int? createdBy;
  final dynamic updatedBy;
  final String? created;
  final String? updated;
  final bool? status;
  final bool? delete;

  factory DocumentDetail.fromJson(Map<String, dynamic> json) {
    return DocumentDetail(
      id: json["id"],
      client: json["client"],
      clientName: json["client_name"],
      panNumber: json["pan_number"],
      tanNumber: json["tan_number"],
      documentType: json["document_type"],
      documentTypeName: json["document_type_name"],
      file: json["file"],
      fileSize: json["file_size"],
      fileName: json["file_name"],
      createdBy: json["created_by"],
      updatedBy: json["updated_by"],
      created: json["created"],
      updated: json["updated"],
      status: json["status"],
      delete: json["delete"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "client": client,
        "client_name": clientName,
        "pan_number": panNumber,
        "tan_number": tanNumber,
        "document_type": documentType,
        "document_type_name": documentTypeName,
        "file": file,
        "file_size": fileSize,
        "file_name": fileName,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created": created,
        "updated": updated,
        "status": status,
        "delete": delete,
      };

  @override
  String toString() {
    return "$id, $client, $clientName, $panNumber, $tanNumber, $documentType, $documentTypeName, $file, $fileSize, $fileName, $createdBy, $updatedBy, $created, $updated, $status, $delete, ";
  }

  @override
  List<Object?> get props => [
        id,
        client,
        clientName,
        panNumber,
        tanNumber,
        documentType,
        documentTypeName,
        file,
        fileSize,
        fileName,
        createdBy,
        updatedBy,
        created,
        updated,
        status,
        delete,
      ];
}

class DueTerm extends Equatable {
  DueTerm({
    this.id,
    this.name,
    this.days,
    this.description,
    this.code,
  });

  final int? id;
  final String? name;
  final dynamic days;
  final String? description;
  final int? code;

  factory DueTerm.fromJson(Map<String, dynamic> json) {
    return DueTerm(
      id: json["id"],
      name: json["name"],
      days: json["days"],
      description: json["description"],
      code: json["code"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "days": days,
        "description": description,
        "code": code,
      };

  @override
  String toString() {
    return "$id, $name, $days, $description, $code, ";
  }

  @override
  List<Object?> get props => [
        id,
        name,
        days,
        description,
        code,
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
  final double? gmtOffset;
  final String? gmtOffsetName;
  final String? abbreviation;
  final String? tzName;

  factory TimeZone.fromJson(Map<String, dynamic> json) {
    return TimeZone(
      id: json["id"],
      zoneName: json["zone_name"],
      gmtOffset: (json["gmt_offset"] as num?)?.toDouble(),
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
