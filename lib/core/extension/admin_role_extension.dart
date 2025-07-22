import '../../features/auth/models/organization_model.dart';

extension RoleModelExtensions on RoleModel? {
  bool get isAdminRole {
    final code = this?.roleCode ?? 0;
    return code == 1 || code == 2 || code == 3;
  }
}

