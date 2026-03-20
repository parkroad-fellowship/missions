# Code Review Report — PRF Super App

**Date:** 2026-03-20
**Branch:** `feature/app-revamp`
**Reviewer:** Automated strict review (world-class standards)

---

## Table of Contents

- [Critical Issues](#critical-issues)
- [High Issues](#high-issues)
- [Medium Issues](#medium-issues)
- [Low Issues](#low-issues)
- [Code Patterns to Enforce](#code-patterns-to-enforce)
- [Priority Action Plan](#priority-action-plan)

---

## Critical Issues

### 1. Hardcoded Credentials in Source Control

**Files:**

- `android/key.properties:1-4`
- `lib/features/auth/sign_in/_handset.dart:24,27`

**Problem:**

Keystore passwords (`prfMissions@2024`) committed in plain text in `key.properties`. Even if `.gitignore` lists it, it's already in git history.

Debug login credentials hardcoded in sign-in screen:

```dart
text: kDebugMode ? 'member.toy@parkroadfellowship.org' : '',
text: kDebugMode ? 'QRnYYl3say' : '',
```

**Action:**

- Scrub `key.properties` from git history (`git filter-branch` or `git filter-repo`)
- Remove hardcoded credentials and use secure config injection (GitHub Secrets, `.env`)
- Update CI/CD workflows to create `key.properties` from secrets at build time

---

### 2. Force-Unwrap (`!`) Without Null Guards — App Crash Risk

**Files:**

- `features/home/missions/cubit/subscribe_cubit.dart:30`
- `features/home/missions/cubit/get_member_mission_subscriptions_cubit.dart:30,37`
- `features/home/account/cubit/change_profile_picture_cubit.dart:49-50`
- `services/local_storage/isar/mission_db_service.dart:18-20`
- Multiple other cubits using `!.ulid`

**Problem:**

Multiple cubits use `_hiveService.retrieveMember()!.ulid` without null checks. If Hive data is corrupted or session expired, this crashes the app in production.

In `mission_db_service.dart`, unsafe null assertions on required relationships:

```dart
final missionType = remote.missionType!;    // may crash
final school = remote.school!;              // may crash
final contacts = remote.school!.contacts!;  // may crash
```

**Action:**

Replace every `!` with proper null check + error state emission:

```dart
final member = _hiveService.retrieveMember();
if (member == null) {
  emit(SubscribeState.error('User session expired. Please log in again.'));
  return;
}
```

---

### 3. SSL Certificate Validation Disabled

**File:** `lib/utils/http/network.dart:112-114`

**Problem:**

```dart
if (kDebugMode) {
  (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
      HttpClient()..badCertificateCallback = (_, _, _) => true;
}
```

Disables all TLS validation in debug mode. Man-in-the-middle attack vector if debug builds are used on real networks.

**Action:**

- Remove the certificate bypass entirely
- Implement proper certificate pinning for production
- If needed for local development only, use a controlled list of dev certificates

---

### 4. Unclosed StreamControllers — Memory Leaks

**Files:**

- `services/local_storage/isar/_base_local_db_service.dart:24-56`
- `services/failed_recording_upload_service.dart:26-34`

**Problem:**

`StreamController.broadcast()` created in `_base_local_db_service.dart` but never closed. No `dispose()` method exists on the base class.

In `failed_recording_upload_service.dart`, two `StreamController` instances with a periodic `Timer` that never stops retrying.

**Action:**

- Add `dispose()` method to `_base_local_db_service.dart` that closes all controllers
- Ensure `dispose()` is called from DI container teardown
- Add max retry limit and proper cleanup to `FailedRecordingUploadService`

---

### 5. FCM Token Update Runs After Failed Sign-In

**File:** `features/auth/cubit/sign_in_cubit.dart:62-69`

**Problem:**

FCM token update executes **outside** the try-catch block, meaning it runs even when sign-in fails and an error state was emitted. This can leave the app in an inconsistent state where the user sees an error but the profile is partially updated.

**Action:**

Move FCM token update inside the success branch only:

```dart
try {
  // ... sign in logic
  emit(const SignInState.loaded());
  // Move FCM update HERE, inside try block, after success
  await _updateFcmToken();
} catch (e) {
  emit(SignInState.error(e.toString()));
}
```

---

### 6. Inconsistent Enum Serialization in Isar Models

**File:** `models/local/course/prf_course_module.dart:42,64`

**Problem:**

Same `PRFCompletionStatus` enum serialized as `EnumType.name` in one field and `EnumType.ordinal32` in another within the same model. Deserialization will break when reading back from Isar.

**Action:**

Standardize on `EnumType.name` across all Isar models for enum serialization.

---

## High Issues

### 7. Two Conflicting DI Systems

**Files:**

- `lib/utils/singletons.dart`
- `lib/di/di_container.dart`

**Problem:**

Both files declare `final GetIt getIt = GetIt.instance;` and register overlapping services. Only `DIContainer` is used in bootstrap, making `singletons.dart` dead/confusing code. Both define `setup()` methods that register many of the same services.

**Action:**

Delete `singletons.dart` entirely. Use only `DIContainer` with its modular system.

---

### 8. Network Layer Violates Separation of Concerns

**File:** `lib/utils/http/network.dart`

**Problem:**

- **Line 54-57:** Network layer directly reads from `HiveService` for tokens
- **Line 136-137:** On 401, network layer directly clears Hive storage and navigates

The HTTP layer should not own auth state management. This creates tight coupling and makes testing impossible.

**Action:**

- Inject a `TokenProvider` interface instead of accessing `HiveService` directly
- Throw a specific `AuthExpiredException` on 401 and let the auth layer handle cleanup
- Emit navigation events rather than directly manipulating the router

---

### 9. No Unit Tests — Zero Test Enforcement

**Problem:**

- `test/` directory contains only `.gitkeep`
- `bloc_test` is **commented out** in `pubspec.yaml` (line 86)
- CI/CD `pr-check.yaml` runs **no tests**
- No coverage threshold enforcement
- No integration test validation in CI

**Action:**

1. Uncomment `bloc_test: ^10.0.0` in `pubspec.yaml`
2. Write unit tests for all critical cubits (auth, missions, subscriptions)
3. Add to `pr-check.yaml`:

```yaml
- name: Run tests
  run: flutter test --coverage --test-randomize-ordering-seed random

- name: Check coverage
  run: lcov --summary coverage/lcov.info
```

4. Set minimum coverage threshold (recommend 80% for new code)

---

### 10. Silent Exception Swallowing in Cubits

**Files:**

- `features/home/account/cubit/sign_out_cubit.dart:28`
- `features/home/shared/cubit/save_prayer_response_cubit.dart:21-34`
- `bootstrap.dart:82-86`

**Problem:**

- `SignOutCubit`: `catch (e) { emit(const SignOutState.loaded()); }` — logout failure looks like success
- `SavePrayerResponseCubit`: No loading state, no error state, always emits `loaded()`
- `bootstrap.dart`: Firebase Remote Config failure caught and only logged

**Action:**

Every cubit must follow this pattern:

```dart
Future<void> doAction() async {
  emit(const State.loading());
  try {
    // ... operation
    emit(const State.loaded(data));
  } catch (e) {
    Logger().e('Context: $e');
    emit(State.error(e.toString()));
  }
}
```

---

### 11. `getIt<>` Called Directly in Widgets

**File:** `features/home/missions/mission_details/widgets/sessions/add_audio/pending_uploads_widget.dart`

**Lines:** 27, 45, 92, 197, 205, 326, 347, 387, 622

**Problem:**

Service locator (`getIt<FailedRecordingUploadService>()`) accessed directly in UI code. This couples the widget to the DI framework, makes testing impossible without real services, and makes dependencies implicit.

**Action:**

Accept services as constructor parameters or provide via `BlocProvider`/`Provider`. Never call `getIt` in widget code.

---

### 12. No Race Condition Protection on `loadAll()`

**File:** `utils/crud/resource_cubit.dart:90-133`

**Problem:**

Multiple rapid calls to `loadAll()` fire parallel API requests with no debounce, no request deduplication, and no cancellation of stale requests. Both responses write to Isar, leading to state inconsistency.

**Action:**

Add request deduplication using a `Completer` or cancellation token:

```dart
CancelToken? _activeCancelToken;

Future<void> loadAll({...}) async {
  _activeCancelToken?.cancel();
  _activeCancelToken = CancelToken();
  // ... pass to API call
}
```

---

### 13. No Security Scanning in CI/CD

**Files:** All workflow files in `.github/workflows/`

**Problem:**

- No dependency vulnerability scanning
- No SAST (static application security testing)
- No secret scanning to prevent accidental commits
- Dependabot configured but not blocking

**Action:**

- Enable GitHub secret scanning in repository settings
- Add dependency scanning step to CI
- Consider adding `dart pub global activate dependency_validator`
- Make Dependabot a blocking check before merge

---

### 14. Firebase Credentials Written to Disk in Workflows

**File:** `.github/workflows/main.yaml:158-159,225`

**Problem:**

Firebase service account JSON written directly to home directory in plain text. No cleanup if job fails.

**Action:**

Use environment variables directly instead of writing to disk:

```yaml
- name: Setup Firebase
  env:
    GOOGLE_APPLICATION_CREDENTIALS: ${{ secrets.FIREBASE_SERVICE_ACCOUNT }}
```

---

### 15. Missing Error Handling in Socket Service

**File:** `services/socket_service.dart:76-80,106-110`

**Problem:**

Token null check throws generic `Exception` instead of structured `Failure`. Socket errors won't be caught by centralized error handler.

**Action:**

Throw `Failure(message: '...', type: ErrorType.authentication)` for consistency.

---

### 16. Missing Stream Resource Cleanup in Database Service

**File:** `services/local_storage/isar/_base_local_db_service.dart:24-56`

**Problem:**

Each DB service duplicates stream controller creation/cleanup logic. Base class has no `dispose()` method. Streams remain open indefinitely.

**Action:**

Add `dispose()` to base class. Call it from DI container teardown or cubit `close()`.

---

### 17. VideoPlayerController Leaks on URL Change

**File:** `features/home/missions/mission_details/widgets/gallery/video_player_widget.dart:18-63`

**Problem:**

No `didUpdateWidget()` implementation. If video URL changes, old controller is never disposed and old video stream is kept alive. Only disposed in `dispose()`.

**Action:**

Implement `didUpdateWidget()` to dispose old controller and reinitialize with new URL.

---

### 18. Potential Null Pointer in Mission DB Service

**File:** `services/local_storage/isar/mission_db_service.dart:18-20,36`

**Problem:**

Unsafe null assertions on required relationships:

```dart
final missionType = remote.missionType!;
final school = remote.school!;
final contacts = remote.school!.contacts!;
```

App crashes if API returns mission without `missionType`, `school`, or `contacts`.

**Action:**

Add null safety checks with fallback values or return early with error.

---

## Medium Issues

### 19. Arbitrary 100ms Delay in Bootstrap

**File:** `bootstrap.dart:56`

**Problem:**

```dart
await Future<dynamic>.delayed(const Duration(milliseconds: 100));
```

Comment says "Ensure timezone data is loaded" but an arbitrary delay doesn't guarantee this. It's a race condition, not a fix.

**Action:**

Use proper synchronization primitives or initialization completion callbacks.

---

### 20. Token Stored with 3-Day Expiry, No Refresh Flow

**File:** `services/local_storage/hive/auth_hive_service.dart:12-13`

**Problem:**

```dart
putWithExpiry('accessToken', token, const Duration(days: 3));
```

Forces re-login every 3 days with no refresh token mechanism.

**Action:**

Implement a refresh token flow with automatic token renewal before expiry.

---

### 21. Singletons Never Reset on Logout

**File:** `utils/singletons.dart:52-136`

**Problem:**

80+ singletons retain previous session state after logout. `AuthService`, `SocketService`, etc. are never reset. Data from one user session leaks into the next.

**Action:**

Implement cleanup method in sign-out flow to reset all stateful services. Consider using `getIt.resetLazySingleton()` for services that hold user state.

---

### 22. Hardcoded User-Facing Strings (Bypass l10n)

**Files:**

- `pending_uploads_widget.dart:76,124,138-140`
- `live_recording_widget.dart:169,248`
- `video_player_widget.dart:145,166`
- `google_sign_in_cubit.dart:29`
- `audio_recording_cubit.dart:53-55,84-87,104-108,145-150`

**Problem:**

Dozens of hardcoded English strings in widgets and cubits:

- `'No pending uploads for this session'`
- `'Pending Uploads'`
- `'Recordings are saved locally and will upload when you are online.'`
- `'Google Sign in failed'`

These bypass the localization system (`app_en.arb`) and make i18n impossible.

**Action:**

Move all user-facing strings to ARB localization files and use `context.l10n`.

---

### 23. APK Builds Not Obfuscated

**File:** `Makefile:17`

**Problem:**

APK target lacks `--obfuscate --split-debug-info=debug-symbols` (AAB has it on line 23). Distributing readable bytecode via Firebase App Distribution.

**Action:**

```makefile
apk:
    flutter build apk --flavor production --target lib/main_production.dart --release --obfuscate --split-debug-info=debug-symbols -v
```

---

### 24. Flutter Version Mismatch Between pubspec and CI

**Files:**

- `pubspec.yaml:8` requires `^3.41.1`
- All CI workflows pin `flutter-version: 3.38.5`

**Problem:**

CI uses a Flutter version 3 minor versions behind what `pubspec.yaml` requires. Builds may behave differently locally vs CI.

**Action:**

Update all workflows to use `3.41.1` or later.

---

### 25. Disabled Linting Rules With Open TODO

**File:** `analysis_options.yaml:10-15`

**Problem:**

Five important rules suppressed indefinitely:

```yaml
# TODO: Remove these gradually
avoid_catches_without_on_clauses: ignore
document_ignores: ignore
discarded_futures: ignore
lines_longer_than_80_chars: ignore
use_build_context_synchronously: ignore
```

**Action:**

Create tracked issues for each rule re-enablement. Set deadlines. Consider enforcing stricter rules for new code only.

---

### 26. Inconsistent Error Handling Patterns Across Cubits

**Problem:**

- Some cubits log with `Logger().e()`, others with `Logger().d()`, some have no logging
- Some use `late` keyword, others direct parameter assignment
- Some emit loading states, others skip straight to loaded/error

**Action:**

Standardize on one cubit pattern (see [Code Patterns to Enforce](#code-patterns-to-enforce)).

---

### 27. Multiple Nested StreamBuilders in Widget

**File:** `pending_uploads_widget.dart:26-191`

**Problem:**

Multiple nested `StreamBuilder` calls (lines 44, 91, 324, 346, 386) monitoring the same stream create excessive rebuilds.

**Action:**

Use a single BLoC that combines streams into one state object.

---

### 28. Business Logic in Video Player Widget

**File:** `video_player_widget.dart:77-97,100-115`

**Problem:**

Widget directly calls `SystemChrome.setEnabledSystemUIMode()` and `SystemChrome.setPreferredOrientations()`. Full-screen state management belongs in a cubit.

**Action:**

Extract full-screen management to a separate cubit/provider.

---

### 29. Missing Environment Secrets Documentation

**Files:** Workflows and README

**Problem:**

No documented list of required GitHub Secrets. New team members won't know what to configure. Required secrets include:

- `SHOREBIRD_TOKEN`
- `RELEASE_KEYSTORE` / `RELEASE_KEYSTORE_PASSPHRASE` / `RELEASE_KEYSTORE_PASSWORD` / `RELEASE_KEYSTORE_ALIAS`
- `FIREBASE_SERVICE_ACCOUNT` / `FIREBASE_DEV_APP_ID` / `FIREBASE_PROD_APP_ID`
- `ANDROID_PACKAGE_NAME`
- `PLAY_STORE_CREDENTIALS`
- `HUAWEI_CLIENT_ID` / `HUAWEI_CLIENT_KEY` / `HUAWEI_APP_ID`

**Action:**

Create a `SECRETS_SETUP.md` documenting all required secrets and their purposes.

---

### 30. Dio Client Cache Never Cleared

**File:** `lib/utils/http/network.dart:23-24`

**Problem:**

```dart
final Map<String, Dio> _dioCache = {};
```

Dio instances cached indefinitely. Each holds connections and interceptors. `clearCache()` exists but is never called.

**Action:**

Call `clearCache()` on logout. Consider adding TTL to cached instances.

---

### 31. No Connectivity Check Before Upload Retry

**File:** `services/failed_recording_upload_service.dart:197-204`

**Problem:**

`_hasInternetConnection()` only checks DNS lookup to `google.com`. May return true even if the backend is unreachable.

**Action:**

Check actual backend health endpoint instead of Google DNS.

---

### 32. Isar Stream Subscription Has No Rate Limiting

**File:** `utils/crud/resource_cubit.dart:44-50`

**Problem:**

```dart
_isarStreamSubscription = dbService?.stream.listen((_) {
  if (!isClosed) {
    loadAll(filters: _lastFilters);
  }
});
```

If Isar stream emits continuously, `loadAll()` is called repeatedly without debounce, causing excessive API calls.

**Action:**

Add debounce/throttle to the stream subscription.

---

### 33. Wrong Type in Localization ARB File

**File:** `lib/l10n/arb/app_en.arb:224`

**Problem:**

```json
"password": {
  "type": "int"  // Should be "String"
}
```

Could cause runtime localization errors.

**Action:**

Change `"int"` to `"String"`.

---

### 34. Azure Connection String Exposure

**File:** `services/media_service.dart:85-87`

**Problem:**

Azure connection string passed through config and used directly. If config is serialized or logged, Azure credentials are exposed.

**Action:**

Use Azure SAS tokens with short expiry instead of full connection strings.

---

### 35. Missing Temp File Cleanup in Media Service

**File:** `services/media_service.dart:328-339,386-406,440-460`

**Problem:**

Directories and file copies created but not cleaned up on exceptions. Temporary media files accumulate in app directory.

**Action:**

Use `try-finally` for temp directory cleanup. Implement periodic cache cleaning.

---

## Low Issues

### 36. Catch-All Rethrow With No Context

**File:** `services/api/_base_api_service.dart:70-72,95-96`

**Problem:**

```dart
catch (e) {
  rethrow;
}
```

This pattern appears 12+ times. Rethrowing without logging loses context.

**Action:**

Log with context before rethrowing, or remove the empty catch-rethrow entirely.

---

### 37. Repetitive Route Definitions

**File:** `utils/router/router.dart:6-176`

**Problem:**

40+ routes with near-identical boilerplate `CustomRoute<dynamic>(...)` definitions.

**Action:**

Create a helper function to reduce duplication.

---

### 38. Only English Localization

**File:** `l10n.yaml:1-4`

**Problem:**

Only `app_en.arb` exists. No other languages supported and no fallback strategy documented.

**Action:**

Document language support plan. If multi-language is planned, add locale structure now.

---

### 39. No CHANGELOG or Release Notes

**Problem:**

No `CHANGELOG.md` file. Version (`2.77.00+27700`) is hardcoded but no history is maintained.

**Action:**

Create `CHANGELOG.md` following Semantic Versioning conventions.

---

### 40. Deeply Nested Widget Trees Without Extraction

**File:** `features/home/wrapped/pages/wrapped_pages.dart:70-87,130-155,229-246,497-520`

**Problem:**

Many columns/rows with 3+ levels of nesting without extraction to named widgets.

**Action:**

Extract frequently nested patterns to separate widget classes.

---

## Code Patterns to Enforce

| Pattern | Current State | Required Standard |
|---------|--------------|-------------------|
| **Null safety** | Force-unwrap (`!`) used freely | Always guard with null check + error state |
| **Error handling** | `catch (e) { emit(loaded()) }` | Always emit distinct error state; never swallow |
| **DI in widgets** | `getIt<Service>()` in build methods | Inject via constructor or `BlocProvider` |
| **Cubit lifecycle** | Missing loading/error states | Every async method: emit loading → try/emit loaded → catch/emit error |
| **Stream cleanup** | StreamControllers left open | Every `StreamController` must have a matching `close()` in `dispose()` |
| **Localization** | Hardcoded English strings | All user-facing text through `context.l10n` |
| **Request signing** | App secret on client | Move HMAC signing server-side; use JWT for client auth |
| **Network layer** | Directly manages auth state | Throw typed exceptions; let auth layer handle state |
| **Testing** | 0 unit tests | Minimum 80% coverage for new code; `bloc_test` for all cubits |
| **CI/CD** | No test gate on PRs | `flutter test --coverage` required to merge |
| **Enum serialization** | Mixed `EnumType.name` and `.ordinal32` | Standardize on `EnumType.name` across all Isar models |
| **Logging** | Inconsistent (`Logger().e()` vs `.d()` vs none) | Always `Logger().e()` in catch blocks with context message |

---

## Priority Action Plan

| Priority | Action | Impact | Effort |
|----------|--------|--------|--------|
| **P0** | Scrub credentials from git history | Security breach prevention | Low |
| **P0** | Fix all force-unwraps with null guards | Crash prevention | Medium |
| **P0** | Close all unclosed StreamControllers | Memory leak fix | Low |
| **P0** | Fix FCM token ordering in sign-in flow | Auth state consistency | Low |
| **P1** | Delete `singletons.dart`, consolidate DI | Architecture clarity | Low |
| **P1** | Add test infrastructure + PR gate | Regression prevention | High |
| **P1** | Decouple network layer from auth state | Testability + SoC | Medium |
| **P1** | Fix enum serialization mismatch | Data integrity | Low |
| **P1** | Add security scanning to CI/CD | Vulnerability detection | Medium |
| **P2** | Localize all hardcoded strings | i18n readiness | High |
| **P2** | Add request deduplication to ResourceCubit | Performance | Medium |
| **P2** | Implement token refresh flow | UX improvement | Medium |
| **P2** | Fix Flutter version mismatch in CI | Build consistency | Low |
| **P2** | Re-enable suppressed linting rules | Code quality | Medium |
| **P3** | Add obfuscation to APK builds | Security hardening | Low |
| **P3** | Document required GitHub Secrets | Onboarding | Low |
| **P3** | Clean up temp files in media service | Storage management | Low |
| **P3** | Create CHANGELOG.md | Release tracking | Low |

---

## Summary

| Severity | Count |
|----------|-------|
| **Critical** | 6 |
| **High** | 12 |
| **Medium** | 17 |
| **Low** | 5 |
| **Total** | **40** |

The most impactful improvements would be addressing the credential exposure (P0), null safety crashes (P0), and establishing a testing baseline (P1).
