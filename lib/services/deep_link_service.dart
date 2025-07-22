// import 'package:app_links/app_links.dart';
// import 'package:flutter_styled_toast/flutter_styled_toast.dart';
// import '../../locator.dart';
//
//
// class DeepLinkService {
//   final _appLinks = AppLinks();
//
//   Future<void> initAppLinks() async {
//     _appLinks.uriLinkStream.listen((Uri? uri) {
//       if (uri != null && uri.path == 'invoice.com') {
//         // navigationService.popAllAndPushNamed(Routes.password);
//       }
//     }, onError: (err) {
//       showToast('Opps!, something went wrong😑', context: navigationService.navigatorKey.currentContext);
//     });
//   }
// }
