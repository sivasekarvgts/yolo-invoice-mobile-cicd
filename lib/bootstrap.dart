import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sentry_logging/sentry_logging.dart';
import 'package:yoloworks_invoice/features/auth/service/auth_service.dart';
import 'package:yoloworks_invoice/utils/firebase_options/firebase_options_devx.dart';

import '../../app/styles/colors.dart';
import '../../core/enums/environment.dart';
import '../../locator.dart';
import '../../main.dart';
import '../../router.dart';
import '../../utils/firebase_options/firebase_option_uat.dart';
import '../../utils/firebase_options/firebase_options_dev.dart';
import '../../utils/firebase_options/firebase_options_prod.dart';
import '../../utils/logger.dart';
import '../../utils/maintenance_checker.dart';
import '../../utils/provider_observer.dart';

class Bootstrap {
  configureApp() async {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: AppColors.background,
      statusBarBrightness: Brightness.light, // For iOS
      statusBarIconBrightness: Brightness.dark, // For Android
    ));
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    configureLogger();
    await deviceService.initPlatformPackageInfo();

    await Firebase.initializeApp(
        name:
            deviceService.packageInfo?.appName.replaceAll(" ", "_"),
        options: getFirebaseOption(deviceService.environment!));

    usePathUrlStrategy();

    // * App Orientations setup
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );
    // * Show some error UI if any uncaught exception happens
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint(details.toString());
    };
    // * Handle errors from the underlying platform/OS
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      debugPrint(error.toString());
      return true;
    };

    await appConfigService.configure();
    //await analyticsService.init();
    await preferenceService.init();
    // await DeepLinkService().initAppLinks();

    FlutterNativeSplash.remove();
    //await analyticsService.logEvent("AppStrings.SessionStart.text", {});

    HttpOverrides.global = MyHttpOverrides();

    await SentryFlutter.init(
      (options) async {
        options.dsn = await deviceService.isProd
            ? appConfigService.config.sentry?.dsn
            : appConfigService.config.sentry?.dsn;
        //  options.debug = !kReleaseMode;
        options.tracesSampleRate = 1.0;
        options.addIntegration(LoggingIntegration());
        options.environment = deviceService.envString();
        options.release = deviceService.version;
      },
      appRunner: () => runApp(
          ProviderScope(observers: [MyObserver()], child: const MyApp())),
    );
  }

  initializeApp() async {
    try {
      try {
        await MaintenanceChecker().versionCheck();
      } catch (e) {
        debugPrint("maintenance_checker_error $e");
      }
      try {
        await updateCheckerService.versionCheck();
      } catch (e) {
        debugPrint("Update_checker_error $e");
      }

      if (preferenceService.getBearerToken().isNotEmpty ||
          preferenceService.getBearerToken() != '') {
        try {
          await AuthenticationService().authNavigate();
          // final authRepo = await providerContainer.read(dioAuthRepositoryProvider.notifier);
          // await authRepo.Oboardingnavgiation(forceRefresh: true);

          // TODO : revisit for notification
          // locator<PushNotificationService>().configure(preferenceService.getUser()!.phone!);
          // Sentry.configureScope((scope) => scope.setUser(SentryUser(
          //     id: preferenceService.getUser()!.id.toString(),
          //     username: preferenceService.getUser()!.phone,
          //     login: preferenceService.getUser()!.login,
          //     name: "${preferenceService.getUser()!.firstName ?? ''} ${preferenceService.getUser()!.lastName ?? ''}",
          //     data: preferenceService.getUser()!.toJson())));
          // navigationService.popAllAndPushNamed(Routes.login);
        } catch (ex, s) {
          Logger.e(ex.toString(), s: s);
          return;
        }
      } else {
        Future.delayed(const Duration(milliseconds: 2500)).then((value) async {
          // await networkService.init();
          navigationService.popAllAndPushNamed(Routes.login);
        });
      }
    } catch (e) {
      debugPrint("EXCEPTION $e");
    }
  }

  getFirebaseOption(AppEnvironment appEnvironment) {
    switch (appEnvironment) {
      case AppEnvironment.dev :
        return Platform.isIOS
            ? DefaultFirebaseOptionsDev.ios
            : DefaultFirebaseOptionsDev.android;
      case AppEnvironment.devX:
        return Platform.isIOS
            ? DefaultFirebaseOptionsDevX.ios
            : DefaultFirebaseOptionsDevX.android;
      case AppEnvironment.staging:
        return Platform.isIOS
            ? DefaultFirebaseOptionsUAT.ios
            : DefaultFirebaseOptionsUAT.android;
      case AppEnvironment.production:
        return Platform.isIOS
            ? DefaultFirebaseOptionsProd.ios
            : DefaultFirebaseOptionsProd.android;
    }
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
