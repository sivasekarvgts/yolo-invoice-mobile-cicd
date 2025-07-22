
import '../enums/request_method.dart';

class RequestSettings {
  String endPoint;
  bool authenticated;
  bool useOrgBaseUrl;
  RequestMethod method;
  dynamic params;

  RequestSettings(this.endPoint, this.method, { this.params, this.useOrgBaseUrl=false, this.authenticated = true });
}