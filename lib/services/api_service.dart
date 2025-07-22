import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:yoloworks_invoice/app/styles/colors.dart';
import '../../core/enums/request_method.dart';
import '../../core/errors/error_model.dart';
import '../../core/errors/error_response_exception.dart';
import '../../core/errors/no_reponse_exception.dart';
import '../../core/models/request_setting.dart';
import '../../locator.dart';
import '../../services/event_bus_service.dart';
import 'dialog_service/snackbar_service.dart';
import '../../utils/api_base_helper.dart';
import '../utils/logger.dart';

class ApiBaseService extends ApiBaseHelper {
  final Dio _dio = Dio()
    ..interceptors.add(PrettyDioLogger(
        error: true,
        request: true,
        requestBody: true,
        responseBody: true,
        requestHeader: true));

  Future<List<T>> requestList<T>(
      RequestSettings settings, List<T> Function(dynamic data) builder) async {
    try {
      var response = await _sendAsync(
          getMethod(settings.method), settings.endPoint, settings.params,
          authenticated: settings.authenticated,
          useOrgBaseUrl: settings.useOrgBaseUrl);
      if (response != null) {
        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202) {
          return builder(response.data);
        }
      }
    } on TimeoutException {
      _showDialog('Server Error', "There is a problem connecting server");
    } on ErrorResponseException catch (exception) {
      throw ErrorResponseException(error: exception.error);
    } catch (exception, stacktrace) {
      Logger.e(exception.toString(), e: exception, s: stacktrace);
    }
    throw NoResponseException(
      message: "No Response: something went wrong",
    );
  }

  Future<T> request<T>(
      RequestSettings settings, T Function(dynamic data) builder) async {
    try {
      var response = await _sendAsync(
          getMethod(settings.method), settings.endPoint, settings.params,
          authenticated: settings.authenticated,
          useOrgBaseUrl: settings.useOrgBaseUrl);
      if (response != null) {
        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202) {
          return builder(response.data);
        }
      }
    } on TimeoutException {
      _showDialog('Server Error', "There is a problem connecting server");
    } on ErrorResponseException catch (exception) {
      throw ErrorResponseException(error: exception.error);
    } catch (exception, stacktrace) {
      Logger.e(exception.toString(), e: exception, s: stacktrace);
    }
    throw NoResponseException(
      message: "No Response: something went wrong",
    );
  }



  Future<Response?> _sendAsync(String method, String endPoint, Object? body,
      {Map<String, String>? queryParams,
      bool authenticated = true,
      required bool useOrgBaseUrl}) async {
    String baseUrl = appConfigService.config.baseApiUrl!;
    if (useOrgBaseUrl) {
      baseUrl = appConfigService.config.organizationApiUrl!;
    }

    endPoint = endPoint.startsWith("http") ? endPoint : baseUrl + endPoint;
    var url = Uri.parse(endPoint +
        (queryParams != null ? Uri(queryParameters: queryParams).query : ""));
    Logger.d(url.toString());
    //analyticsService.timerEvent(url.path);

    if (!endPoint.endsWith('/')) {
      endPoint + "/";
    }

    // Create Dio Request Options
    RequestOptions options = RequestOptions(
      baseUrl: baseUrl,
      queryParameters: queryParams != null ? queryParams : {},
      method: method,
      headers: await _headers(body, authenticated),
      // data: jsonEncode(body),
      connectTimeout: Duration(seconds: 15),
      persistentConnection: true,
      receiveTimeout: Duration(seconds: 15),
      path: endPoint,
    );

    // Add Body Content to Request
    if (body is FormData) {
      options.contentType = Headers.formUrlEncodedContentType;
    } else if (body != null) {
      options.data = jsonEncode(body);
      options.contentType = Headers.jsonContentType;
    }

    // Declared Dio Response Object
    Response? response;

    // Send Request using Dio
    try {
      response = await _dio.fetch(options);
      //analyticsService.logNetwork(url.path, method, body, response.data);
      eventBusService.eventBus
          .fire(GlobalMessageHandler("Success", show: false));
      Logger.d(
          'BASE URL => ${options.baseUrl}\n\nEND POINT => ${options.path}\n\nMETHOD => ${options.method}\n\nHEADER => ${options.headers}\n\nBODY => ${options.data}\n\nRESPONSE DATA => ${response.data} ');
      Logger.d('response data => ${response.data}');
      return response;
    } on DioException catch (exception, stacktrace) {
      Logger.d("ERROR EXCEPTION $exception", e: exception, s: stacktrace);
      return _handleDioError(exception);
    } on PlatformException catch (error) {
      Logger.e("Platform Exception: ${error.message}",
          e: error, s: StackTrace.current);
      // TODOS
      // return _handlePlatformError(error);
      // Return appropriate error response
    } catch (error) {
      Logger.e("Dio Error: ${error.toString()}", s: StackTrace.current);
      throw Exception("Network Error"); // More specific error message
    }
    return null;
  }

  Future<T> dioMultiPartRequest<T>(File imageFile, RequestSettings settings,
      T Function(dynamic data) builder) async {
    try {
      print(imageFile);
      if (!imageFile.existsSync()) {
        throw Exception("File does not exist");
      }
      String fileName = imageFile.path.split('/').last;
      print(fileName);
      FormData formData = FormData.fromMap({
        "upload":
            await MultipartFile.fromFile(imageFile.path, filename: fileName),
      });
      String baseUrl = appConfigService.config.baseApiUrl!;
      String endPoint = settings.endPoint.startsWith("http")
          ? settings.endPoint
          : baseUrl + settings.endPoint;
      Options options = Options(
          method: "PUT",
          headers: await _headers(formData, true),
          persistentConnection: true,
          receiveTimeout: Duration(seconds: 15));
      Response? response = await _dio.put(
        endPoint,
        data: formData,
        options: options,
      );
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        return builder(response.data);
      }
    } on ErrorResponseException catch (exception) {
      throw ErrorResponseException(error: exception.error);
    } catch (exception, stacktrace) {
      Logger.e(exception.toString(), e: exception, s: stacktrace);
    }
    throw NoResponseException(
      message: "No Response: something went wrong",
    );
  }

  // Add Headers according to [body] Object Type
  // Add Authentication Token if [authenticated] is true
  Future<Map<String, String>> _headers(Object? body, bool authenticated) async {
    Map<String, String> headerParams = {};
    headerParams[Headers.contentTypeHeader] = "application/json";

    if (body is String) {
      headerParams[HttpHeaders.contentTypeHeader] =
          "application/x-www-form-urlencoded";
    } else if (body is Map || body is List) {
      headerParams[Headers.acceptHeader] = "application/json";
      headerParams[Headers.contentTypeHeader] = "application/json";
    } else if (body is FormData) {
      headerParams[Headers.acceptHeader] = "application/json";
      headerParams[Headers.contentTypeHeader] = "multipart/form-data";
    }

    if (authenticated) {
      headerParams[HttpHeaders.authorizationHeader] =
          "Passcode ${preferenceService.getBearerToken()}";
    }
    if (preferenceService.getUserOrg() != null) {
      headerParams["organization"] = "${preferenceService.getUserOrg()?.id}";
    }

    try {
      Map<String, String>? deviceHeader =
          await deviceService.getDeviceInfoHeaders();
      if (deviceHeader != null) {
        headerParams.addAll(deviceHeader);
      }
      headerParams['app-version'] = deviceService.version!;
    } catch (ex, s) {
      Logger.e("App Version Error: ${ex.toString()}", s: s);
    }

    return headerParams;
  }

  void _showDialog(String title, String description) {
    return SnackbarService.showSnackBar(
      title: title,
      msg: description,
      color: AppColors.redColor,
    );
  }

  void _handleUnauthorizedResponse() {
    Fluttertoast.showToast(msg: "Your session has expired. Please login again");
    Logger.e("Response Status Code: 401", s: StackTrace.current);
    //analyticsService.logEvent("Logout", {});
    preferenceService.pref.clear();
  }

  Future<ErrorResponse?> _handleApiError(
      Response response, bool showDialog) async {
    ErrorResponse? error = await handleApiError(response, false);
    
    if (showDialog && error != null) {
      _showDialog("Alert !", error.error ?? '');
    }
    return error;
  }

  Future<Response?> _handleDioError(DioException dioErro) async {
    switch (dioErro.type) {
      case DioExceptionType.cancel:
        Logger.e("Request to API server was cancelled", s: dioErro.stackTrace);
        break;
      case DioExceptionType.unknown:
        Logger.e("Request to API server was cancelled", s: dioErro.stackTrace);
        _handleUnauthorizedResponse();
        break;
      case DioExceptionType.connectionTimeout:
        Logger.e("Connection timeout with API server", s: dioErro.stackTrace);
        break;
      case DioExceptionType.connectionError:
        Logger.e("Connection to API server failed due to internet connection",
            s: dioErro.stackTrace);
        showToast('Connection to API server failed due to internet connection',
            context: navigationService.navigatorKey.currentContext);
        break;
      case DioExceptionType.receiveTimeout:
        Logger.e("Receive timeout in connection with API server",
            s: dioErro.stackTrace);
        break;
      case DioExceptionType.badResponse:
        var error = await _handleApiError(
            dioErro.response!, dioErro.response?.statusCode != 400);
        throw ErrorResponseException(error: error);
      case DioExceptionType.sendTimeout:
        Logger.e("Send timeout in connection with API server",
            s: dioErro.stackTrace);
        break;
      default:
        throw Exception("Something went wrong: ${dioErro.message}");
    }
    return null;
  }
}

String getMethod(RequestMethod requestMethod) {
  switch (requestMethod) {
    case RequestMethod.POST:
      return "POST";
    case RequestMethod.GET:
      return "GET";
    case RequestMethod.PATCH:
      return "PATCH";
    case RequestMethod.PUT:
      return "PUT";
    case RequestMethod.DELETE:
      return "DELETE";
  }
}
