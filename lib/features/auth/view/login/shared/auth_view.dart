import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:yoloworks_invoice/locator.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/styles/colors.dart';
import '../../../../../app/common_widgets/app_loading_widget.dart';

import '../../../models/user_model.dart';
import '../login_controller.dart';

class AuthView extends ConsumerStatefulWidget {
  const AuthView({super.key});

  @override
  ConsumerState createState() => _AuthViewState();
}

class _AuthViewState extends ConsumerState<AuthView> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(loginControllerProvider.notifier);
    ref.watch(loginControllerProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xfffafafa),
        actions: [
          IconButton(
              onPressed: () => navigationService.pop(),
              icon: const Icon(Icons.close))
        ],
      ),
      body: PopScope(
        canPop: true,
        // canPop: (v)  {
        //   if (await controller.canGoBack()) {
        //     await controller.goBack();
        //     return Future.value(false);
        //   }
        //   return Future.value(true);
        // },
        child: Stack(
          children: [
            Positioned.fill(
              child: controller.isPageNotLoaded
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: LottieBuilder.asset(
                              'assets/jsons/page_not_found.json',
                              repeat: true,
                              fit: BoxFit.cover),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextButton.icon(
                              onPressed: () {
                                // setState(() {
                                controller.isPageNotLoaded = false;
                                controller.load = true;
                                controller.setState();
                                // });
                              },
                              icon: const Icon(Icons.refresh,
                                  color: AppColors.blueColor),
                              label: Text('Refresh',
                                  style: AppTextStyle.titleSmall)),
                        )
                      ],
                    )
                  : InAppWebView(
                      initialUrlRequest:
                          URLRequest(url: WebUri.uri(controller.uri)),
                      onConsoleMessage: (controller, message) {
                        debugPrint("MESSAGE: ${message.toJson()}");
                      },
                      initialSettings: InAppWebViewSettings(
                        javaScriptEnabled: true,
                        userAgent:
                            "yolo-app/field-force/${controller.info.version}-${controller.info.buildNumber}",
                        allowFileAccessFromFileURLs: true,
                        allowUniversalAccessFromFileURLs: true,
                        supportZoom: false,
                        mediaPlaybackRequiresUserGesture: false,
                        horizontalScrollBarEnabled: false,
                        verticalScrollBarEnabled: false,
                        transparentBackground: true,
                        isInspectable: !kReleaseMode,
                        supportMultipleWindows: false,
                        builtInZoomControls: false,
                        forceDark: ForceDark.OFF,
                        allowsBackForwardNavigationGestures: false,
                        clearCache: true,
                        cacheEnabled: false,
                      ),
                      onReceivedError: (_controller, request, error) {
                        controller.isPageNotLoaded = true;
                        controller.setState();
                        debugPrint('error.type ${error.type}');
                        debugPrint('error.des ${error.description}');
                        debugPrint('req ${request.isForMainFrame}');
                      },
                      onReceivedHttpError: (ctrl, req, res) {
                        debugPrint('res ${res.statusCode}');
                        debugPrint('res ${res.data}');
                      },
                      onWebViewCreated: (_controller) async {
                        controller.controller = _controller;
                        _controller.addJavaScriptHandler(
                            handlerName: 'onAuthenticated',
                            callback: onAuthenticated);
                      },
                      onLoadStop: (_controller, s) {
                        debugPrint('load ${s?.data}');
                        // setState(() {
                        controller.load = false;
                        controller.setState();
                        // });
                      },
                    ),
            ),
            if (controller.load)
              Positioned.fill(
                  child: Container(
                      color: Colors.white,
                      child: const Center(
                        child: AppLoadingWidget(isCircularBar: true),
                      ))),
          ],
        ),
      ),
    );
  }
}

onAuthenticated(List<dynamic> args) async {
  debugPrint("onAuthenticated : $args");
  if (args.isNotEmpty) {
    UserModel? model = UserModel.fromJson(args.first['user']);
    if (model.id != null) {
      await Sentry.configureScope(
        (scope) => scope.setUser(SentryUser(
            id: model.id != null ? '' : model.id.toString(),
            email: model.email,
            username: '${model.firstName}${model.lastName}',
            data: {
              'phone': model.phone,
              'device_id': model.deviceId,
              'gender': model.gender,
              'country': model.country?.toJson(),
              'passcode': model.passcode,
            })),
      );
    }
    navigationService.pop(returnValue: model);
    // Get.back(result: model);
  }
}
