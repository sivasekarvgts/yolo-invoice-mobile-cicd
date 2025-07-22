import 'error_model.dart';

class ApiException implements Exception {
  ApiException(this.error);

  final ErrorResponse error;

  @override
  String toString() {
    return error.toString();
  }
}
