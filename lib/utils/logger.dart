// ignore_for_file: avoid_function_literals_in_foreach_calls, unused_local_variable

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:intl/intl.dart';
import '../../locator.dart';

import '../../app/styles/colors.dart';
import '../../core/enums/environment.dart';

import 'package:logging/logging.dart' as LoggingIntegration;

configureLogger() {
  if (!kReleaseMode || appConfigService.appEnvironment != AppEnvironment.production) {
    Logger.addClient(DebugLoggerClient());
  } else {
    Logger.addClient(CrashlyticsLoggerClient());
  }
}

class Logger {
  static final _clients = <LoggerClient>[];

  /// Debug level logs
  static d(String message, {dynamic e, StackTrace? s}) {
    _clients.forEach((c) => c.onLog(
          level: LogLevel.debug,
          message: message,
          e: e,
          s: s,
        ));

    loggerService.log(LogLevel.debug.name, message, DateTime.now().toString());
  }

  // Warning level logs
  static w(
    String message, {
    dynamic e,
    StackTrace? s,
  }) {
    _clients.forEach((c) => c.onLog(
          level: LogLevel.warning,
          message: message,
          e: e,
          s: s,
        ));

    loggerService.log(LogLevel.warning.name, message, DateTime.now().toString());
  }

  /// Error level logs
  /// Requires a current StackTrace to report correctly on Crashlytics
  /// Always reports as non-fatal to Crashlytics
  static e(String message, {dynamic e, required StackTrace s}) {
    _clients.forEach((c) => c.onLog(
          level: LogLevel.error,
          message: message,
          e: e,
          s: s,
        ));

    loggerService.log(LogLevel.error.name, message, DateTime.now().toString());
  }

  static addClient(LoggerClient client) {
    _clients.add(client);
  }
}

enum LogLevel { debug, warning, error }

abstract class LoggerClient {
  onLog({
    required LogLevel level,
    required String message,
    required dynamic e,
    StackTrace? s,
  });
}

/// Debug logger that just prints to console
class DebugLoggerClient implements LoggerClient {
  static final dateFormat = DateFormat("HH:mm a");
  String _timestamp() {
    return dateFormat.format(DateTime.now());
  }

  @override
  onLog({
    required LogLevel level,
    required String message,
    required dynamic e,
    StackTrace? s,
  }) {
    String tag = "";

    switch (level) {
      case LogLevel.debug:
        tag = "[DEBUG]";
        debugPrint("${_timestamp()} [DEBUG]  $message");

        if (e != null) {
          debugPrint(e.toString());
          debugPrint(s?.toString() ?? StackTrace.current.toString());
        }

        break;
      case LogLevel.warning:
        tag = "[WARNING]";

        debugPrint("${_timestamp()} [WARNING]  $message");
        if (e != null) {
          debugPrint(e.toString());
          debugPrint(s?.toString() ?? StackTrace.current.toString());
        }
        break;
      case LogLevel.error:
        tag = "[ERROR]";

        debugPrint("${_timestamp()} [ERROR]  $message");
        if (e != null) {
          debugPrint(e.toString());
        }
        // Errors always show a StackTrace
        debugPrint(s?.toString() ?? StackTrace.current.toString());
        break;
    }
  }
}

/// Logger that reports to Crashlytics/Firebase
class CrashlyticsLoggerClient implements LoggerClient {
  final log = LoggingIntegration.Logger('CrashlyticsLoggerClient');

  @override
  onLog({
    required LogLevel level,
    required String message,
    required dynamic e,
    StackTrace? s,
  }) {
    final instance = FirebaseCrashlytics.instance;
    switch (level) {
      case LogLevel.debug:
        break;
      case LogLevel.warning:
        instance.log("[WARNING] $message");
        if (e != null) {
          instance.log(e.toString());
          instance.log(s?.toString() ?? StackTrace.current.toString());
        }
        break;
      case LogLevel.error:
        instance.log("[ERROR] $message");
        if (e != null) {
          instance.recordError(e, s);
          log.severe(message, e, s);
          //     Sentry.captureException(e, stackTrace: s);
        } else {
          instance.recordError(Exception(message), s);
          log.severe(message, Exception(message), s);
          //   Sentry.captureException(Exception(message), stackTrace: s);
        }
        break;
    }
  }
}

class LogService {
  final List<LogServiceParam> _logHistory = [];

  List<LogServiceParam> get logHistory => _logHistory;

  log(String type, String message, String time) {
    _logHistory.insert(0, LogServiceParam(type, message, time));
  }

  clear() {
    _logHistory.clear();
  }
}

class LogServiceParam {
  String type;
  String message;
  String time;
  bool expanded = false;

  Color get color {
    print(type);

    switch (type) {
      case "[DEBUG]":
        return Colors.blue;
      case "[WARNING]":
        return Colors.yellow;
      case "[ERROR]":
        return Colors.red;
      default:
        return AppColors.darkJungleBlackColor;
    }
  }

  LogServiceParam(this.type, this.message, this.time);
}
