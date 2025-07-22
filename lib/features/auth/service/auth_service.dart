import 'package:sentry_flutter/sentry_flutter.dart' as sentry;
import 'package:yoloworks_invoice/api/auth_request.dart';
import 'package:yoloworks_invoice/features/auth/data/auth_repository.dart';
import 'package:yoloworks_invoice/locator.dart';
import 'package:yoloworks_invoice/router.dart';
import '../models/organization_model.dart';
import '../models/user_model.dart';

class AuthenticationService {
  UserModel? _userModel;

  UserModel? get userModel => _userModel;

  bool get isAuthenticated =>
      preferenceService.getUserInfo() != null &&
      preferenceService.getUserInfo()!.passcode != null &&
      preferenceService.getUserInfo()!.passcode!.isNotEmpty;

  Future<bool> login({bool redirectOnSuccess = true}) async {
    UserModel? userModel = await navigationService.pushNamed(Routes.authWeb);
    if (userModel == null) return false;
    await preferenceService.setUserInfo(userModel);
    await preferenceService.setBearerToken(userModel.passcode ?? "");
    // _mixPanel.setUserDetails({
    //   'id': userModel.id,
    //   'phone': userModel.phone,
    //   'email': userModel.email,
    //   'name': '${userModel.firstName}${userModel.lastName}'
    // });
    final orgs =
        await AuthRepository(authRequest: AuthRequest()).getUserOrganization();
    final organizations = _setOrganization(orgs);

    _configureSentryUserScope();
    if (_isOrganizations(organizations)) {
      await preferenceService.setUserOrg(organizations![0]);
    } else {
      navigationService.popAndPushNamed(Routes.selectOrganization);
    }

    if (redirectOnSuccess) {
      navigate(_isOrganizations(organizations));
      // _authRepo.navigate();
    }
    return true;
  }

  bool _isOrganizations(List<Organization>? organizations) =>
      organizations != null &&
      organizations.isNotEmpty &&
      organizations.length == 1;

  List<Organization>? _setOrganization(OrganizationModel organizationModel) {
    List<Organization>? organizationsList = organizationModel.organization;
    return organizationsList;
  }
  // List<Organization>? _setOrganization(
  //     Either<AppError, OrganizationModel> organization) {
  //   List<Organization>? organizationsList = [];
  //   organization.fold((l) => Logger.d( 'error => ${l}'),
  //           (r) => organizationsList = r.organization);
  //   return organizationsList;
  // }

  Future _configureSentryUserScope() async {
    if (!isAuthenticated) {
      return await sentry.Sentry.configureScope((scope) => scope.setUser(null));
    }
    return await sentry.Sentry.configureScope(
      (scope) => scope.setUser(sentry.SentryUser(
          id: userModel?.id.toString(),
          email: userModel?.email,
          username: userModel?.username,
          name: "${userModel?.username ?? ''} ${userModel?.lastName ?? ''}",
          data: {
            'phone': userModel?.phone,
            'gender': userModel?.gender,
            'country': userModel?.country
          })),
    );
  }

  Future navigate(bool isOneOrgs) async {
    if (isAuthenticated) {
      // return  navigationService.popAllAndPushNamed(isOneOrgs? Routes.dashboard:Routes.selectOrg);
      await authNavigate();
      return;
      // Get.offAllNamed(
      //   isOneOrgs
      //       ? RoutesConstant.sodScreen
      //       : RoutesConstant.selectOrganization,
      //   arguments: isOneOrgs ? {'isSod': true} : {});
    }
    return navigationService.popAllAndPushNamed(Routes.login);
  }

  Future authNavigate() async {
    final selectedOrg = preferenceService.getUserOrg();
    // debugPrint(selectedOrg.toString());
    // final selectedOrg = organizationFromJson(orgs);
    if (selectedOrg == null) {
      navigationService.popAllAndPushNamed(Routes.selectOrganization);
      return;
    } else if (selectedOrg.id!.isNotEmpty || selectedOrg.id != "") {
      navigationService.popAllAndPushNamed(Routes.dashboard);
      return;
    }
  }
}
