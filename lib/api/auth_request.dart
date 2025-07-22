import '../core/models/request_setting.dart';
import '../core/enums/request_method.dart';

class AuthRequest {
  RequestSettings getUserOrganization() {
    return RequestSettings("organization/user-info/", RequestMethod.GET,
        params: null, authenticated: true);
  }

  RequestSettings getOrganizationInfo() {
    return RequestSettings("core/organization-info/", RequestMethod.GET,
        params: null, authenticated: true, useOrgBaseUrl: true);
  }
}
