import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../locator.dart';
import '../../../../services/appconfig_service/appconfig_model.dart';
import '../../service/auth_service.dart';
part 'login_controller.g.dart';

@riverpod
class LoginController extends _$LoginController {
  @override
  AsyncValue<void> build() {
    return AsyncValue.data(null);
  }

  setState() {
    state = AsyncValue.data(null);
  }

  late InAppWebViewController controller;
  bool load = true;
  bool isPageNotLoaded = false;
  late Uri uri;
  bool isLoading = false;

  late PackageInfo info;
  final AppConfig appConfig = appConfigService.config;

  Future<void> init() async {
    info = await PackageInfo.fromPlatform();
    uri = Uri.parse(appConfig.accountUrl ?? "");
  }

  login() async {
    isLoading = true;
    state = AsyncValue.data(null);
    bool _res = await AuthenticationService().login();
    if (_res == false) {
      isLoading = false;
      state = AsyncValue.data(null);
    }
    ;
  }
}
