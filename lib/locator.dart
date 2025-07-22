import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../bootstrap.dart';
import '../../services/api_service.dart';
import '../../services/appconfig_service/appconfig_service.dart';
import '../../services/device_service.dart';
import '../../services/dialog_service/dialog_service.dart';
import '../../services/event_bus_service.dart';
import '../../services/navigation_service.dart';
import '../../services/network_service.dart';
import '../../services/preference_service.dart';
import '../../utils/logger.dart';
import '../../utils/provider_observer.dart';
import '../../utils/update_checker.dart';
import 'app/common_widgets/network_image_loader.dart';

final providerContainer = ProviderContainer(observers: [MyObserver()]);

final appConfigService = providerContainer.read(_appConfigServiceProvider);
final loggerService = providerContainer.read(_loggerServiceProvider);
final preferenceService = providerContainer.read(_preferenceServiceProvider);
final dialogService = providerContainer.read(_dialogServiceProvider);
final deviceService = providerContainer.read(_deviceServiceProvider);
//final analyticsService = providerContainer.read(_analyticsServiceProvider);
final eventBusService = providerContainer.read(_eventBusServiceProvider);
final networkService = providerContainer.read(_networkServiceProvider);
final updateCheckerService = providerContainer.read(_updateCheckerProvider);
final navigationService = providerContainer.read(_navigationServiceProvider);
final apiBaseService = providerContainer.read(_apiBaseServiceProvider);
final businessIndividualImages =
    providerContainer.read(_businessIndividualImages);
final bootStrap = providerContainer.read(_bootStrapProvider);

// Providers for Dependency Injection
final _appConfigServiceProvider =
    Provider<AppConfigService>((ref) => AppConfigService());
final _loggerServiceProvider = Provider<LogService>((ref) => LogService());
final _preferenceServiceProvider =
    Provider<PreferenceService>((ref) => PreferenceService());
final _dialogServiceProvider =
    Provider<DialogService>((ref) => DialogService());
final _deviceServiceProvider =
    Provider.autoDispose<DeviceService>((ref) => DeviceService());
//final _analyticsServiceProvider =  Provider<AnalyticsService>((ref) => AnalyticsService());
final _eventBusServiceProvider =
    Provider<EventBusService>((ref) => EventBusService());
final _networkServiceProvider =
    Provider<NetworkService>((ref) => NetworkService());
final _updateCheckerProvider =
    Provider.autoDispose<UpdateChecker>((ref) => UpdateChecker());
final _navigationServiceProvider =
    Provider<NavigationService>((ref) => NavigationService());
final _apiBaseServiceProvider =
    Provider<ApiBaseService>((ref) => ApiBaseService());
final _businessIndividualImages =
    Provider<BusinessIndividualImages>((ref) => BusinessIndividualImages());
final _bootStrapProvider =
    Provider.autoDispose<Bootstrap>((ref) => Bootstrap());
