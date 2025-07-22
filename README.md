# yoloworks_invoice

A new Flutter project.

## Getting Started

---

## TODO
- [-] WareHouse Enabled  & price List check
- [-] FOC 
- [-] Font style
- [-] Bottom button - Outline 
- [-] Cannot use "ref" after the widget was disposed.
- [-] payment ref
- [-] Item Detail
- [-] Invoice create , tcs/tds added to subtotal 
- [-] Foc Not working
- [-] Other Expense Id Validate


- [ ] Git Workflow - IOS


## TO CHECK
- [ ] [hasInventory = true](In item create)
- [ ] [reorder_point = 2](In item create)
- [ ] [item_tracking = 1](In item create)
- [ ] [is_auto_increment = false](In item create)

- [ ] [activateInventoryItem = res incorrect](In item detail api)

- [ ] [Account mapping --- accountCode is used (changed to code)](in item create and update )



---
# Project Folder Structure

```
/ (root)
├── android/
│   ├── app/
│   ├── .gradle/
│   ├── .kotlin/
│   ├── fastlane/
│   ├── gradle/
│   └── ...
├── assets/
│   ├── fonts/
│   │   └── manrope/
│   ├── images/
│   ├── logos/
│   ├── lottie_json/
│   └── svg/
├── build/
│   ├── app/
│   ├── ios/
│   ├── macos/
│   ├── sentry_flutter/
│   └── ...
├── ios/
│   ├── Runner.xcodeproj/
│   ├── Runner.xcworkspace/
│   ├── Pods/
│   ├── Flutter/
│   ├── Runner/
│   ├── RunnerTests/
│   └── ...
├── lib/
│   ├── api/
│   ├── app/
│   │   ├── common_widgets/
│   │   ├── constants/
│   │   └── styles/
│   ├── core/
│   │   ├── enums/
│   │   ├── errors/
│   │   ├── extension/
│   │   └── models/
│   ├── features/
│   │   ├── auth/
│   │   ├── bill_preview/
│   │   ├── charts_of_account/
│   │   ├── dashboard/
│   │   ├── item/
│   │   ├── others/
│   │   ├── payment/
│   │   ├── purchase/
│   │   ├── reports/
│   │   ├── sales/
│   │   ├── settings/
│   │   └── transactions/
│   ├── services/
│   │   ├── appconfig_service/
│   │   ├── dialog_service/
│   │   ├── logger/
│   │   ├── payment_services/
│   │   └── sales_purchase_master_services/
│   ├── utils/
│   │   ├── firebase_options/
│   │   └── ...
│   ├── bootstrap.dart
│   ├── locator.dart
│   ├── main.dart
│   └── router.dart
├── linux/
│   ├── flutter/
│   ├── runner/
│   └── ...
├── macos/
│   ├── Flutter/
│   ├── Runner/
│   ├── RunnerTests/
│   ├── Runner.xcodeproj/
│   └── Runner.xcworkspace/
├── test/
├── web/
│   ├── icons/
│   ├── splash/
│   │   └── img/
│   ├── favicon.png
│   ├── index.html
│   └── manifest.json
├── windows/
│   ├── flutter/
│   ├── runner/
│   └── ...
├── .dart_tool/
├── .github/
│   └── workflows/
├── .idea/
├── .vscode/
├── pubspec.yaml
├── pubspec.lock
├── shorebird.yaml
├── analysis_options.yaml
├── devtools_options.yaml
└── README.md
```



## Logging Utilities and Log Files

This project uses a custom logging system, primarily implemented in `lib/utils/logger.dart` and `lib/services/logger/logger_service.dart`.

### Key Files:
- **lib/utils/logger.dart**: Core logger utility. Supports debug, warning, and error logs. Logs can be routed to console (in debug) or to Firebase Crashlytics (in production). Maintains an in-memory log history for UI display.
- **lib/services/logger/logger_service.dart**: Provides UI widgets to view logs in-app, including search and detail views. Uses Riverpod for state management.
- **lib/utils/dialog_manager.dart**: Integrates a floating action button to open the log viewer screen from anywhere in the app.
- **lib/services/api_service.dart**: Uses the logger to log network requests and errors.
- **lib/bootstrap.dart**: Configures the logger at app startup.

### Log Viewing:
- Logs are viewable in-app via a floating button (see `DialogManager`) that opens the log viewer (`ShowLogMessages`).
- Log details can be copied to clipboard from the UI.
- Log history is kept in memory (not persisted to disk).

### Log Routing:
- **Debug mode**: Logs are printed to the console.
- **Production mode**: Logs and errors are sent to Firebase Crashlytics.

### Analytics:
- There is also an `analytics_service.dart` (commented out) for event and screen logging to Firebase Analytics and Mixpanel.

---
