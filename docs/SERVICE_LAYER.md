# Service Layer Guide

This document describes the service layer architecture, including API services, local storage, and error handling.

## Service Directory Structure

```
lib/services/
├── _index.dart                      # Main barrel export
├── analytics/
│   ├── analytics_service.dart       # Interface
│   └── posthog_analytics_service.dart
├── firebase/
│   ├── firebase_analytics_service.dart
│   ├── firebase_analytics_service_impl.dart
│   ├── crashlytics_service.dart     # Interface
│   └── crashlytics_service_impl.dart
├── api/
│   ├── _index.dart
│   ├── _base_api_service.dart       # Private base class
│   └── {feature}_service.dart       # Feature-specific API services
├── local_storage/
│   ├── _index.dart
│   ├── hive/
│   │   ├── _index.dart
│   │   └── auth_hive_service.dart
│   └── isar/
│       ├── _index.dart
│       ├── _base_local_db_service.dart
│       └── {feature}_db_service.dart
├── error_handler_service.dart
├── firebase_service.dart            # Google Sign-In & Remote Config
├── firebase_messaging_service.dart
├── notification_service.dart
├── socket_service.dart
├── media_service.dart
├── audio_recording_service.dart
├── failed_recording_upload_service.dart
└── local_auth_service.dart
```

## API Services

### Base Service Pattern

All API services extend `BaseApiService`:

```dart
abstract class BaseApiService<T> {
  BaseApiService({required this.network, required this.endpoint});

  final Network network;
  final String endpoint;

  // Common CRUD operations
  Future<List<T>> getAll();
  Future<T> getById(int id);
  Future<T> create(Map<String, dynamic> data);
  Future<T> update(int id, Map<String, dynamic> data);
  Future<void> delete(int id);
}
```

### Creating a New API Service

```dart
class MyFeatureService extends BaseApiService<MyModel> {
  MyFeatureService({required super.network})
      : super(endpoint: 'my-feature');

  @override
  Future<List<MyModel>> getAll() async {
    final response = await network.get<List>('/$endpoint');
    return response.map((e) => MyModel.fromJson(e)).toList();
  }

  // Custom methods
  Future<MyModel> doSomethingSpecial(int id) async {
    final response = await network.post('/$endpoint/$id/special');
    return MyModel.fromJson(response);
  }
}
```

### Registration

Register in the appropriate DI module:

```dart
getIt.registerLazySingleton(
  () => MyFeatureService(network: getIt()),
);
```

## Local Storage

### Hive (Key-Value Storage)

Used for simple data like settings and cached auth tokens.

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

### Isar (Local Database)

Used for structured data that needs querying.

**Model Definition:**
```dart
@collection
class PRFMission {
  Id? id;

  @Index()
  late int remoteId;

  late String name;
  late DateTime startDate;

  // Embedded objects
  late PRFLocation? location;
}
```

**Database Service:**
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

## Error Handling

### Failure Class

The `Failure` class provides comprehensive error information:

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

### Error Types

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

### Creating Failures

```dart
// From exception
try {
  await api.fetchData();
} catch (e, s) {
  throw Failure.fromException(e, s);
}

// From status code
throw Failure.fromStatusCode(404, 'User not found');

// Named constructors
throw Failure.noConnection();
throw Failure.timeout();
throw Failure.authentication();
throw Failure.authorization();
```

### Error Handler Service

Centralized error logging and reporting:

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

### Crashlytics Integration

Firebase Crashlytics reports errors in **release mode AND production environment only**:

```dart
class CrashlyticsServiceImpl implements CrashlyticsService {
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  /// Only report in release mode AND production environment
  bool get _shouldReport =>
      kReleaseMode &&
      PRFSuperAppConfig.instance?.values.environment == PRFEnvironment.production;

  @override
  Future<void> recordError(Object error, StackTrace stackTrace, {String? reason, bool fatal = false}) async {
    if (!_shouldReport) return;
    await _crashlytics.recordError(error, stackTrace, reason: reason, fatal: fatal);
  }

  @override
  Future<void> setCustomKey(String key, Object value) async {
    if (!_shouldReport) return;
    await _crashlytics.setCustomKey(key, value);
  }
}
```

**Why this pattern?**
- No crash reports in debug/development environments
- Cleaner crash reports with only production issues
- Reduced noise during development and testing

### UI Error Components

**Error View (Full Screen):**
```dart
PRFErrorView(
  failure: failure,
  onRetry: () => cubit.retry(),
  compact: false, // Full screen mode
)
```

**Error Snackbar:**
```dart
PRFErrorSnackbar.show(
  context,
  failure,
  onRetry: () => cubit.retry(),
);
```

## Network Configuration

### Dio Setup

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

### Retry Interceptor

Automatic retry for transient failures:

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

## Analytics Services

The app uses two analytics providers:

### PostHog Analytics (Behavior Tracking)

Primary analytics for user behavior and session replay:

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

### Firebase Analytics (Standard Events)

For standard event tracking and integration with Firebase ecosystem:

```dart
class FirebaseAnalyticsServiceImpl implements FirebaseAnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  @override
  Future<void> logEvent(String name, {Map<String, Object?>? parameters}) async {
    if (!_shouldCollect) return;
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  @override
  FirebaseAnalyticsObserver get observer => FirebaseAnalyticsObserver(analytics: _analytics);
}
```

**When to use which:**
- **PostHog**: User behavior, funnels, session replay
- **Firebase Analytics**: Standard events, conversions, A/B testing

## Best Practices

1. **Always use Failure** - Convert exceptions to Failure for consistent handling
2. **Log with context** - Include relevant data when reporting errors
3. **Offline-first** - Use Isar for data that should work offline
4. **Lazy singletons** - Register services as lazy singletons for memory efficiency
5. **Type safety** - Use generic services where possible
6. **Release-only reporting** - Analytics and Crashlytics only in release + production
