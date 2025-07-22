import 'package:equatable/equatable.dart';

import '../../app/constants/app_constants.dart';

class AddressDetail extends Equatable {
  AddressDetail({
    required this.id,
    required this.client,
    required this.clientName,
    required this.vendor,
    required this.vendorName,
    required this.address1,
    required this.address2,
    required this.state,
    required this.stateName,
    required this.city,
    required this.country,
    required this.countryName,
    required this.pincode,
    required this.landmark,
    required this.addressType,
    required this.latitude,
    required this.longitude,
    required this.createdBy,
    required this.updatedBy,
    required this.created,
    required this.deleted,
    required this.status,
  });

  final int? id;
  final int? client;
  final String? clientName;
  final int? vendor;
  final String? vendorName;
  final dynamic address1;
  final dynamic address2;
  final int? state;
  final String? stateName;
  final String? city;
  final dynamic country;
  final String? countryName;
  final dynamic pincode;
  final dynamic landmark;
  final int? addressType;
  final double? latitude;
  final double? longitude;
  final dynamic createdBy;
  final dynamic updatedBy;
  final DateTime? created;
  final bool? deleted;
  final bool? status;

  factory AddressDetail.fromJson(Map<String, dynamic> value) {
    final json = AppConstants.isNotNullJson(value);
    return AddressDetail(
      id: json["id"]?.toInt(),
      client: json["client"],
      clientName: json["client_name"],
      vendor: json["vendor"],
      vendorName: json["vendor_name"],
      address1: json["address1"],
      address2: json["address2"],
      state: json["state"]?.toInt(),
      stateName: json["state_name"],
      city: json["city"],
      country: json["country"]?.toInt(),
      countryName: json["country_name"],
      pincode: json["pincode"],
      landmark: json["landmark"],
      addressType: json["address_type"],
      latitude: (json["latitude"] as num?)?.toDouble(),
      longitude: (json["longitude"] as num?)?.toDouble(),
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
        "vendor": vendor,
        "vendor_name": vendorName,
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
      };

  @override
  String toString() {
    return "$id, $client, $clientName, $vendor, $vendorName, $address1, $address2, $state, $stateName, $city, $country, $countryName, $pincode, $landmark, $addressType, $latitude, $longitude, $createdBy, $updatedBy, $created, $deleted, $status, ";
  }

  @override
  List<Object?> get props => [
        id,
        client,
        clientName,
        vendor,
        vendorName,
        address1,
        address2,
        state,
        stateName,
        city,
        country,
        countryName,
        pincode,
        landmark,
        addressType,
        latitude,
        longitude,
        createdBy,
        updatedBy,
        created,
        deleted,
        status,
      ];
}
