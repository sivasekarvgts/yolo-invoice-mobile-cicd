import 'dart:convert';

import 'package:equatable/equatable.dart';

List<StateModel> stateModelFromJson(String str) =>
    List<StateModel>.from(json.decode(str).map((x) => StateModel.fromJson(x)));

String stateModelToJson(List<StateModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StateModel extends Equatable {
  final int? id;
  final String? name;
  final int? country;
  final CountryName? countryName;
  final String? stateCode;
  final bool? status;
  final bool? delete;

  StateModel({
    this.id,
    this.name,
    this.country,
    this.countryName,
    this.stateCode,
    this.status,
    this.delete,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) => StateModel(
        id: json["id"],
        name: json["name"],
        country: json["country"],
        countryName: countryNameValues.map[json["country_name"]]!,
        stateCode: json["state_code"],
        status: json["status"],
        delete: json["delete"],
      );

  StateModel fromJson(Map<String, dynamic> json) => StateModel.fromJson(json);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "country": country,
        "country_name": countryNameValues.reverse[countryName],
        "state_code": stateCode,
        "status": status,
        "delete": delete,
      };

  @override
  List<Object?> get props =>
      [id, name, country, countryName, stateCode, status, delete];
}

enum CountryName { INDIA }

final countryNameValues = EnumValues({"India": CountryName.INDIA});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
