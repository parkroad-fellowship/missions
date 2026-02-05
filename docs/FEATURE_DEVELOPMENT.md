# Feature Development Guide

This guide walks through creating a new feature in the PRF Super App.

## Feature Structure

Every feature should follow this structure:

```
lib/features/home/{feature_name}/
├── _index.dart              # Optional barrel export
├── cubit/                   # No barrel file - use direct imports
│   ├── {action}_cubit.dart
│   └── {action}_state.dart
├── widgets/                 # Optional
│   └── {widget_name}.dart
├── actions/                 # Modal sheets/dialogs
│   └── {action_name}/
│       ├── {action_name}.dart
│       ├── _handset.dart
│       └── _tablet.dart
├── {feature_name}.dart      # Main aggregator
├── _handset.dart            # Mobile layout
└── _tablet.dart             # Tablet layout
```

## Step-by-Step Guide

### 1. Create the Feature Directory

```bash
mkdir -p lib/features/home/{feature_name}/{cubit,widgets,actions}
```

### 2. Create the Cubit

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

### 3. Create the UI Components

**{feature_name}.dart:**
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

### 4. Register in DI Module

Add to the appropriate module in `lib/di/modules/`:

```dart
static void register(GetIt getIt) {
  // Register cubit
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

### 5. Add Route

In `lib/utils/router/router.dart`:

```dart
AutoRoute(
  page: {FeatureName}Route.page,
  path: '{feature-name}',
),
```

### 6. Run Code Generation

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Best Practices

1. **One cubit per use case** - Keep cubits focused on a single responsibility
2. **Direct imports for cubits** - Import cubits directly, no barrel files for cubits
3. **Barrel exports for services only** - Only `lib/services/` uses `_index.dart`
4. **Responsive layouts** - Always create both `_handset.dart` and `_tablet.dart`
5. **Error handling** - Use `Failure` class for consistent error representation
6. **Naming conventions** - Follow the established patterns (see FOLDER_CONVENTIONS.md)
