// // ignore_for_file: avoid_print

// import 'package:flutter/cupertino.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'appconfig_service.dart';
// import 'navigator_service.dart';
// import '../../../locator.dart';

// class PushNotificationService {
//   final AppConfigService? _appConfigService = locator<AppConfigService>();

//   int _tab = 0;

//   //Remove these when v1 is removed
//   getReturnTab() => _tab;
//   setReturnTab(int tab) => _tab = tab;

//   Future<void> configure(String mobileNum) async {
//     OneSignal.shared.setAppId(_appConfigService!.config.oneSignal);
    
//     OneSignal.shared.setExternalUserId(mobileNum);

//     OneSignal.shared.setSubscriptionObserver((OSSubscriptionStateChanges changes) {
//       print("Subscription Observer");
//     });
//   }

//   Future<void> initNotificationListener() async {
//     debugPrint("Initialized Notification Listener");

//     OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) async {
//       try {
//         var url = result.notification.additionalData!['target_url'];
//         var data = result.notification.additionalData!['id'];
//         print("url $url");
//         print("data $data");

//         //  await preferenceService.setStudentId(data);

//         if (url?.isNotEmpty == true) {
//           Uri uri = Uri.parse(url!);
//           locator<NavigationService>().pushNamed(
//             uri.path + (uri.hasQuery ? "?${uri.query}" : ""),
//           );
//           // }
//         }
//       } on Exception catch (e) {
//         print(e.toString());
//       }
//     });



//     OneSignal.shared.setInAppMessageClickedHandler((OSInAppMessageAction action) async {
//       try {
//         if (action.clickName != null) {
//           Uri? uri = Uri.tryParse(action.clickName!);
//           if (uri != null) {
//             locator<NavigationService>().pushNamed(
//               uri.path + (uri.hasQuery ? "?${uri.query}" : ""),
//             );
//           }
//         }
//       } on Exception catch (e) {
//         print(e.toString());
//       }
//     });
//   }

//   Future<Map<String, dynamic>> setUser(int? userId) async {
//     return await OneSignal.shared.setExternalUserId(userId.toString());
//     // ignore: todo
//   }

//   Future<bool> promptOneSignal({bool fallbackToSettings = false}) async {
//     return await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: fallbackToSettings);
//   }
// }
