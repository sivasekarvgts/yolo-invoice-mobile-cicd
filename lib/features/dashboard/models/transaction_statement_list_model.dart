import 'dart:convert';

import 'package:yoloworks_invoice/app/constants/images.dart';
import 'package:yoloworks_invoice/core/enums/icon_type.dart';
import 'package:yoloworks_invoice/core/models/address_detail.dart';
import 'package:yoloworks_invoice/features/bill_preview/views/widgets/sales_payment_list_tab.dart';

TransactionStatementListModel clientTransactionListModelFromJson(String str) =>
    TransactionStatementListModel.fromJson(json.decode(str));

String clientTransactionListModelToJson(TransactionStatementListModel data) =>
    json.encode(data.toJson());

class TransactionStatementListModel {
  final int? id;
  final int? branchId;
  final String? branch;
  final int? salutationId;
  final int? salutation;
  final String? logo;
  final String? name;
  final String? organizationName;
  final String? displayName;
  final double? closingBalance;
  final double? chequePendingAmount;
  final double? balance;
  final double? amountReceived;
  final double? advance;
  final List<AddressDetail>? addressDetail;
  final List<TransactionDetail>? transactionDetail;

  TransactionStatementListModel({
    this.id,
    this.branchId,
    this.branch,
    this.salutationId,
    this.salutation,
    this.logo,
    this.name,
    this.organizationName,
    this.displayName,
    this.closingBalance,
    this.chequePendingAmount,
    this.balance,
    this.amountReceived,
    this.advance,
    this.addressDetail,
    this.transactionDetail,
  });

  factory TransactionStatementListModel.fromJson(Map<String, dynamic> json) =>
      TransactionStatementListModel(
        id: json["id"],
        branchId: json["branch_id"],
        branch: json["branch"],
        salutationId: json["salutation_id"],
        salutation: json["salutation"],
        logo: json["logo"],
        name: json["vendor_name"] ?? json["client_name"],
        organizationName: json["organization_name"],
        displayName: json["display_name"],
        closingBalance: json["closing_balance"]?.toDouble(),
        chequePendingAmount: json["cheque_pending_amount"]?.toDouble(),
        balance: json["balance"]?.toDouble(),
        amountReceived: json["amount_received"]?.toDouble(),
        advance: json["advance"]?.toDouble(),
        addressDetail: json["address_detail"] == null
            ? []
            : List<AddressDetail>.from(
                json["address_detail"]!.map((x) => AddressDetail.fromJson(x))),
        transactionDetail: json["transaction_detail"] == null
            ? []
            : List<TransactionDetail>.from(json["transaction_detail"]!
                .map((x) => TransactionDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "branch_id": branchId,
        "branch": branch,
        "salutation_id": salutationId,
        "salutation": salutation,
        "logo": logo,
        "vendor_name": name,
        "organization_name": organizationName,
        "display_name": displayName,
        "closing_balance": closingBalance,
        "balance": balance,
        "amount_received": amountReceived,
        "advance": advance,
        "address_detail": addressDetail == null
            ? []
            : List<dynamic>.from(addressDetail!.map((x) => x.toJson())),
        "transaction_detail": transactionDetail == null
            ? []
            : List<dynamic>.from(transactionDetail!.map((x) => x.toJson())),
      };
}

// class AddressDetail {
//   final int? id;
//   final int? vendor;
//   final String? vendorName;
//   final String? address1;
//   final String? address2;
//   final int? state;
//   final String? stateName;
//   final String? city;
//   final int? country;
//   final String? countryName;
//   final String? pincode;
//   final dynamic landmark;
//   final int? addressType;
//   final int? latitude;
//   final int? longitude;
//   final int? createdBy;
//   final dynamic updatedBy;
//   final DateTime? created;
//   final bool? deleted;
//   final bool? status;
//
//   AddressDetail({
//     this.id,
//     this.vendor,
//     this.vendorName,
//     this.address1,
//     this.address2,
//     this.state,
//     this.stateName,
//     this.city,
//     this.country,
//     this.countryName,
//     this.pincode,
//     this.landmark,
//     this.addressType,
//     this.latitude,
//     this.longitude,
//     this.createdBy,
//     this.updatedBy,
//     this.created,
//     this.deleted,
//     this.status,
//   });
//
//   factory AddressDetail.fromJson(Map<String, dynamic> json) => AddressDetail(
//         id: json["id"],
//         vendor: json["vendor"],
//         vendorName: json["vendor_name"],
//         address1: json["address1"],
//         address2: json["address2"],
//         state: json["state"],
//         stateName: json["state_name"],
//         city: json["city"],
//         country: json["country"],
//         countryName: json["country_name"],
//         pincode: json["pincode"],
//         landmark: json["landmark"],
//         addressType: json["address_type"],
//         latitude: json["latitude"],
//         longitude: json["longitude"],
//         createdBy: json["created_by"],
//         updatedBy: json["updated_by"],
//         created:
//             json["created"] == null ? null : DateTime.parse(json["created"]),
//         deleted: json["deleted"],
//         status: json["status"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "vendor": vendor,
//         "vendor_name": vendorName,
//         "address1": address1,
//         "address2": address2,
//         "state": state,
//         "state_name": stateName,
//         "city": city,
//         "country": country,
//         "country_name": countryName,
//         "pincode": pincode,
//         "landmark": landmark,
//         "address_type": addressType,
//         "latitude": latitude,
//         "longitude": longitude,
//         "created_by": createdBy,
//         "updated_by": updatedBy,
//         "created": created?.toIso8601String(),
//         "deleted": deleted,
//         "status": status,
//       };
// }

class TransactionDetail {
  // SOMETIMES ID IS EMPTY STRING
  final dynamic id;
  final String? name;
  final String? issuedOn;
  final TransactionNo? transactionNo;
  final double? debit;
  final double? credit;
  final List<Description>? description;
  final double? balance;

  TransactionDetail({
    this.id,
    this.name,
    this.issuedOn,
    this.transactionNo,
    this.debit,
    this.credit,
    this.description,
    this.balance,
  });

  String get icon {
    if (name?.toLowerCase().contains("opening") == true) return Svgs.bank;
    if (name?.toLowerCase().contains("invoice") == true) return Svgs.invoice;
    return Svgs.receipt;
  }

  AmountType get amountType {
    if (name?.toLowerCase().contains("invoice") == true)
      return AmountType.debit;
    return AmountType.credit;
  }

  IconType get iconType {
    if (name?.toLowerCase().contains("opening") == true) return IconType.payOut;
    if (name?.toLowerCase().contains("payment") == true) return IconType.payIn;
    if (name?.toLowerCase().contains("credit") == true)
      return IconType.customer;
    return IconType.invoice;
  }

  double? get amount {
    return ((debit ?? 0) > 0) ? debit : credit;
  }

  factory TransactionDetail.fromJson(Map<String, dynamic> json) =>
      TransactionDetail(
        id: json["id"],
        name: json["name"]!,
        issuedOn: json["issued_on"],
        transactionNo: json["transaction_no"] == null
            ? null
            : TransactionNo.fromJson(json["transaction_no"]),
        debit: double.tryParse("${json["debit"] ?? 0}"),
        credit: double.tryParse("${json["credit"] ?? 0}"),
        description: json["description"] == null
            ? []
            : List<Description>.from(
                json["description"]!.map((x) => Description.fromJson(x))),
        balance: json["balance"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "issued_on": issuedOn,
        "transaction_no": transactionNo?.toJson(),
        "debit": debit,
        "credit": credit,
        "description": description == null
            ? []
            : List<dynamic>.from(description!.map((x) => x.toJson())),
        "balance": balance,
      };
}

class Description {
  final String? invoiceNo;
  final double? detail;

  Description({
    this.invoiceNo,
    this.detail,
  });

  factory Description.fromJson(Map<String, dynamic> json) => Description(
        invoiceNo: json["invoice_no"],
        detail: json["detail"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "invoice_no": invoiceNo,
        "detail": detail,
      };
}

class TransactionNo {
  final String? number;
  final int? id;

  TransactionNo({
    this.number,
    this.id,
  });

  factory TransactionNo.fromJson(Map<String, dynamic> json) => TransactionNo(
        number: json["number"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "id": id,
      };
}
