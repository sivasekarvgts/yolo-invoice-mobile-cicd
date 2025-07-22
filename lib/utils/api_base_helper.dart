import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../core/errors/error_model.dart';

class ApiBaseHelper {
  // SERIALIZE & ASYNC FUNCTION
  @protected
  String serialize(Object? obj) {
    String serialized = '';
    if (obj == null) {
      serialized = '';
    } else {
      serialized = json.encode(obj);
    }
    return serialized;
  }

  @protected
  ErrorResponse handleConnectionError() {
    var result =
        ErrorResponse(error: "There is a problem connecting to the server.");
    return result;
  }

  @protected
  Future<ErrorResponse?> handleApiError(
      Response response, bool tokenError) async {
    final statusCode = response.statusCode ?? 0;
    if ((tokenError && statusCode == 400) || statusCode == 401) {
      return null;
    }

    if ((statusCode) >= 500)
      return ErrorResponse.fromJson("Server Exception", data: response);
    if (response.data != null) {
      return ErrorResponse.fromJson(
          ((response.data is List) ? response.data : response.data["message"])
              .toString(),
          data: response);
    }
    return ErrorResponse.fromJson("Server Exception, Something went wrong!!!.",
        data: response);
  }
}
