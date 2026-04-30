# GitHub Copilot Instructions

This document provides guidance for GitHub Copilot when working on this Flutter project.

## Project Overview

This is a Flutter application (PRF Missions) created with Very Good CLI. The app supports multiple platforms (iOS, Android, Web, and Windows) and uses a feature-based architecture with BLoC state management.

## Architecture

- **State Management**: Flutter BLoC pattern with `flutter_bloc` package
- **Routing**: Auto Route (`auto_route` package)
- **Dependency Injection**: GetIt service locator
- **Code Generation**: Uses `build_runner` for code generation (freezed, json_serializable, auto_route)
- **Local Storage**: Hive for local data persistence, Isar for complex queries
- **Backend Communication**: Dio for HTTP requests, Pusher Channels for WebSocket

## Project Structure

```
lib/
├── app/                    # App initialization and configuration
├── bootstrap.dart          # App bootstrap logic
├── features/              # Feature modules (auth, home, etc.)
├── models/                # Data models
├── services/              # Business logic services
├── shared_widgets/        # Reusable UI components
├── utils/                 # Utility functions and helpers
├── l10n/                  # Localization files
├── main_development.dart  # Development flavor entry point
├── main_staging.dart      # Staging flavor entry point
└── main_production.dart   # Production flavor entry point
```

## Coding Conventions

### Code Style

- Follow `very_good_analysis` linting rules (version 9.0.0)
- Use `dart format` for formatting
- Public API documentation is disabled (`public_member_api_docs: false`)
- Avoid catches without `on` clauses where possible

### File Organization

- Use barrel files (`_index.dart`) to export multiple files from a directory
- Generated files have `.g.dart`, `.freezed.dart` extensions and are excluded from analysis
- Feature modules should be self-contained with their own models, BLoCs, and UI

### State Management

- Use BLoC/Cubit for state management
- Register cubits/blocs in the appropriate singletons registry
- Follow BLoC best practices: single responsibility, testing, etc.

### Code Generation

Always run code generation after modifying:
- Data models with `@freezed` or `@JsonSerializable` annotations
- Route configurations with `@AutoRoute`
- Localization files (`.arb` files)

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Flavors

The project has 3 flavors:

- **development**: Local/development environment
- **staging**: Staging environment
- **production**: Production environment

Each flavor has its own:
- Main entry point (`main_<flavor>.dart`)
- Configuration (API endpoints, socket domains, etc.)
- Firebase configuration
- App icons

When adding new configuration, ensure all three flavors are updated consistently.

## Localization

- All user-facing strings must be localized
- Add strings to `lib/l10n/arb/app_en.arb`
- Run `flutter gen-l10n --arb-dir="lib/l10n/arb"` after changes
- Access translations via `context.l10n` extension

Example:
```dart
import 'package:app/l10n/l10n.dart';

Text(context.l10n.helloWorld)
```

## Testing

- Run tests with: `flutter test --coverage --test-randomize-ordering-seed random`
- Use `mocktail` for mocking in tests
- Use `bloc_test` for testing BLoCs/Cubits
- Aim to maintain test coverage as indicated by the coverage badge

## Dependencies

### Key Packages

- **UI**: `flutter_animate`, `wolt_modal_sheet`, `google_fonts`, `flutter_svg`
- **Forms**: `flutter_datetime_picker_plus`, `intl_phone_number_input`
- **Media**: `extended_image`, `video_player`, `record`, `wechat_assets_picker`
- **Firebase**: Full Firebase suite (Analytics, Auth, Crashlytics, Messaging, Remote Config)
- **Notifications**: `awesome_notifications`
- **Updates**: `shorebird_code_push` for over-the-air updates

### Adding Dependencies

When adding new dependencies:
1. Add to `pubspec.yaml`
2. Run `flutter pub get`
3. If it requires platform-specific setup, update iOS (`ios/Podfile`) and Android configurations
4. Update all flavor configurations if the dependency requires API keys or configuration

## Platform-Specific Notes

### iOS

- Minimum version: iOS 15.0
- Custom Podfile modifications for Awesome Notifications
- Uses modular headers and frameworks

### Android

- Check `android/` directory for platform-specific configurations
- Permissions configured via `permission_handler`

## Common Tasks

### Running the App

```bash
# Development
flutter run --flavor development --target lib/main_development.dart

# Staging
flutter run --flavor staging --target lib/main_staging.dart

# Production
flutter run --flavor production --target lib/main_production.dart
```

### Code Generation

```bash
# Generate code (routes, models, serialization)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for continuous generation
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Localization

```bash
# Generate localizations
flutter gen-l10n --arb-dir="lib/l10n/arb"
```

### Assets

```bash
# Generate app icons for all flavors
flutter pub run icons_launcher:create
flutter pub run flutter_launcher_icons

# Generate splash screens
flutter pub run flutter_native_splash:create
```

## Best Practices

1. **Never commit secrets**: Configuration values in main files may contain placeholders, never commit real API keys or secrets
2. **Use freezed for immutable models**: Prefer `@freezed` classes for data models
3. **Dependency injection**: Register services in GetIt, access via `GetIt.instance`
4. **Error handling**: Use Firebase Crashlytics for production error tracking
5. **Analytics**: Use Firebase Analytics for tracking user events
6. **Feature flags**: Use Firebase Remote Config for feature toggles
7. **Navigation**: Use Auto Route's declarative routing
8. **Responsive UI**: Use `flutter_adaptive_ui` for platform-adaptive widgets
9. **Animations**: Use `flutter_animate` for smooth animations
10. **Null safety**: All code should be null-safe

## When in Doubt

- Check existing patterns in the codebase before adding new approaches
- Follow Flutter and Dart best practices
- Consult the README.md for additional project-specific information
- Refer to `analysis_options.yaml` for linting rules
