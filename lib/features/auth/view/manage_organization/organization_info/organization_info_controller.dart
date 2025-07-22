import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/auth_repository.dart';
import '../../../models/organization_info_model.dart';

part 'organization_info_controller.g.dart';

@riverpod
class OrganisationInfoController extends _$OrganisationInfoController {
  @override
  AsyncValue<void> build() {
    return AsyncValue.data(null);
  }

  OrganizationInfoModel? organizationInfo;
  AsyncValue<void> get setState => state = AsyncValue.data(null);
  AsyncValue<void> get setLoading => state = AsyncValue.loading();

  Future<void> fetchData({bool? refresh}) async {
    try {
      if (refresh == true) {
        organizationInfo = null;
      }
      if (organizationInfo == null) {
        state = const AsyncValue.loading();
      }
      organizationInfo =
          await ref.read(authRepositoryProvider).getOrganizationInfo();
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
    state = AsyncValue.data(null);
  }
}
