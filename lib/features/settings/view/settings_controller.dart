import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../locator.dart';
import '../../../router.dart';
import '../../../services/dialog_service/alert_response.dart';

part 'settings_controller.g.dart';

@riverpod
class SettingsController extends _$SettingsController
{
  @override
  AsyncValue<void> build() {
    return AsyncValue.loading();
  }

  AsyncValue<void> get setState => state = AsyncValue.data(null);

  AsyncValue<void> get setLoading => state = AsyncValue.loading();


  void showLogOutConfirm() async {
    AlertResponse? response = await dialogService.showConfirmationAlertDialog(
      secondaryButton: 'No',
      primaryButton: "Yes",
      title: "Are you sure you want to\nLog out?",
    );
    if (response?.status == true) {
      preferenceService.clear();
      navigationService.popAllAndPushNamed(Routes.login);
    }
  }
}