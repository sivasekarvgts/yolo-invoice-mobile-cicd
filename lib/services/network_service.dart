import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../locator.dart';
import '../../router.dart';

class NetworkService {
  StreamSubscription<ConnectivityResult>? subscription;

  init() async {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.last == ConnectivityResult.none) {
        navigationService.pushNamed(Routes.offline);
      } else {
       // navigationService.pop();
      }
    });
  }

  checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      navigationService.pop();
    } else {
      await Fluttertoast.showToast(msg: "Please turn on your internet");
    }
  }

  void dispose() {
    subscription?.cancel();
  }
}
