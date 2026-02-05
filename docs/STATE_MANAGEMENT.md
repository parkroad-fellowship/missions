# State Management Guide

This document describes the state management patterns used in the PRF Super App using flutter_bloc and Freezed.

## Overview

The app uses the **Cubit** pattern from flutter_bloc for state management:
- Simple, testable, and predictable
- One cubit per use case
- States defined with Freezed for immutability

## Cubit Structure

### File Organization

Cubits are organized with the state as a `part` of the cubit file:

```
lib/features/auth/cubit/
├── sign_in_cubit.dart          # Main cubit file
├── sign_in_cubit.freezed.dart  # Generated freezed code
└── sign_in_state.dart          # State definitions (part of cubit)
```

### State Definition

**Example: `lib/features/auth/cubit/sign_in_state.dart`**

```dart
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

**Example: `lib/features/auth/cubit/sign_in_cubit.dart`**

```dart
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

## State Patterns

### Standard CRUD States

For typical data fetching operations:

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

### Form Submission States

For create/update operations:

```dart
@freezed
class AddExpenseState with _$AddExpenseState {
  const factory AddExpenseState.initial() = _Initial;
  const factory AddExpenseState.loading() = _Loading;
  const factory AddExpenseState.loaded({required PRFExpense expense}) = _Loaded;
  const factory AddExpenseState.error(String message) = _Error;
}
```

### Delete Operation States

```dart
@freezed
class DeleteExpenseState with _$DeleteExpenseState {
  const factory DeleteExpenseState.initial() = _Initial;
  const factory DeleteExpenseState.loading() = _Loading;
  const factory DeleteExpenseState.loaded() = _Loaded;
  const factory DeleteExpenseState.error(String message) = _Error;
}
```

## Cubit Registration

### DI Module Registration

**Example: `lib/di/modules/auth_module.dart`**

```dart
import 'package:app/features/auth/cubit/sign_in_cubit.dart';
import 'package:app/features/auth/cubit/social_login_cubit.dart';
import 'package:app/services/api/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

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

### Providing to Widget Tree

In `bootstrap.dart`:

```dart
MultiBlocProvider(
  providers: DIContainer.registerCubits(),
  child: const App(),
)
```

## UI Integration

### Using BlocConsumer

Combined builder + listener for handling both UI updates and side effects:

**Example: `lib/features/auth/sign_in/_handset.dart`**

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

### Using BlocListener

For side effects only (navigation, snackbars):

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

### Using BlocBuilder

For UI updates only:

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

## Best Practices

### 1. One Cubit Per Use Case

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

### 2. Immutable States with Freezed

```dart
// Always use const factory
const factory SignInState.loaded() = _Loaded;
```

### 3. Consistent Error Handling

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

### 4. State Pattern Matching

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

### 5. Avoid Emitting After Dispose

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

### 6. Direct Imports for Cubits

Always import cubits directly - never use barrel files for cubits:

```dart
// Correct - direct import
import 'package:app/features/auth/cubit/sign_in_cubit.dart';

// Wrong - no barrel exports for cubits
import 'package:app/features/auth/cubit/_index.dart'; // Don't do this
```

## Testing Cubits

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
