import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoloworks_invoice/app/constants/app_constants.dart';
import 'package:yoloworks_invoice/features/auth/models/organization_model.dart';
import 'package:yoloworks_invoice/utils/utils.dart';

import '../features/auth/models/user_model.dart';
import '../features/dashboard/view/dashboard_controller.dart';

class PreferenceService {
  static const String bearerToken = "ACCESSTOKEN";
  static const String userName = "USERNAME";
  static const String deviceId = "DEVICEID";
  static const String emailId = "EMAILID";
  static const String userInfo = "USERINFO";
  static const String userOrg = "USERORG";
  static const String dashboardLinks = "DASHBOARDLINKS";

  late SharedPreferences pref;

  Future<void> init() async {
    pref = await SharedPreferences.getInstance();
  }

  Future<void> setBearerToken(String value) async{
    await pref.setString(bearerToken, value);
    debugPrint("Bearer Token stored successfully");
  }

  String getBearerToken() {
    return pref.getString(bearerToken) ?? '';
  }

  void setDeviceId(String value) {
    pref.setString(deviceId, value);
    debugPrint("DeviceId stored successfully");
  }

  String getDeviceId() {
    return pref.getString(deviceId) ?? "";
  }

  Future<void> setUserInfo(UserModel user) async {
    final jsonString = jsonEncode(user.toJson());
    await pref.setString(userInfo, jsonString);
    debugPrint("UserInfo stored successfully");
  }

  UserModel? getUserInfo() {
    String? _userInfo = pref.getString(userInfo);
    if (_userInfo == null || _userInfo.isEmpty) {
      return null;
    }
    return UserModel.fromJson(jsonDecode(_userInfo));
  }

  Future<void> setUserOrg(Organization org) async{
    final jsonString = jsonEncode(org.toJson());
   await pref.setString(userOrg, jsonString);
    debugPrint("UserOrg stored successfully");
  }

  Organization? getUserOrg() {
    String? _userInfo = pref.getString(userOrg);
    if (_userInfo == null || _userInfo.isEmpty) {
      return null;
    }
    return Organization.fromJson(jsonDecode(_userInfo));
  }

  String getAllInfo() {
    return jsonEncode(pref.getKeys().where((element) => element != userName).map((e) => {e: pref.get(e)}).toList());
  }
  Future<void> setDashboardLink(List<QuickLickModel> links) async {
    final jsonString = jsonEncode(links.map((e) => e.toJson()).toList());
    await pref.setString(dashboardLinks, jsonString);
    debugPrint("Dashboard links stored successfully");
  }

  List<QuickLickModel> getDashboardLink() {
    String? _links = pref.getString(dashboardLinks);
    if (_links == null || _links.isEmpty) {
      return AppConstants.quickLinkCards;
    }
    List<dynamic> decoded = jsonDecode(_links);
    return decoded
        .map<QuickLickModel>((e) => QuickLickModel.fromJson(e))
        .toList();
  }





  Future<void> clear() async {
    await pref.clear();
    debugPrint("Preferences cleared successfully");
    await init();
  }


  // setSpeciality(String specialityId, String specialityName) {
  //   pref.setStringList(speciality, [specialityId, specialityName]);
  //   debugPrint("speciality stored successfully");
  // }
  //
  // List<String> getSpeciality() {
  //   return pref.getStringList(speciality) ?? [];
  // }
}
