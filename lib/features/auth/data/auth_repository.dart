import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yoloworks_invoice/features/auth/models/organization_model.dart';
import '../../../api/auth_request.dart';
import '../../../locator.dart';
import '../models/organization_info_model.dart';

class AuthRepository {
  final AuthRequest authRequest;
  AuthRepository({required this.authRequest});

  Future<OrganizationModel> getUserOrganization() =>
      apiBaseService.request<OrganizationModel>(
          authRequest.getUserOrganization(),
          (data) => OrganizationModel.fromJson(data));

  Future<OrganizationInfoModel> getOrganizationInfo() =>
      apiBaseService.request<OrganizationInfoModel>(
          authRequest.getOrganizationInfo(),
          (data) => OrganizationInfoModel.fromJson(data));
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(authRequest: AuthRequest());
});
