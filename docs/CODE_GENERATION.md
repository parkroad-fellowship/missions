# Code Generation Guide

This document explains the code generation workflow using Freezed, build_runner, and other generators.

## Overview

The app uses several code generators:

| Generator | Purpose | File Suffix |
|-----------|---------|-------------|
| `freezed` | Immutable data classes, unions | `.freezed.dart` |
| `json_serializable` | JSON serialization | `.g.dart` |
| `isar_generator` | Isar database schemas | `.g.dart` |
| `auto_route_generator` | Navigation routes | `.gr.dart` |

## Running Code Generation

### One-time Build

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Watch Mode (Development)

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

## Freezed Patterns

### Data Classes

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required int id,
    required String name,
    String? email,
    @Default(false) bool isActive,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

### Union Types (States)

```dart
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.authenticated({required User user}) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
}
```

### Custom Methods on Freezed Classes

```dart
@freezed
class User with _$User {
  const User._(); // Private constructor for custom methods

  const factory User({
    required String firstName,
    required String lastName,
  }) = _User;

  // Custom getter
  String get fullName => '$firstName $lastName';

  // Custom method
  bool isValid() => firstName.isNotEmpty && lastName.isNotEmpty;
}
```

## Isar Models

### Basic Collection

```dart
import 'package:isar/isar.dart';

part 'prf_mission.g.dart';

@collection
class PRFMission {
  Id? id;

  @Index()
  late int remoteId;

  late String name;
  late String description;

  @Index()
  late DateTime startDate;

  late DateTime? endDate;
}
```

### Embedded Objects

```dart
@embedded
class PRFLocation {
  late String? address;
  late double? latitude;
  late double? longitude;
}

@collection
class PRFMission {
  Id? id;
  late PRFLocation? location;
}
```

### Relationships

```dart
@collection
class PRFMission {
  Id? id;
  late String name;

  // Link to related collection
  final sessions = IsarLinks<PRFMissionSession>();
}
```

## Auto Route

### Defining Routes

```dart
// lib/utils/router/router.dart
import 'package:auto_route/auto_route.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SignInRoute.page, path: '/sign-in'),
    AutoRoute(
      page: HomeRoute.page,
      path: '/',
      children: [
        AutoRoute(page: LandingRoute.page, path: ''),
        AutoRoute(page: MissionsRoute.page, path: 'missions'),
        AutoRoute(page: MissionDetailsRoute.page, path: 'missions/:id'),
      ],
    ),
  ];
}
```

### Page Annotation

```dart
@RoutePage()
class MissionsPage extends StatelessWidget {
  const MissionsPage({super.key});

  @override
  Widget build(BuildContext context) => const MissionsView();
}
```

## Troubleshooting

### Conflicting Outputs

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Clean and Rebuild

```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Missing Part Directive

If you see "Missing 'part of' directive":

```dart
// Ensure the part file is generated and includes:
part of 'your_file.dart';
```

### Analyzer Errors After Generation

Run `flutter pub get` after code generation:

```bash
flutter pub run build_runner build --delete-conflicting-outputs && flutter pub get
```

## Best Practices

### 1. Commit Generated Files

Generated files (`.freezed.dart`, `.g.dart`, `.gr.dart`) should be committed to version control to ensure consistent builds.

### 2. Use Part Directives Correctly

```dart
// my_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_model.freezed.dart'; // For freezed
part 'my_model.g.dart';       // For json_serializable
```

### 3. JSON Field Names

```dart
@freezed
class User with _$User {
  const factory User({
    required int id,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

### 4. Default Values

```dart
@freezed
class Settings with _$Settings {
  const factory Settings({
    @Default(false) bool darkMode,
    @Default('en') String locale,
    @Default([]) List<String> favorites,
  }) = _Settings;
}
```

### 5. Nullable vs Required

```dart
@freezed
class Profile with _$Profile {
  const factory Profile({
    required String id,        // Always required
    required String name,      // Always required
    String? bio,              // Optional (nullable)
    @Default('') String website, // Optional with default
  }) = _Profile;
}
```

## IDE Support

### VS Code

Install the "Dart Data Class Generator" extension for snippets.

### IntelliJ/Android Studio

Enable "Generate Code" action in preferences.

### Recommended Workflow

1. Write the class definition
2. Add required imports and parts
3. Run `flutter pub run build_runner build`
4. Restart analyzer if needed
