import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../locator.dart';
import '../../router.dart';
import '../../app/styles/dark_theme.dart';
import '../../app/styles/light_theme.dart';
import '../../services/navigation_service.dart';

import '../../utils/dialog_manager.dart';

import '../../utils/logger.dart';

Future<Null> main() async {
  runZonedGuarded(() async {
    await bootStrap.configureApp();
  }, (error, stack) {
    Logger.e("Zoned Error", e: error, s: stack);
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        title: "Yolo Invoice",
        theme: LightTheme.appTheme,
        darkTheme: DarkTheme.appTheme,
        themeMode: ThemeMode.system,
        builder: _setupDialogManager,
        debugShowCheckedModeBanner: false,
        // debugShowCheckedModeBanner: deviceService.environment == AppEnvironment.dev ? true : false,
        initialRoute: '/',
        navigatorKey: navigationService.navigatorKey,
        navigatorObservers: [
          RouteObserver(),
          // AnalyticsService.observer,
          SentryNavigatorObserver(),
          MyNavigatorObserver()
        ],
        onGenerateRoute: (settings) => AppRouter.generateRoute(settings),
      ),
    );
  }

  Widget _setupDialogManager(context, widget) {
    return Navigator(
      key: dialogService.dialogNavigationKey,
      onGenerateRoute: (settings) => MaterialPageRoute(builder: (context) {
        final MediaQueryData data = MediaQuery.of(context);
        return DialogManager(
          child: MediaQuery(
            data: data.copyWith(textScaler: TextScaler.linear(1.0)),
            child: widget,
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    networkService.dispose();
    providerContainer.dispose();
    super.dispose();
  }
}
