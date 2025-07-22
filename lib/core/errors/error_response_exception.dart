import 'error_model.dart';

class ErrorResponseException {
  ErrorResponse? error;

  ErrorResponseException({this.error});

  @override
  String toString() {
    return 'ErrorResponseException{error: $error}';
  }
}
