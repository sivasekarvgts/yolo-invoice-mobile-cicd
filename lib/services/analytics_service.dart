// import 'dart:convert';
//
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:mixpanel_flutter/mixpanel_flutter.dart';
// import '../../locator.dart';
// import '../../app/constants/keys.dart';
//
// class AnalyticsService {
//   final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
//   static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);
//
//   late Mixpanel mixpanel;
//
//   init() async {
//     mixpanel = await Mixpanel.init(appConfigService.envString == "PROD" ? Keys.mixPanelProdkey : Keys.mixPanelDevkey, optOutTrackingDefault: false, trackAutomaticEvents: true);
//   }
//
//   Future<void> setUserId(int userId) async {
//     analytics.setUserId(id: userId.toString());
//
//     // TODO
//     //  User? user = preferenceService.getUser();
//
//     // if (user != null) {
//     //   mixpanel.identify(user.id.toString());
//     //   mixpanel.getPeople().set("name", (user.firstName ?? '') + (user.lastName ?? ''));
//     //   mixpanel.getPeople().set("authInfo", user.toJson());
//     // }
//
//     FirebaseCrashlytics.instance.setUserIdentifier(userId.toString());
//   }
//
//   Future<void> logLogin() async {
//     analytics.logLogin();
//   }
//
//   Future<void> logSignUp() async {
//     analytics.logSignUp(signUpMethod: "Mobile App");
//   }
//
//   Future<void> logScreenName(String screenName) async {
//     mixpanel.track("Route: $screenName", properties: {"preference": preferenceService.getAllInfo()});
//     await analytics.logScreenView(screenName: screenName);
//   }
//
//   Future<void> logByScreen(String screenName) async {
//     mixpanel.timeEvent("screenName: $screenName");
//   }
//
//   Future<void> logScreenView(String? screenName, {String? className = ""}) async {
//     className = screenName;
//     logEvent('screen_view', {'screen_name': screenName, 'screen_class': className});
//   }
//
//   Future<void> logEvent(String name, Map<String, dynamic> parameters) async {
//     mixpanel.track(name, properties: {"preference": preferenceService.getAllInfo(), ...parameters});
//     await analytics.logEvent(name: name, parameters: filterOutNulls(parameters));
//     debugPrint('Analytics: $name - ${parameters.toString()}');
//   }
//
//   Future timerEvent(String endPoint) async {
//     mixpanel.timeEvent("Network: $endPoint");
//   }
//
//   Future logNetwork(String endPoint, String method, Object? params, dynamic response) async {
//     if (params.toString().startsWith('{', 0)) {
//       mixpanel.track("Network: $endPoint", properties: {"method": method, "params": jsonEncode(params), "response": response, "preference": preferenceService.getAllInfo()});
//     }
//   }
//
//   void logAppOpen() {
//     analytics.logAppOpen();
//   }
//
//   Map<String, Object> filterOutNulls(Map<String, Object?> parameters) {
//     final Map<String, Object> filtered = <String, Object>{};
//     parameters.forEach((String key, Object? value) {
//       if (value != null) {
//         filtered[key] = value;
//       }
//     });
//     return filtered;
//   }
// }




// import 'dart:convert';

// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:mixpanel_flutter/mixpanel_flutter.dart';
// import '../../locator.dart';
// import '../../app/constants/keys.dart';

// class AnalyticsService {
//   final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
//   static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);

//   late Mixpanel mixpanel;

//   init() async {
//     mixpanel = await Mixpanel.init(appConfigService.envString == "PROD" ? Keys.mixPanelProdkey : Keys.mixPanelDevkey, optOutTrackingDefault: false, trackAutomaticEvents: true);
//   }

//   Future<void> setUserId(int userId) async {
//     analytics.setUserId(id: userId.toString());

//     // TODO
//     //  User? user = preferenceService.getUser();

//     // if (user != null) {
//     //   mixpanel.identify(user.id.toString());
//     //   mixpanel.getPeople().set("name", (user.firstName ?? '') + (user.lastName ?? ''));
//     //   mixpanel.getPeople().set("authInfo", user.toJson());
//     // }

//     FirebaseCrashlytics.instance.setUserIdentifier(userId.toString());
//   }

//   Future<void> logLogin() async {
//     analytics.logLogin();
//   }

//   Future<void> logSignUp() async {
//     analytics.logSignUp(signUpMethod: "Mobile App");
//   }

//   Future<void> logScreenName(String screenName) async {
//     mixpanel.track("Route: $screenName", properties: {"preference": preferenceService.getAllInfo()});
//     await analytics.logScreenView(screenName: screenName);
//   }

//   Future<void> logByScreen(String screenName) async {
//     mixpanel.timeEvent("screenName: $screenName");
//   }

//   Future<void> logScreenView(String? screenName, {String? className = ""}) async {
//     className = screenName;
//     logEvent('screen_view', {'screen_name': screenName, 'screen_class': className});
//   }

//   Future<void> logEvent(String name, Map<String, dynamic> parameters) async {
//     mixpanel.track(name, properties: {"preference": preferenceService.getAllInfo(), ...parameters});
//     await analytics.logEvent(name: name, parameters: filterOutNulls(parameters));
//     debugPrint('Analytics: $name - ${parameters.toString()}');
//   }

//   Future timerEvent(String endPoint) async {
//     mixpanel.timeEvent("Network: $endPoint");
//   }

//   Future logNetwork(String endPoint, String method, Object? params, dynamic response) async {
//     if (params.toString().startsWith('{', 0)) {
//       mixpanel.track("Network: $endPoint", properties: {"method": method, "params": jsonEncode(params), "response": response, "preference": preferenceService.getAllInfo()});
//     }
//   }

//   void logAppOpen() {
//     analytics.logAppOpen();
//   }

//   Map<String, Object> filterOutNulls(Map<String, Object?> parameters) {
//     final Map<String, Object> filtered = <String, Object>{};
//     parameters.forEach((String key, Object? value) {
//       if (value != null) {
//         filtered[key] = value;
//       }
//     });
//     return filtered;
//   }
// }
