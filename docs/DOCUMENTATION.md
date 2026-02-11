# PRF Super App Documentation

## Table of Contents

1. [Overview](#overview)
2. [Project Structure](#project-structure)
3. [Architecture Layers](#architecture-layers)
4. [Folder Conventions](#folder-conventions)
5. [State Management](#state-management)
6. [Service Layer](#service-layer)
7. [Feature Development](#feature-development)
8. [Code Generation](#code-generation)
9. [Key Dependencies](#key-dependencies)
10. [Getting Started](#getting-started)

---

## Overview

The PRF Super App is a Flutter-based mobile application built with a clean, modular architecture that separates concerns into distinct layers. It uses the **Cubit** pattern for state management, **GetIt** for dependency injection, and **Freezed** for immutable data classes.

**Key technologies:** Flutter, Dart, flutter_bloc (Cubit), GetIt, Freezed, Dio, Isar, Hive, Auto Route, Firebase, PostHog.

**Supported platforms:** iOS, Android, Web, and Windows.

---

## Project Structure

```
lib/
├── app/                     # App widget and configuration
├── bootstrap.dart           # App bootstrap and DI initialization
├── decision.dart            # App decision/routing entry point
├── di/                      # Dependency Injection
│   ├── di_container.dart    # Main DI orchestrator
│   └── modules/             # Domain-specific DI modules
│       ├── core_module.dart
│       ├── firebase_module.dart
│       ├── auth_module.dart
│       ├── missions_module.dart
│       └── ...
├── enums/                   # Application enums (organized by domain)
│   ├── common/              # Environment, platform, notifications
│   ├── mission/             # Mission-related enums
│   ├── payment/             # Payment status, charge types
│   ├── event/               # Event types
│   └── member/              # Member roles, membership types
├── features/                # Feature modules (UI + business logic)
│   ├── auth/                # Authentication feature
│   └── home/                # Main app features
│       ├── shared/          # Shared home-level resources
│       │   └── cubit/       # Shared cubits across home features
│       ├── missions/        # Mission management
│       │   ├── cubit/       # Mission list-level cubits
│       │   └── mission_details/
│       │       └── widgets/
│       │           ├── debrief_notes/cubit/
│       │           ├── sessions/cubit/
│       │           ├── souls/cubit/
│       │           └── gallery/cubit/
│       ├── giving/          # Donations/payments
│       ├── events/          # Event management
│       ├── lms/             # Learning Management System
│       ├── account/         # User account management
│       ├── announcements/   # Announcements
│       ├── faqs/            # FAQs
│       ├── landing/         # Landing/home screen
│       ├── prayer_requests/ # Prayer requests
│       ├── student_enquiries/ # Student enquiries
│       ├── wrapped/         # Wrapped feature
│       └── mission_ground_suggestions/
├── l10n/                    # Localization
│   └── arb/                 # ARB translation files
├── models/                  # Data models (organized by domain)
│   ├── local/               # Isar database models
│   │   ├── mission/
│   │   ├── course/
│   │   ├── media/
│   │   ├── enquiry/
│   │   └── faq/
│   └── remote/              # API response models (Freezed)
│       ├── common/          # Auth, failure, config
│       ├── mission/
│       ├── expense/
│       ├── payment/
│       ├── member/
│       ├── course/
│       ├── event/
│       ├── prayer/
│       ├── enquiry/
│       ├── content/         # Announcements, FAQs, debrief notes
│       ├── media/
│       └── metadata/        # Profession, marital status, church
├── services/                # Application services
│   ├── _index.dart          # Main barrel export
│   ├── analytics/           # Analytics services
│   │   ├── analytics_service.dart
│   │   └── posthog_analytics_service.dart
│   ├── firebase/            # Firebase services
│   │   ├── firebase_analytics_service.dart
│   │   ├── firebase_analytics_service_impl.dart
│   │   ├── crashlytics_service.dart
│   │   └── crashlytics_service_impl.dart
│   ├── api/                 # REST API services
│   │   ├── _index.dart
│   │   ├── _base_api_service.dart
│   │   └── {feature}_service.dart
│   ├── local_storage/       # Hive & Isar services
│   │   ├── hive/
│   │   └── isar/
│   ├── error_handler_service.dart
│   ├── firebase_service.dart
│   ├── firebase_messaging_service.dart
│   ├── notification_service.dart
│   ├── socket_service.dart
│   ├── media_service.dart
│   ├── audio_recording_service.dart
│   ├── failed_recording_upload_service.dart
│   └── local_auth_service.dart
├── shared_widgets/          # Reusable UI components
│   ├── _index.dart          # Main barrel export
│   ├── buttons/             # Primary, secondary, destroy, google_auth
│   ├── input/               # Text, password, number, email, etc.
│   ├── error/               # Error snackbar and view
│   ├── states/              # Empty state, categories, receipt preview
│   ├── viewers/             # PDF viewer
│   ├── navbar/              # Navigation bar
│   ├── progress/            # Progress indicators
│   ├── home_action_card/    # Home action card widget
│   └── wrapped/             # Wrapped-specific widgets
├── utils/                   # Utilities & helpers
│   ├── _index.dart
│   ├── formatters/          # Date, number, string formatters
│   ├── validators/          # Input validation
│   ├── helpers/             # App version, device, mission, URL helpers
│   ├── mixins/              # Timezone mixin
│   ├── theme/               # PRF theme configuration
│   ├── http/                # Network utilities & retry interceptor
│   └── router/              # Auto-route configuration & guards
├── versioning/              # App versioning utilities
├── main_development.dart    # Development entry point
├── main_staging.dart        # Staging entry point
├── main_production.dart     # Production entry point
├── main_local.dart          # Local entry point
└── firebase_options.dart    # Firebase configuration
```

---

## Architecture Layers

### 1. Presentation Layer (`features/`)

Contains UI code organized by feature. Each feature typically includes:

- **Pages**: Screen widgets with responsive variants (`_handset.dart`, `_tablet.dart`)
- **Cubit**: Business logic and state management
- **Widgets**: Feature-specific UI components
- **Actions**: Modal sheets and dialogs

### 2. Domain Layer (`models/`)

Data models split into:

- **Remote models** (`models/remote/`): API response DTOs using Freezed for immutability and JSON serialization
- **Local models** (`models/local/`): Isar collections for offline/structured storage

### 3. Data Layer (`services/`)

Handles data operations:

- **API services** (`services/api/`): REST API communication via Dio
- **Local storage** (`services/local_storage/`): Hive (key-value settings) and Isar (structured data with querying)
- **Analytics** (`services/analytics/`): PostHog behavior tracking
- **Firebase** (`services/firebase/`): Crashlytics, Firebase Analytics, Remote Config

### 4. Dependency Injection (`di/`)

Modular DI configuration using GetIt:

- `DIContainer` orchestrates module registration
- Domain-specific modules register services and cubits
- Lazy singleton pattern for efficient memory usage

```dart
// lib/di/modules/auth_module.dart
class AuthModule {
  static void register(GetIt getIt) {
    getIt.registerSingleton<AuthService>(AuthService());
  }

  static List<BlocProvider> registerCubits(GetIt getIt) {
    return [
      BlocProvider<SigninCubit>(
        create: (context) => SigninCubit(
          authService: getIt(),
          hiveService: getIt(),
          socketService: getIt(),
          analyticsService: getIt(),
          firebaseMessagingService: getIt(),
        ),
      ),
    ];
  }
}
```

### Navigation

Declarative routing with `auto_route`:

- Routes defined in `lib/utils/router/router.dart`
- Auth guard for protected routes
- Deep linking support

### Responsive Design

Adaptive UI pattern:

- Base widget with `AdaptiveBuilder`
- `_handset.dart` for mobile layouts
- `_tablet.dart` for tablet/desktop layouts

### Cubit Organization

Cubits are organized near their features, not in a centralized location:

```
features/home/missions/
├── cubit/                          # Mission list-level cubits
│   ├── get_missions_cubit.dart
│   ├── subscribe_cubit.dart
│   └── withdraw_cubit.dart
└── mission_details/
    └── widgets/
        ├── debrief_notes/cubit/    # Debrief-specific cubits
        ├── sessions/cubit/          # Session-specific cubits
        ├── souls/cubit/             # Soul-specific cubits
        └── gallery/cubit/           # Gallery-specific cubits
```

**Principle**: A cubit lives in the `cubit/` folder of the feature that uses it.

---

## Folder Conventions

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Classes | PascalCase | `PRFPrimaryButton` |
| Files | snake_case | `prf_primary_button.dart` |
| Enums | snake_case with prf_ prefix | `prf_mission_status.dart` |
| Services | snake_case with _service suffix | `mission_service.dart` |
| Database Services | snake_case with _db_service suffix | `mission_db_service.dart` |
| Cubits | snake_case with _cubit suffix | `get_missions_cubit.dart` |
| States | snake_case with _state suffix | `get_missions_state.dart` |
| Pages | snake_case with _page suffix | `missions_page.dart` |
| Private files | Underscore prefix | `_base_api_service.dart` |

### Barrel Exports Policy

**Only services, utils, and shared widgets use barrel files (`_index.dart`)**. Everything else uses direct imports:

| Category | Barrel Files | Reason |
|----------|--------------|--------|
| Services | Yes | Reduces import clutter for API consumers |
| Utils | Yes | Convenient access to formatters, helpers, etc. |
| Shared Widgets | Yes | Main barrel for convenience |
| Models | No | Direct imports — avoid maintaining exports |
| Enums | No | Direct imports — files organized by domain |
| Cubits | No | Direct imports — colocated with features |

**Services barrel example:**

```dart
// lib/services/_index.dart
export 'analytics/analytics_service.dart';
export 'api/mission_service.dart';
export 'error_handler_service.dart';
// Don't export private files like _base_api_service.dart
```

### Import Guidelines

```dart
// Services: Use barrel exports
import 'package:app/services/_index.dart';

// Utils: Use barrel exports
import 'package:app/utils/_index.dart';

// Shared widgets: Use barrel export
import 'package:app/shared_widgets/_index.dart';

// Models: Use direct imports
import 'package:app/models/remote/common/auth.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:app/models/local/mission/prf_mission.dart';

// Enums: Use direct imports
import 'package:app/enums/mission/prf_mission_status.dart';
import 'package:app/enums/common/prf_environment.dart';

// Cubits: Use direct imports (NEVER use barrel files for cubits)
import 'package:app/features/home/missions/cubit/get_missions_cubit.dart';
```

### Import Order

1. Dart SDK imports
2. Flutter imports
3. External package imports
4. Internal package imports (`app/`)
5. Relative imports

```dart
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app/services/_index.dart';
import 'package:app/shared_widgets/_index.dart';

import '_handset.dart';
```

### Responsive UI Pattern

Every page/widget with different layouts follows this pattern:

```
feature/
├── _index.dart
├── feature.dart          # Aggregator with AdaptiveBuilder
├── _handset.dart         # Mobile layout (private)
└── _tablet.dart          # Tablet/web layout (private)
```

```dart
class FeaturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, __) => const FeaturePageTablet(),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, __) => const FeaturePageHandset(),
        tablet: (_, __) => const FeaturePageTablet(),
      ),
    );
  }
}
```

---

## State Management

The app uses the **Cubit** pattern from flutter_bloc for state management: simple, testable, and predictable.

### Cubit File Organization

Cubits are organized with the state as a `part` of the cubit file:

```
lib/features/auth/cubit/
├── sign_in_cubit.dart          # Main cubit file
├── sign_in_cubit.freezed.dart  # Generated freezed code
└── sign_in_state.dart          # State definitions (part of cubit)
```

### State Definition

```dart
// lib/features/auth/cubit/sign_in_state.dart
part of 'sign_in_cubit.dart';

@freezed
class SignInState with _$SignInState {
  const factory SignInState.initial() = _Initial;
  const factory SignInState.loading() = _Loading;
  const factory SignInState.loaded() = _Loaded;
  const factory SignInState.error(String message) = _Error;
}
```

### Cubit Implementation

```dart
// lib/features/auth/cubit/sign_in_cubit.dart
import 'package:app/models/remote/common/auth.dart';
import 'package:app/models/remote/common/failure.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';

part 'sign_in_state.dart';
part 'sign_in_cubit.freezed.dart';

class SigninCubit extends Cubit<SignInState> {
  SigninCubit({
    required AuthService authService,
    required HiveService hiveService,
    required SocketService socketService,
    required AnalyticsService analyticsService,
    required FirebaseMessagingService firebaseMessagingService,
  }) : super(const SignInState.initial()) {
    _authService = authService;
    _hiveService = hiveService;
    _socketService = socketService;
    _analyticsService = analyticsService;
    _firebaseMessagingService = firebaseMessagingService;
  }

  late HiveService _hiveService;
  late AuthService _authService;
  late SocketService _socketService;
  late AnalyticsService _analyticsService;
  late FirebaseMessagingService _firebaseMessagingService;

  Future<void> signIn({required String email, required String password}) async {
    emit(const SignInState.loading());
    try {
      final token = await _authService.signIn(
        signInDTO: SignInDTO(email: email, password: password),
      );

      _hiveService.auth.persistToken(token);

      final user = await _authService.getUser();
      _hiveService.auth.persistProfile(user);

      await _analyticsService.identifyUser(user: user);

      emit(const SignInState.loaded());
    } on Failure catch (e) {
      emit(SignInState.error(e.message));
    } catch (e, stackTrace) {
      Logger().e('SignInCubit signIn error: $e', stackTrace: stackTrace);
      emit(const SignInState.error('An unknown error occurred'));
    }
  }
}
```

### State Patterns

**Standard CRUD States:**

```dart
@freezed
class GetMissionsState with _$GetMissionsState {
  const factory GetMissionsState.initial() = _Initial;
  const factory GetMissionsState.loading() = _Loading;
  const factory GetMissionsState.loaded({required List<PRFMission> missions}) = _Loaded;
  const factory GetMissionsState.empty() = _Empty;
  const factory GetMissionsState.error(String message) = _Error;
}
```

**Form Submission States:**

```dart
@freezed
class AddExpenseState with _$AddExpenseState {
  const factory AddExpenseState.initial() = _Initial;
  const factory AddExpenseState.loading() = _Loading;
  const factory AddExpenseState.loaded({required PRFExpense expense}) = _Loaded;
  const factory AddExpenseState.error(String message) = _Error;
}
```

**Delete Operation States:**

```dart
@freezed
class DeleteExpenseState with _$DeleteExpenseState {
  const factory DeleteExpenseState.initial() = _Initial;
  const factory DeleteExpenseState.loading() = _Loading;
  const factory DeleteExpenseState.loaded() = _Loaded;
  const factory DeleteExpenseState.error(String message) = _Error;
}
```

### DI Module Registration

```dart
// lib/di/modules/auth_module.dart
class AuthModule {
  static void register(GetIt getIt) {
    getIt.registerSingleton<AuthService>(AuthService());
  }

  static List<BlocProvider> registerCubits(GetIt getIt) {
    return [
      BlocProvider<SigninCubit>(
        create: (context) => SigninCubit(
          authService: getIt(),
          hiveService: getIt(),
          socketService: getIt(),
          analyticsService: getIt(),
          firebaseMessagingService: getIt(),
        ),
      ),
      BlocProvider<SocialLoginCubit>(
        create: (context) => SocialLoginCubit(
          authService: getIt(),
          hiveService: getIt(),
        ),
      ),
    ];
  }
}
```

Cubits are provided to the widget tree in `bootstrap.dart`:

```dart
MultiBlocProvider(
  providers: DIContainer.registerCubits(),
  child: const App(),
)
```

### UI Integration

**BlocConsumer** — Combined builder + listener for handling both UI updates and side effects:

```dart
BlocConsumer<SigninCubit, SignInState>(
  listener: (context, state) {
    state.maybeWhen(
      loading: () => setState(() {
        _isLoading = !_isLoading;
      }),
      loaded: () => context.router.pushPath(PRFSuperAppRouter.landingRoute),
      error: (message) {
        setState(() {
          _isLoading = !_isLoading;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: theme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      orElse: () {},
    );
  },
  builder: (context, state) {
    return PRFPrimaryButton(
      onPressed: () {
        context.read<SigninCubit>().signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      },
      title: _isLoading ? l10n.signingIn : l10n.signIn,
      disabled: _isLoading,
      isLoading: _isLoading,
    );
  },
)
```

**BlocListener** — For side effects only (navigation, snackbars):

```dart
BlocListener<SocialLoginCubit, SocialLoginState>(
  listener: (context, state) {
    state.maybeWhen(
      orElse: () {},
      loaded: () => context.router.pushPath(PRFSuperAppRouter.decisionRoute),
      error: (message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: theme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  },
  child: Form(...),
)
```

**BlocBuilder** — For UI updates only:

```dart
BlocBuilder<GoogleSignInCubit, GoogleSignInState>(
  builder: (context, state) {
    final (isLoading, title) = state.maybeWhen(
      loading: () => (true, 'Please wait ...'),
      orElse: () => (false, 'Continue with Google'),
    );

    return GoogleAuthButton(
      onPressed: () => context.read<GoogleSignInCubit>().signInwithGoogle(),
      title: title,
      disabled: isLoading,
      isLoading: isLoading,
    );
  },
)
```

### State Management Best Practices

**1. One Cubit Per Use Case**

```dart
// Good - focused responsibility
class SigninCubit extends Cubit<SignInState> { }
class SignOutCubit extends Cubit<SignOutState> { }
class ChangeProfilePictureCubit extends Cubit<ChangeProfilePictureState> { }

// Bad - too many responsibilities
class AuthCubit extends Cubit<AuthState> {
  void signIn() { }
  void signOut() { }
  void changeProfilePicture() { }
}
```

**2. Immutable States with Freezed**

```dart
// Always use const factory
const factory SignInState.loaded() = _Loaded;
```

**3. Consistent Error Handling**

```dart
try {
  final result = await service.doSomething();
  emit(MyState.loaded(data: result));
} on Failure catch (e) {
  emit(MyState.error(e.message));
} catch (e, stackTrace) {
  Logger().e('Error: $e', stackTrace: stackTrace);
  emit(const MyState.error('An unknown error occurred'));
}
```

**4. State Pattern Matching**

```dart
// For exhaustive matching
state.when(
  initial: () => const SizedBox.shrink(),
  loading: () => const CircularProgressIndicator(),
  loaded: () => const SuccessWidget(),
  error: (message) => ErrorWidget(message: message),
)

// For partial handling
state.maybeWhen(
  loaded: () => handleSuccess(),
  error: (message) => showError(message),
  orElse: () {},
)
```

**5. Avoid Emitting After Dispose**

```dart
class MyCubit extends Cubit<MyState> {
  Future<void> fetchData() async {
    emit(const MyState.loading());
    try {
      final data = await service.getData();
      if (!isClosed) { // Check before emitting
        emit(MyState.loaded(data: data));
      }
    } catch (e, s) {
      if (!isClosed) {
        emit(MyState.error(e.toString()));
      }
    }
  }
}
```

**6. Direct Imports for Cubits**

Always import cubits directly — never use barrel files for cubits:

```dart
// Correct - direct import
import 'package:app/features/auth/cubit/sign_in_cubit.dart';

// Wrong - no barrel exports for cubits
import 'package:app/features/auth/cubit/_index.dart'; // Don't do this
```

### Testing Cubits

```dart
void main() {
  late SigninCubit cubit;
  late MockAuthService mockAuthService;
  late MockHiveService mockHiveService;

  setUp(() {
    mockAuthService = MockAuthService();
    mockHiveService = MockHiveService();
    cubit = SigninCubit(
      authService: mockAuthService,
      hiveService: mockHiveService,
      socketService: MockSocketService(),
      analyticsService: MockAnalyticsService(),
      firebaseMessagingService: MockFirebaseMessagingService(),
    );
  });

  blocTest<SigninCubit, SignInState>(
    'emits [loading, loaded] when signIn succeeds',
    build: () {
      when(() => mockAuthService.signIn(signInDTO: any(named: 'signInDTO')))
          .thenAnswer((_) async => 'token');
      when(() => mockAuthService.getUser())
          .thenAnswer((_) async => testUser);
      return cubit;
    },
    act: (cubit) => cubit.signIn(email: 'test@test.com', password: 'password'),
    expect: () => [
      const SignInState.loading(),
      const SignInState.loaded(),
    ],
  );

  blocTest<SigninCubit, SignInState>(
    'emits [loading, error] when signIn fails',
    build: () {
      when(() => mockAuthService.signIn(signInDTO: any(named: 'signInDTO')))
          .thenThrow(Failure(message: 'Invalid credentials'));
      return cubit;
    },
    act: (cubit) => cubit.signIn(email: 'test@test.com', password: 'wrong'),
    expect: () => [
      const SignInState.loading(),
      const SignInState.error('Invalid credentials'),
    ],
  );
}
```

---

## Service Layer

### API Services

All API services extend `BaseApiService`:

```dart
abstract class BaseApiService<T> {
  BaseApiService({required this.network, required this.endpoint});

  final Network network;
  final String endpoint;

  Future<List<T>> getAll();
  Future<T> getById(int id);
  Future<T> create(Map<String, dynamic> data);
  Future<T> update(int id, Map<String, dynamic> data);
  Future<void> delete(int id);
}
```

**Creating a new API service:**

```dart
class MyFeatureService extends BaseApiService<MyModel> {
  MyFeatureService({required super.network})
      : super(endpoint: 'my-feature');

  @override
  Future<List<MyModel>> getAll() async {
    final response = await network.get<List>('/$endpoint');
    return response.map((e) => MyModel.fromJson(e)).toList();
  }

  Future<MyModel> doSomethingSpecial(int id) async {
    final response = await network.post('/$endpoint/$id/special');
    return MyModel.fromJson(response);
  }
}
```

**Registration:**

```dart
getIt.registerLazySingleton(
  () => MyFeatureService(network: getIt()),
);
```

### Local Storage

**Hive (Key-Value Storage)** — Used for simple data like settings and cached auth tokens:

```dart
class SettingsHiveService extends BaseHiveService {
  static const _box = 'settings';

  Future<void> saveTheme(String theme) async {
    await save(_box, 'theme', theme);
  }

  String? getTheme() {
    return get(_box, 'theme');
  }
}
```

**Isar (Local Database)** — Used for structured data that needs querying:

```dart
@collection
class PRFMission {
  Id? id;

  @Index()
  late int remoteId;

  late String name;
  late DateTime startDate;
  late PRFLocation? location;
}
```

```dart
class MissionDbService extends BaseLocalDbService<PRFMission> {
  MissionDbService({required super.isarService});

  @override
  IsarCollection<PRFMission> get collection => isar.pRFMissions;

  Future<List<PRFMission>> getUpcoming() async {
    return collection
        .filter()
        .startDateGreaterThan(DateTime.now())
        .sortByStartDate()
        .findAll();
  }
}
```

### Error Handling

**Failure class** — Provides comprehensive error information:

```dart
class Failure implements Exception {
  final String message;           // User-friendly message
  final int? statusCode;          // HTTP status code
  final ErrorType type;           // Categorization
  final ErrorSeverity severity;   // For logging/alerting
  final String? technicalMessage; // Debug info
  final bool isRecoverable;       // Can user retry?
  final StackTrace? stackTrace;   // For debugging
  final Map<String, dynamic> context; // Additional data
}
```

**Error types:**

```dart
enum ErrorType {
  network,        // Connection issues
  authentication, // Login required
  authorization,  // Permission denied
  validation,     // Invalid input
  notFound,       // Resource missing
  server,         // 5xx errors
  timeout,        // Request timeout
  cancelled,      // User cancelled
  unknown,        // Unclassified
}
```

**Creating failures:**

```dart
// From exception
throw Failure.fromException(e, s);

// From status code
throw Failure.fromStatusCode(404, 'User not found');

// Named constructors
throw Failure.noConnection();
throw Failure.timeout();
throw Failure.authentication();
throw Failure.authorization();
```

**Error Handler Service** — Centralized error logging and reporting:

```dart
class ErrorHandlerServiceImpl implements ErrorHandlerService {
  ErrorHandlerServiceImpl({
    required this.analyticsService,
    required this.crashlyticsService,
  });

  final AnalyticsService analyticsService;
  final CrashlyticsService crashlyticsService;

  @override
  void handleError(Object error, [StackTrace? stackTrace, Map<String, dynamic>? context]) {
    final failure = error is Failure ? error : Failure.fromException(error, stackTrace);
    _logToConsole(failure, stackTrace);
    _reportToAnalytics(failure, context);
    _reportToCrashlytics(failure, stackTrace);
  }
}
```

**Crashlytics Integration** — Reports errors in release mode AND production environment only:

```dart
class CrashlyticsServiceImpl implements CrashlyticsService {
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  bool get _shouldReport =>
      kReleaseMode &&
      PRFSuperAppConfig.instance?.values.environment == PRFEnvironment.production;

  @override
  Future<void> recordError(Object error, StackTrace stackTrace,
      {String? reason, bool fatal = false}) async {
    if (!_shouldReport) return;
    await _crashlytics.recordError(error, stackTrace, reason: reason, fatal: fatal);
  }
}
```

**UI Error Components:**

```dart
// Full screen error view
PRFErrorView(
  failure: failure,
  onRetry: () => cubit.retry(),
  compact: false,
)

// Error snackbar
PRFErrorSnackbar.show(
  context,
  failure,
  onRetry: () => cubit.retry(),
);
```

### Analytics Services

The app uses two analytics providers:

**PostHog Analytics** — Primary analytics for user behavior and session replay:

```dart
class PostHogAnalyticsService implements AnalyticsService {
  bool get _shouldCollect =>
      kReleaseMode &&
      PRFSuperAppConfig.instance?.values.environment == PRFEnvironment.production;

  @override
  Future<void> captureEvent(String eventName, [Map<String, Object>? props]) async {
    if (!_shouldCollect) return;
    await Posthog().capture(eventName: eventName, properties: props);
  }
}
```

**Firebase Analytics** — For standard event tracking and Firebase ecosystem integration:

```dart
class FirebaseAnalyticsServiceImpl implements FirebaseAnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  @override
  Future<void> logEvent(String name, {Map<String, Object?>? parameters}) async {
    if (!_shouldCollect) return;
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  @override
  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);
}
```

**When to use which:**

- **PostHog**: User behavior, funnels, session replay
- **Firebase Analytics**: Standard events, conversions, A/B testing

### Network Configuration

```dart
final dio = Dio(BaseOptions(
  baseUrl: environment.apiBaseUrl,
  connectTimeout: const Duration(seconds: 30),
  receiveTimeout: const Duration(seconds: 30),
));

dio.interceptors.addAll([
  RetryInterceptor(dio: dio),
  LogInterceptor(requestBody: true, responseBody: true),
]);
```

**Retry Interceptor** — Automatic retry for transient failures:

```dart
class RetryInterceptor extends Interceptor {
  static const _maxRetries = 3;
  static const _retryDelay = Duration(seconds: 1);

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err) && _retryCount < _maxRetries) {
      await Future.delayed(_retryDelay * _retryCount);
      // Retry the request
    }
    return handler.next(err);
  }
}
```

### Service Layer Best Practices

1. **Always use Failure** — Convert exceptions to Failure for consistent handling
2. **Log with context** — Include relevant data when reporting errors
3. **Offline-first** — Use Isar for data that should work offline
4. **Lazy singletons** — Register services as lazy singletons for memory efficiency
5. **Type safety** — Use generic services where possible
6. **Release-only reporting** — Analytics and Crashlytics only in release + production

---

## Feature Development

### Step-by-Step Guide

#### 1. Create the Feature Directory

```bash
mkdir -p lib/features/home/{feature_name}/{cubit,widgets,actions}
```

#### 2. Create the Cubit

**{action}_state.dart:**

```dart
part of '{action}_cubit.dart';

@freezed
class {Action}State with _${Action}State {
  const factory {Action}State.initial() = _Initial;
  const factory {Action}State.loading() = _Loading;
  const factory {Action}State.success({required DataType data}) = _Success;
  const factory {Action}State.failure({required Failure error}) = _Failure;
}
```

**{action}_cubit.dart:**

```dart
import 'package:app/models/remote/failure.dart';
import 'package:app/services/_index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '{action}_state.dart';
part '{action}_cubit.freezed.dart';

class {Action}Cubit extends Cubit<{Action}State> {
  {Action}Cubit({required this.service}) : super(const {Action}State.initial());

  final {Service}Service service;

  Future<void> execute() async {
    emit(const {Action}State.loading());
    try {
      final result = await service.fetchData();
      emit({Action}State.success(data: result));
    } catch (e, s) {
      emit({Action}State.failure(error: Failure.fromException(e, s)));
    }
  }
}
```

#### 3. Create the UI Components

**{feature_name}.dart** — Main aggregator:

```dart
import 'package:app/features/home/{feature_name}/_handset.dart';
import 'package:app/features/home/{feature_name}/_tablet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_ui/flutter_adaptive_ui.dart';

class {FeatureName}Page extends StatelessWidget {
  const {FeatureName}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveBuilder(
      defaultBuilder: (_, __) => const {FeatureName}PageTablet(),
      layoutDelegate: AdaptiveLayoutDelegateWithMinimallScreenType(
        handset: (_, __) => const {FeatureName}PageHandset(),
        tablet: (_, __) => const {FeatureName}PageTablet(),
      ),
    );
  }
}
```

**_handset.dart:**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class {FeatureName}PageHandset extends StatelessWidget {
  const {FeatureName}PageHandset({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<{Action}Cubit, {Action}State>(
      builder: (context, state) {
        return state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const Center(child: CircularProgressIndicator()),
          success: (data) => _buildContent(context, data),
          failure: (error) => PRFErrorView(
            failure: error,
            onRetry: () => context.read<{Action}Cubit>().execute(),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, DataType data) {
    // Build your UI here
  }
}
```

#### 4. Register in DI Module

Add to the appropriate module in `lib/di/modules/`:

```dart
static void register(GetIt getIt) {
  getIt.registerLazySingleton(
    () => {Action}Cubit(service: getIt()),
  );
}

static List<BlocProvider> registerCubits(GetIt getIt) {
  return [
    BlocProvider<{Action}Cubit>(create: (_) => getIt()),
  ];
}
```

#### 5. Add Route

In `lib/utils/router/router.dart`:

```dart
AutoRoute(
  page: {FeatureName}Route.page,
  path: '{feature-name}',
),
```

#### 6. Run Code Generation

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Feature Development Best Practices

1. **One cubit per use case** — Keep cubits focused on a single responsibility
2. **Direct imports for cubits** — Import cubits directly, no barrel files for cubits
3. **Barrel exports for services only** — Only `lib/services/` uses `_index.dart`
4. **Responsive layouts** — Always create both `_handset.dart` and `_tablet.dart`
5. **Error handling** — Use `Failure` class for consistent error representation
6. **Naming conventions** — Follow the established patterns (see [Folder Conventions](#folder-conventions))

---

## Code Generation

The app uses several code generators:

| Generator | Purpose | File Suffix |
|-----------|---------|-------------|
| `freezed` | Immutable data classes, unions | `.freezed.dart` |
| `json_serializable` | JSON serialization | `.g.dart` |
| `isar_generator` | Isar database schemas | `.g.dart` |
| `auto_route_generator` | Navigation routes | `.gr.dart` |

### Running Code Generation

```bash
# One-time build
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (development)
flutter pub run build_runner watch --delete-conflicting-outputs

# Clean and rebuild
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Freezed Patterns

**Data classes:**

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

**Union types (states):**

```dart
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.authenticated({required User user}) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
}
```

**Custom methods on Freezed classes:**

```dart
@freezed
class User with _$User {
  const User._(); // Private constructor for custom methods

  const factory User({
    required String firstName,
    required String lastName,
  }) = _User;

  String get fullName => '$firstName $lastName';
  bool isValid() => firstName.isNotEmpty && lastName.isNotEmpty;
}
```

**JSON field names:**

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

**Default values:**

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

### Isar Models

**Basic collection:**

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

**Embedded objects:**

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

**Relationships:**

```dart
@collection
class PRFMission {
  Id? id;
  late String name;
  final sessions = IsarLinks<PRFMissionSession>();
}
```

### Auto Route

**Defining routes:**

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

**Page annotation:**

```dart
@RoutePage()
class MissionsPage extends StatelessWidget {
  const MissionsPage({super.key});

  @override
  Widget build(BuildContext context) => const MissionsView();
}
```

### Code Generation Troubleshooting

**Conflicting outputs:**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**Missing part directive** — Ensure the part file includes:

```dart
part of 'your_file.dart';
```

**Analyzer errors after generation:**

```bash
flutter pub run build_runner build --delete-conflicting-outputs && flutter pub get
```

### Code Generation Best Practices

1. **Commit generated files** — `.freezed.dart`, `.g.dart`, `.gr.dart` should be committed to version control
2. **Use part directives correctly** — Include both `part 'file.freezed.dart'` and `part 'file.g.dart'` as needed
3. **Nullable vs required** — Use `required` for always-present fields, `String?` for optional, `@Default('')` for optional with defaults

### IDE Support

- **VS Code**: Install the "Dart Data Class Generator" extension for snippets
- **IntelliJ/Android Studio**: Enable "Generate Code" action in preferences

**Recommended workflow:**

1. Write the class definition
2. Add required imports and parts
3. Run `flutter pub run build_runner build`
4. Restart analyzer if needed

---

## Key Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_bloc` / `bloc` | State management (Cubit pattern) |
| `get_it` | Dependency injection |
| `freezed` / `freezed_annotation` | Immutable data classes & unions |
| `json_serializable` / `json_annotation` | JSON serialization |
| `auto_route` / `auto_route_generator` | Declarative routing |
| `isar_community` | Local database (structured data) |
| `hive_ce` / `hive_ce_flutter` | Key-value local storage |
| `dio` | HTTP client |
| `firebase_core` | Firebase platform |
| `firebase_crashlytics` | Crash reporting (production only) |
| `firebase_analytics` | Standard event tracking |
| `firebase_messaging` | Push notifications |
| `firebase_remote_config` | Remote configuration |
| `posthog_flutter` | Behavior analytics & session replay |
| `flutter_adaptive_ui` | Responsive layout builder |
| `google_sign_in` | Google authentication |
| `local_auth` | Biometric authentication |
| `shorebird_code_push` | Over-the-air updates |
| `prf_design` | Internal design system package |
| `logger` | Logging |
| `mocktail` | Testing mocks |
| `bloc_test` | Cubit/Bloc testing utilities |
| `patrol` | Integration testing |
| `very_good_analysis` | Lint rules |

---

## Getting Started

### Flavors

This project contains 3 flavors:

- **development**
- **staging**
- **production**

To run the desired flavor, either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# Development
flutter run --flavor development --target lib/main_development.dart

# Staging
flutter run --flavor staging --target lib/main_staging.dart

# Production
flutter run --flavor production --target lib/main_production.dart
```

### Running Tests

To run all unit and widget tests:

```sh
flutter test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report using [lcov](https://github.com/linux-test-project/lcov):

```sh
# Generate Coverage Report
genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
open coverage/index.html
```

### Working with Translations

This project relies on [flutter_localizations](https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html) and follows the [official internationalization guide for Flutter](https://flutter.dev/docs/development/accessibility-and-localization/internationalization).

**Adding strings:**

1. Open the `app_en.arb` file at `lib/l10n/arb/app_en.arb`
2. Add a new key/value and description:

```arb
{
    "@@locale": "en",
    "helloWorld": "Hello World",
    "@helloWorld": {
        "description": "Hello World Text"
    }
}
```

3. Use the new string:

```dart
import 'package:app/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

**Adding supported locales:**

Update the `CFBundleLocalizations` array in `ios/Runner/Info.plist`:

```xml
<key>CFBundleLocalizations</key>
<array>
    <string>en</string>
    <string>es</string>
</array>
```

**Adding translations:**

For each supported locale, add a new ARB file in `lib/l10n/arb`:

```
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   └── app_es.arb
```

**Generating translations:**

```sh
flutter gen-l10n --arb-dir="lib/l10n/arb"
```

Alternatively, run `flutter run` and code generation will take place automatically.

### Verification Commands

```bash
# Check app compiles
flutter build apk --flavor development

# Run static analysis
flutter analyze

# Run code generation
flutter pub run build_runner build --delete-conflicting-outputs
```
