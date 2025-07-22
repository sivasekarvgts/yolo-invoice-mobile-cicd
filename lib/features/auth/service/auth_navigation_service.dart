// class AuthRepoService {
//   Future navigate() async {
//     final orgs =
//     PreferenceService.getValue(AppConstants.organizationPreferences);
//     if (orgs.isEmpty) return Get.offAllNamed(RoutesConstant.selectOrganization);
//     final value = PreferenceService.getValue(AppConstants.checkInPreferences);
//
//     Logger.d(msg: 'Check-InPreferences $value');
//     bool isNavigate = false;
//     bool isCheckedIn = value.isNotEmpty;
//
//     if (value.isEmpty) {
//       final checkInRes =
//       await Get.find<SODCheckInStatusUsecase>().call(NoParams());
//       checkInRes.fold((l) {
//         Logger.d(msg: "Error ${l.msg}");
//         DialogUtitls.showNetworkAlert(onTap: () async {
//           await navigate();
//         });
//         return;
//       }, (r) async {
//         Logger.d(
//             msg:
//             'status ${!(r.checkIn!)} ${(r.checkIn != null && !(r.checkIn!))}');
//         if (r.sessionId == null && r.checkIn != null && !(r.checkIn!)) {
//           isNavigate = true;
//           Get.offAllNamed(RoutesConstant.sodScreen, arguments: {'isSod': true});
//           return;
//         }
//         await PreferenceService.writeValue(
//             AppConstants.checkInPreferences, checkInStatusModelToJson(r));
//         isCheckedIn = true;
//         return;
//       });
//     }
//     if (isNavigate) return;
//     final downloadedDateTime =
//     PreferenceService.getValue(AppConstants.lastDownloadSyncPreferences);
//     Logger.d(
//         msg:
//         'isCheckedIn $isCheckedIn, downloadedDateTime $downloadedDateTime');
//     if (isCheckedIn && downloadedDateTime.isNotEmpty) {
//       return Get.offAllNamed(RoutesConstant.home);
//     }
//     Get.offAllNamed(RoutesConstant.sodScreen, arguments: {'isSod': true});
//   }
//
//   Future clearLocalData() async {
//     await PreferenceService.removeValue(AppConstants.checkInPreferences);
//     await PreferenceService.removeValue(AppConstants.routeBillListPreferences);
//     await PreferenceService.removeValue(AppConstants.selectedRoutePreferences);
//     await PreferenceService.removeValue(
//         AppConstants.lastDownloadSyncPreferences);
//   }
// }
