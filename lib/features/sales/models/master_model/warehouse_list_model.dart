// To parse this JSON data, do
//
//     final warehouseListModel = warehouseListModelFromJson(jsonString);

import 'dart:convert';

List<WarehouseListModel> warehouseListModelFromJson(String str) => List<WarehouseListModel>.from(json.decode(str).map((x) => WarehouseListModel.fromJson(x)));

String warehouseListModelToJson(List<WarehouseListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WarehouseListModel {
  final int? id;
  final String? name;
  final dynamic warehouseTypeId;
  final String? warehouseType;
  final String? email;
  final String? phone;
  final String? organizationId;
  final bool? isPrimary;
  final bool? status;
  final bool? delete;
  final String? city;
  final String? address1;
  final String? address2;
  final String? pincode;

  WarehouseListModel({
    this.id,
    this.name,
    this.warehouseTypeId,
    this.warehouseType,
    this.email,
    this.phone,
    this.organizationId,
    this.isPrimary,
    this.status,
    this.delete,
    this.city,
    this.address1,
    this.address2,
    this.pincode,
  });

  factory WarehouseListModel.fromJson(Map<String, dynamic> json) => WarehouseListModel(
    id: json["id"],
    name: json["name"],
    warehouseTypeId: json["warehouse_type_id"],
    warehouseType: json["warehouse_type"],
    email: json["email"],
    phone: json["phone"],
    organizationId: json["organization_id"],
    isPrimary: json["is_primary"],
    status: json["status"],
    delete: json["delete"],
    city: json["city"],
    address1: json["address1"],
    address2: json["address2"],
    pincode: json["pincode"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "warehouse_type_id": warehouseTypeId,
    "warehouse_type": warehouseType,
    "email": email,
    "phone": phone,
    "organization_id": organizationId,
    "is_primary": isPrimary,
    "status": status,
    "delete": delete,
    "city": city,
    "address1": address1,
    "address2": address2,
    "pincode": pincode,
  };
}
