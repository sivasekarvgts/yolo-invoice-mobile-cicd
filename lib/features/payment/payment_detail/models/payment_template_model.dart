import 'dart:convert';

PaymentTemplateModel paymentTemplateModelFromJson(String str) =>
    PaymentTemplateModel.fromJson(json.decode(str));

String paymentTemplateModelToJson(PaymentTemplateModel data) =>
    json.encode(data.toJson());

class PaymentTemplateModel {
  final int? id;
  final int? branchId;
  final String? branch;
  final OrganizationAddress? organizationAddress;
  final String? orgGst;
  final String? logo;
  final dynamic website;
  final String? orgPhone;
  final String? orgPanNumber;
  final String? orgTanNumber;
  final String? paymentNumber;
  final String? referenceNumber;
  final dynamic gst;
  final dynamic panNumber;
  final dynamic tanNumber;
  final dynamic clientId;
  final String? client;
  final String? clientPhone;
  final dynamic vendorId;
  final String? vendor;
  final String? vendorPhone;
  final List<OrganizationAddress>? addressDetail;
  final DateTime? date;
  final int? paymentMode;
  final String? paymentModeName;
  final String? receivedAmount;
  final String? receivedAmountInwords;
  final String? transactionId;
  final String? chequeNumber;
  final DateTime? chequeDate;
  final double? excessAmount;
  final double? utilizedAmount;
  final String? notes;
  final List<InvoiceDetail>? invoiceDetails;
  final int? createdBy;
  final bool? status;

  PaymentTemplateModel({
    this.id,
    this.branchId,
    this.branch,
    this.organizationAddress,
    this.orgGst,
    this.logo,
    this.website,
    this.orgPhone,
    this.orgPanNumber,
    this.orgTanNumber,
    this.paymentNumber,
    this.referenceNumber,
    this.gst,
    this.panNumber,
    this.tanNumber,
    this.clientId,
    this.client,
    this.clientPhone,
    this.vendorId,
    this.vendor,
    this.vendorPhone,
    this.addressDetail,
    this.date,
    this.paymentMode,
    this.paymentModeName,
    this.receivedAmount,
    this.receivedAmountInwords,
    this.transactionId,
    this.chequeNumber,
    this.chequeDate,
    this.excessAmount,
    this.utilizedAmount,
    this.notes,
    this.invoiceDetails,
    this.createdBy,
    this.status,
  });

  factory PaymentTemplateModel.fromJson(Map<String, dynamic> json) =>
      PaymentTemplateModel(
        id: json["id"],
        branchId: json["branch_id"],
        branch: json["branch"],
        organizationAddress: json["organization_address"] == null
            ? null
            : OrganizationAddress.fromJson(json["organization_address"]),
        orgGst: json["org_gst"],
        logo: json["logo"],
        website: json["website"],
        orgPhone: json["org_phone"],
        orgPanNumber: json["org_pan_number"],
        orgTanNumber: json["org_tan_number"],
        paymentNumber: json["payment_number"],
        referenceNumber: json["reference_number"],
        gst: json["gst"],
        panNumber: json["pan_number"],
        tanNumber: json["tan_number"],
        clientId: json["client_id"],
        client: json["client"],
        clientPhone: json["client_phone"],
        vendorId: json["vendor_id"],
        vendor: json["vendor"],
        vendorPhone: json["vendor_phone"],
        addressDetail: json["address_detail"] == null
            ? []
            : List<OrganizationAddress>.from(json["address_detail"]!
                .map((x) => OrganizationAddress.fromJson(x))),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        paymentMode: json["payment_mode"],
        paymentModeName: json["payment_mode_name"],
        receivedAmount: json["received_amount"],
        receivedAmountInwords: json["received_amount_inwords"],
        transactionId: json["transaction_id"],
        chequeNumber: json["cheque_number"],
        chequeDate: json["cheque_date"] == null
            ? null
            : DateTime.parse(json["cheque_date"]),
        excessAmount: json["excess_amount"]?.toDouble(),
        utilizedAmount: json["utilized_amount"]?.toDouble(),
        notes: json["notes"],
        invoiceDetails: json["invoice_details"] == null
            ? []
            : List<InvoiceDetail>.from(
                json["invoice_details"]!.map((x) => InvoiceDetail.fromJson(x))),
        createdBy: json["created_by"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "branch_id": branchId,
        "branch": branch,
        "organization_address": organizationAddress?.toJson(),
        "org_gst": orgGst,
        "logo": logo,
        "website": website,
        "org_phone": orgPhone,
        "org_pan_number": orgPanNumber,
        "org_tan_number": orgTanNumber,
        "payment_number": paymentNumber,
        "reference_number": referenceNumber,
        "gst": gst,
        "pan_number": panNumber,
        "tan_number": tanNumber,
        "client_id": clientId,
        "client": client,
        "client_phone": clientPhone,
        "vendor_id": vendorId,
        "vendor": vendor,
        "vendor_phone": vendorPhone,
        "address_detail": addressDetail == null
            ? []
            : List<dynamic>.from(addressDetail!.map((x) => x.toJson())),
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "payment_mode": paymentMode,
        "payment_mode_name": paymentModeName,
        "received_amount": receivedAmount,
        "received_amount_inwords": receivedAmountInwords,
        "transaction_id": transactionId,
        "cheque_number": chequeNumber,
        "cheque_date":
            "${chequeDate!.year.toString().padLeft(4, '0')}-${chequeDate!.month.toString().padLeft(2, '0')}-${chequeDate!.day.toString().padLeft(2, '0')}",
        "excess_amount": excessAmount,
        "utilized_amount": utilizedAmount,
        "notes": notes,
        "invoice_details": invoiceDetails == null
            ? []
            : List<dynamic>.from(invoiceDetails!.map((x) => x.toJson())),
        "created_by": createdBy,
        "status": status,
      };
}

class OrganizationAddress {
  final int? id;
  final int? client;
  final String? clientName;
  final String? address1;
  final String? address2;
  final int? state;
  final String? stateName;
  final String? city;
  final int? country;
  final String? countryName;
  final String? pincode;
  final dynamic landmark;
  final int? addressType;
  final double? latitude;
  final double? longitude;
  final int? createdBy;
  final int? updatedBy;
  final DateTime? created;
  final bool? deleted;
  final bool? status;
  final int? branch;
  final String? branchName;

  OrganizationAddress({
    this.id,
    this.client,
    this.clientName,
    this.address1,
    this.address2,
    this.state,
    this.stateName,
    this.city,
    this.country,
    this.countryName,
    this.pincode,
    this.landmark,
    this.addressType,
    this.latitude,
    this.longitude,
    this.createdBy,
    this.updatedBy,
    this.created,
    this.deleted,
    this.status,
    this.branch,
    this.branchName,
  });

  factory OrganizationAddress.fromJson(Map<String, dynamic> json) =>
      OrganizationAddress(
        id: json["id"],
        client: json["client"],
        clientName: json["client_name"],
        address1: json["address1"],
        address2: json["address2"],
        state: json["state"],
        stateName: json["state_name"],
        city: json["city"],
        country: json["country"],
        countryName: json["country_name"],
        pincode: json["pincode"],
        landmark: json["landmark"],
        addressType: json["address_type"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        deleted: json["deleted"],
        status: json["status"],
        branch: json["branch"],
        branchName: json["branch_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "client": client,
        "client_name": clientName,
        "address1": address1,
        "address2": address2,
        "state": state,
        "state_name": stateName,
        "city": city,
        "country": country,
        "country_name": countryName,
        "pincode": pincode,
        "landmark": landmark,
        "address_type": addressType,
        "latitude": latitude,
        "longitude": longitude,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created": created?.toIso8601String(),
        "deleted": deleted,
        "status": status,
        "branch": branch,
        "branch_name": branchName,
      };
}

class InvoiceDetail {
  final int? id;
  final int? paymentId;
  final dynamic invoice;
  final String? invoiceNumber;
  final DateTime? invoiceDate;
  final double? invoiceAmount;
  final double? dueAmount;
  final String? description;
  final double? receivedAmount;

  InvoiceDetail({
    this.id,
    this.paymentId,
    this.invoice,
    this.invoiceNumber,
    this.invoiceDate,
    this.invoiceAmount,
    this.dueAmount,
    this.description,
    this.receivedAmount,
  });

  factory InvoiceDetail.fromJson(Map<String, dynamic> json) => InvoiceDetail(
        id: json["id"],
        paymentId: json["payment_id"],
        invoice: json["invoice"],
        invoiceNumber: json["invoice_number"],
        invoiceDate: json["invoice_date"] == null
            ? null
            : DateTime.parse(json["invoice_date"]),
        invoiceAmount: json["invoice_amount"]?.toDouble(),
        dueAmount: json["due_amount"]?.toDouble(),
        description: json["description"],
        receivedAmount: json["received_amount"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "payment_id": paymentId,
        "invoice": invoice,
        "invoice_number": invoiceNumber,
        "invoice_date":
            "${invoiceDate!.year.toString().padLeft(4, '0')}-${invoiceDate!.month.toString().padLeft(2, '0')}-${invoiceDate!.day.toString().padLeft(2, '0')}",
        "invoice_amount": invoiceAmount,
        "due_amount": dueAmount,
        "description": description,
        "received_amount": receivedAmount,
      };
}
