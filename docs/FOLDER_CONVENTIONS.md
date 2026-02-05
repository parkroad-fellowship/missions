# Folder Conventions

This document defines the naming conventions and folder structure standards for the PRF Super App.

## Naming Conventions

### File Naming

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

**Only services and utils use barrel files (`_index.dart`)**. Everything else uses direct imports:

| Category | Barrel Files | Reason |
|----------|--------------|--------|
| Services | ✅ Yes | Reduces import clutter for API consumers |
| Utils | ✅ Yes | Convenient access to formatters, helpers, etc. |
| Models | ❌ No | Direct imports - avoid maintaining exports |
| Enums | ❌ No | Direct imports - files organized by domain |
| Cubits | ❌ No | Direct imports - colocated with features |
| Shared Widgets | ✅ Yes | Main barrel for convenience |

**Services barrel example:**
```dart
// lib/services/_index.dart
export 'analytics/analytics_service.dart';
export 'api/mission_service.dart';
export 'error_handler_service.dart';
// Don't export private files like _base_api_service.dart
```

**Direct import example:**
```dart
// Prefer direct imports for models and enums
import 'package:app/models/remote/common/auth.dart';
import 'package:app/enums/mission/prf_mission_status.dart';
```

## Responsive UI Pattern

Every page/widget with different layouts should follow this pattern:

```
feature/
├── _index.dart
├── feature.dart          # Aggregator with AdaptiveBuilder
├── _handset.dart         # Mobile layout (private)
└── _tablet.dart          # Tablet/web layout (private)
```

**Aggregator (feature.dart):**
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

## Standard Folder Structures

### Feature Structure

```
lib/features/home/{feature}/
├── _index.dart              # Optional barrel export for feature
├── cubit/                   # Feature-level cubits (NO barrel file)
│   ├── get_{feature}_cubit.dart
│   ├── get_{feature}_state.dart
│   └── {action}_cubit.dart
├── {sub_feature}/           # Sub-feature with its own cubits
│   ├── cubit/               # Sub-feature specific cubits (NO barrel file)
│   │   └── {action}_cubit.dart
│   └── widgets/
│       └── {widget}/
│           └── cubit/       # Widget-specific cubits (NO barrel file)
├── widgets/                 # Feature-specific widgets
│   └── {widget_name}.dart
├── actions/                 # Modal sheets, dialogs
│   └── {action_name}/
│       ├── {action_name}.dart
│       ├── _handset.dart
│       └── _tablet.dart
├── {feature}.dart           # Main page aggregator
├── _handset.dart
└── _tablet.dart
```

**Cubit Colocation Rule**: Cubits live in the `cubit/` folder of the feature that uses them, not in a centralized location. Import cubits directly - never use barrel files for cubits.

### Service Structure

```
lib/services/
├── _index.dart              # Main barrel export
├── api/
│   ├── _index.dart
│   ├── _base_api_service.dart  # Private base class
│   ├── mission_service.dart
│   └── payment_service.dart
├── local_storage/
│   ├── _index.dart
│   ├── hive/
│   │   ├── _index.dart
│   │   ├── _base_hive_service.dart
│   │   ├── hive_service.dart
│   │   └── auth_hive_service.dart
│   └── isar/
│       ├── _index.dart
│       ├── _base_local_db_service.dart
│       ├── isar_service.dart
│       └── mission_db_service.dart
└── error_handler_service.dart
```

### Utils Structure

```
lib/utils/
├── _index.dart
├── formatters/
│   ├── _index.dart
│   ├── date_formatter.dart
│   ├── number_formatter.dart
│   └── string_formatter.dart
├── validators/
│   ├── _index.dart
│   └── input_validators.dart
├── helpers/
│   ├── _index.dart
│   ├── app_version_helper.dart
│   ├── device_helper.dart
│   ├── mission_helper.dart
│   ├── navigation_helper.dart
│   ├── permission_helper.dart
│   └── url_helper.dart
├── mixins/
│   ├── _index.dart
│   └── timezone_mixin.dart
├── theme/
│   ├── _index.dart
│   └── prf_theme.dart
├── http/
│   ├── _index.dart
│   ├── network.dart
│   └── retry_interceptor.dart
└── router/
    ├── _index.dart
    ├── router.dart
    ├── router.gr.dart    # Generated, not exported
    └── guards/
        ├── _index.dart
        └── auth_guard.dart
```

### DI Module Structure

```
lib/di/
├── _index.dart
├── di_container.dart        # Main orchestrator
└── modules/
    ├── _index.dart
    ├── core_module.dart
    ├── firebase_module.dart
    ├── auth_module.dart
    ├── missions_module.dart
    └── ...
```

### Shared Widgets Structure

```
lib/shared_widgets/
├── _index.dart              # Main barrel export
├── buttons/
│   ├── _index.dart
│   ├── primary/
│   │   ├── _index.dart
│   │   ├── primary.dart
│   │   ├── _handset.dart
│   │   └── _tablet.dart
│   ├── secondary/
│   ├── destroy/
│   └── google_auth/
├── input/
│   ├── _index.dart
│   ├── text/
│   ├── text_area/
│   ├── password/
│   ├── number/
│   ├── email_address/
│   ├── name/
│   └── form_field_label/
├── error/
│   ├── _index.dart
│   ├── error_snackbar.dart
│   └── error_view.dart
├── states/
│   ├── _index.dart
│   ├── empty_state.dart
│   ├── categories.dart
│   └── receipt_preview.dart
├── viewers/
│   ├── _index.dart
│   └── pdf_viewer.dart
├── navbar/
│   └── _index.dart
├── progress/
│   └── _index.dart
├── home_action_card/
│   └── _index.dart
└── wrapped/
    └── _index.dart
```

## Import Guidelines

### Import Preferences

```dart
// Services: Use barrel exports
import 'package:app/services/_index.dart';

// Utils: Use barrel exports
import 'package:app/utils/_index.dart';

// Models: Use direct imports
import 'package:app/models/remote/common/auth.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:app/models/local/mission/prf_mission.dart';

// Enums: Use direct imports
import 'package:app/enums/mission/prf_mission_status.dart';
import 'package:app/enums/common/prf_environment.dart';

// Cubits: Use direct imports (NEVER use barrel files for cubits)
import 'package:app/features/home/missions/cubit/get_missions_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/cubit/get_mission_sessions_cubit.dart';

// Shared widgets: Use barrel export (for convenience)
import 'package:app/shared_widgets/_index.dart';
```

### Import Order

1. Dart SDK imports
2. Flutter imports
3. External package imports
4. Internal package imports (app/)
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

## Verification Commands

Check for missing barrel exports:

```bash
# Find directories without _index.dart
find lib -type d -exec test ! -f {}/_index.dart \; -print
```

Verify the app compiles:

```bash
flutter build apk --flavor development
```

Run static analysis:

```bash
flutter analyze
```
