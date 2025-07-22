import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:yoloworks_invoice/features/dashboard/models/customer/country_model.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel extends Equatable {
    final int? id;
    final String? username;
    final String? firstName;
    final String? lastName;
    final String? gender;
    final int? genderId;
    final int? languageId;
    final String? language;
    final CountryModel? country;
    final bool? acceptedTerms;
    final String? phone;
    final String? email;
    final String? deviceId;
    final String? passcode;

    const UserModel(
        {this.id,
            this.username,
            this.firstName,
            this.lastName,
            this.gender,
            this.genderId,
            this.languageId,
            this.language,
            this.country,
            this.acceptedTerms,
            this.phone,
            this.email,
            this.deviceId,
            this.passcode});

    factory UserModel.fromJson(Map<String, dynamic> json) {
        return UserModel(
            id: json['id'],
            username: json['username'],
            firstName: json['first_name'],
            lastName: json['last_name'],
            gender: json['gender'],
            genderId: json['gender_id'],
            languageId: json['language_id'],
            language: json['language'],
            country:
            json['country'] != null ? CountryModel.fromJson(json['country']) : null,
            acceptedTerms: json['accepted_terms'],
            phone: json['phone'],
            email: json['email'],
            deviceId: json['device_id'],
            passcode: json['passcode']);
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['id'] = id;
        data['username'] = username;
        data['first_name'] = firstName;
        data['last_name'] = lastName;
        data['gender'] = gender;
        data['gender_id'] = genderId;
        data['language_id'] = languageId;
        data['language'] = language;
        if (country != null) {
            data['country'] = country!.toJson();
        }
        data['accepted_terms'] = acceptedTerms;
        data['phone'] = phone;
        data['email'] = email;
        data['device_id'] = deviceId;
        data['passcode'] = passcode;
        return data;
    }

    @override
    List<Object?> get props => [firstName, email, phone, id, country, passcode];
}

// class Country {
//     int? id;
//     String? name;
//     String? iso3;
//     String? iso2;
//     String? phoneCode;
//     String? capital;
//     String? currency;
//     String? currencySymbol;
//     String? tld;
//     String? native;
//     String? region;
//     String? subregion;
//     String? latitude;
//     String? longitude;
//     String? emoji;
//     String? emojiu;
//
//     Country(
//         {this.id,
//             this.name,
//             this.iso3,
//             this.iso2,
//             this.phoneCode,
//             this.capital,
//             this.currency,
//             this.currencySymbol,
//             this.tld,
//             this.native,
//             this.region,
//             this.subregion,
//             this.latitude,
//             this.longitude,
//             this.emoji,
//             this.emojiu});
//
//     Country.fromJson(Map<String, dynamic> json) {
//         id = json['id'];
//         name = json['name'];
//         iso3 = json['iso3'];
//         iso2 = json['iso2'];
//         phoneCode = json['phone_code'];
//         phoneCode = json['phoneCode'];
//         capital = json['capital'];
//         currency = json['currency'];
//         currencySymbol = json['currency_symbol'];
//         tld = json['tld'];
//         native = json['native'];
//         region = json['region'];
//         subregion = json['subregion'];
//         latitude = json['latitude'];
//         longitude = json['longitude'];
//         emoji = json['emoji'];
//         emojiu = json['emojiu'];
//     }
//
//     Map<String, dynamic> toJson() {
//         final Map<String, dynamic> data = <String, dynamic>{};
//         data['id'] = id;
//         data['name'] = name;
//         data['iso3'] = iso3;
//         data['iso2'] = iso2;
//         data['phone_code'] = phoneCode;
//         data['phoneCode'] = phoneCode;
//         data['capital'] = capital;
//         data['currency'] = currency;
//         data['currency_symbol'] = currencySymbol;
//         data['tld'] = tld;
//         data['native'] = native;
//         data['region'] = region;
//         data['subregion'] = subregion;
//         data['latitude'] = latitude;
//         data['longitude'] = longitude;
//         data['emoji'] = emoji;
//         data['emojiu'] = emojiu;
//         return data;
//     }
// }

