This file contains project-specific information and guidelines for the Gemini agent.

- **Project Overview:** This is a Flutter-based mobile application for YoloWorks Invoice. It allows users to manage invoices, clients, and other business-related tasks.

- **Tech Stack:**
  - **Framework:** Flutter
  - **Language:** Dart
  - **State Management:** flutter_riverpod
  - **Networking:** dio, http
  - **Routing:** persistent_bottom_nav_bar
  - **Logging:** sentry, mixpanel
  - **Firebase:** Core, Crashlytics, Remote Config
  - **UI Libraries:** shimmer, lottie, flutter_svg, syncfusion_flutter_charts

- **Build & Run:**
  - To run the app in debug mode, use: `flutter run --flavor dev`
  - To build the app for release, use the appropriate build command for the target platform (e.g., `flutter build apk --release --flavor prod`).

- **Coding Style:** (Please fill in any specific coding conventions or style guides used in the project)

- **Important Notes:**
  - The project uses a custom plugin `vgts_plugin` from a git repository.
  - The project is structured by features, with core functionalities in the `core` directory and feature-specific modules in the `features` directory.
  - Service location is handled by a locator, likely configured in `lib/locator.dart`.

- **Gemini Agent Guidelines:**
  - This `GEMINI.md` file should be updated with any important, project-specific information provided by the user. When the user provides a new piece of information that is relevant to the project's context, update this file to reflect that information.