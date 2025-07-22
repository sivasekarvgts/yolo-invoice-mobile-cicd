import 'dart:convert';

import 'package:equatable/equatable.dart';

List<CountryModel> countryModelFromJson(String str) => List<CountryModel>.from(
    json.decode(str).map((x) => CountryModel.fromJson(x)));

String countryModelToJson(List<CountryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CountryModel extends Equatable {
  final int? id;
  final String? name;
  final String? iso3;
  final String? iso2;
  final String? countryModelPhoneCode;
  final String? phoneCode;
  final String? capital;
  final String? currency;
  final String? currencySymbol;
  final String? tld;
  final String? native;
  final Region? region;
  final String? subregion;
  final String? latitude;
  final String? longitude;
  final String? emoji;
  final String? emojiu;

  CountryModel({
    this.id,
    this.name,
    this.iso3,
    this.iso2,
    this.countryModelPhoneCode,
    this.phoneCode,
    this.capital,
    this.currency,
    this.currencySymbol,
    this.tld,
    this.native,
    this.region,
    this.subregion,
    this.latitude,
    this.longitude,
    this.emoji,
    this.emojiu,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
        id: json["id"],
        name: json["name"],
        iso3: json["iso3"],
        iso2: json["iso2"],
        countryModelPhoneCode: json["phone_code"],
        phoneCode: json["phoneCode"],
        capital: json["capital"],
        currency: json["currency"],
        currencySymbol: json["currency_symbol"],
        tld: json["tld"],
        native: json["native"],
        region: regionValues.map[json["region"]]!,
        subregion: json["subregion"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        emoji: json["emoji"],
        emojiu: json["emojiu"],
      );

  CountryModel fromJson(Map<String, dynamic> json) =>
      CountryModel.fromJson(json);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "iso3": iso3,
        "iso2": iso2,
        "phone_code": countryModelPhoneCode,
        "phoneCode": phoneCode,
        "capital": capital,
        "currency": currency,
        "currency_symbol": currencySymbol,
        "tld": tld,
        "native": native,
        "region": regionValues.reverse[region],
        "subregion": subregion,
        "latitude": latitude,
        "longitude": longitude,
        "emoji": emoji,
        "emojiu": emojiu,
      };

  @override
  // TODO: implement props
  List<Object?> get props =>
      [id, name, capital, currency, currencySymbol, latitude, longitude];
}

enum Region { AFRICA, AMERICAS, ASIA, EMPTY, EUROPE, OCEANIA, POLAR }

final regionValues = EnumValues({
  "Africa": Region.AFRICA,
  "Americas": Region.AMERICAS,
  "Asia": Region.ASIA,
  "": Region.EMPTY,
  "Europe": Region.EUROPE,
  "Oceania": Region.OCEANIA,
  "Polar": Region.POLAR
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
