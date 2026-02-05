# PRF Super App Architecture

## Overview

The PRF Super App is a Flutter-based mobile application built with a clean, modular architecture that separates concerns into distinct layers. This document provides an overview of the application structure and key architectural decisions.

## Project Structure

```
lib/
├── di/                    # Dependency Injection
│   ├── di_container.dart  # Main DI orchestrator
│   └── modules/           # Domain-specific DI modules
├── enums/                 # Application enums (organized by domain)
│   ├── common/            # Environment, platform, notifications
│   ├── mission/           # Mission-related enums
│   ├── payment/           # Payment status, charge types
│   ├── event/             # Event types
│   └── member/            # Member roles, membership types
├── features/              # Feature modules (UI + business logic)
│   ├── auth/              # Authentication feature
│   └── home/              # Main app features
│       ├── shared/        # Shared home-level resources
│       │   └── cubit/     # Shared cubits across home features
│       ├── missions/      # Mission management
│       │   ├── cubit/     # Mission list-level cubits
│       │   └── mission_details/
│       │       └── widgets/
│       │           ├── debrief_notes/cubit/  # Debrief cubits
│       │           ├── sessions/cubit/       # Session cubits
│       │           ├── souls/cubit/          # Soul cubits
│       │           └── gallery/cubit/        # Gallery cubits
│       ├── giving/        # Donations/payments
│       ├── events/        # Event management
│       ├── lms/           # Learning Management System
│       └── ...
├── l10n/                  # Localization
├── models/                # Data models (organized by domain)
│   ├── local/             # Isar database models
│   │   ├── mission/       # Mission-related local models
│   │   ├── course/        # Course/LMS local models
│   │   ├── media/         # Media upload models
│   │   ├── enquiry/       # Student enquiry models
│   │   └── faq/           # FAQ models
│   └── remote/            # API response models (Freezed)
│       ├── common/        # Auth, failure, config
│       ├── mission/       # Mission-related DTOs
│       ├── expense/       # Expense/allocation DTOs
│       ├── payment/       # Payment DTOs
│       ├── member/        # Member-related DTOs
│       ├── course/        # Course/LMS DTOs
│       ├── event/         # Event DTOs
│       ├── prayer/        # Prayer-related DTOs
│       ├── enquiry/       # Student enquiry DTOs
│       ├── content/       # Announcements, FAQs, debrief notes
│       ├── media/         # Media DTOs
│       └── metadata/      # Profession, marital status, church
├── services/              # Application services
│   ├── analytics/         # Analytics services
│   │   ├── analytics_service.dart        # Interface
│   │   └── posthog_analytics_service.dart
│   ├── firebase/          # Firebase services
│   │   ├── firebase_analytics_service.dart
│   │   ├── crashlytics_service.dart
│   │   └── *_impl.dart    # Implementations
│   ├── api/               # REST API services
│   └── local_storage/     # Hive & Isar services
├── shared_widgets/        # Reusable UI components
│   ├── buttons/           # Primary, secondary, destroy, google_auth
│   ├── input/             # Text, password, number, email, etc.
│   ├── error/             # Error snackbar and view
│   ├── states/            # Empty state, categories, receipt preview
│   ├── viewers/           # PDF viewer
│   ├── navbar/            # Navigation bar
│   ├── progress/          # Progress indicators
│   └── wrapped/           # Wrapped-specific widgets
└── utils/                 # Utilities & helpers
    ├── formatters/        # Date, number, string formatters
    ├── validators/        # Input validation
    ├── helpers/           # App version, device, mission, URL helpers
    ├── mixins/            # Timezone mixin
    ├── theme/             # PRF theme configuration
    ├── http/              # Network utilities
    └── router/            # Auto-route configuration & guards
```

## Key Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_bloc` | State management (Cubit pattern) |
| `get_it` | Dependency injection |
| `freezed` | Immutable data classes & unions |
| `auto_route` | Declarative routing |
| `isar` | Local database |
| `hive` | Key-value storage |
| `dio` | HTTP client |

## Architecture Layers

### 1. Presentation Layer (`features/`)

Contains UI code organized by feature. Each feature typically includes:
- **Pages**: Screen widgets with responsive variants (`_handset.dart`, `_tablet.dart`)
- **Cubit**: Business logic and state management
- **Widgets**: Feature-specific UI components
- **Actions**: Modal sheets and dialogs

### 2. Domain Layer (`models/`)

Data models split into:
- **Remote models**: API response DTOs using Freezed for immutability
- **Local models**: Isar collections for offline storage

### 3. Data Layer (`services/`)

Handles data operations:
- **API services**: REST API communication via Dio
- **Local storage**: Hive (settings) and Isar (structured data)

### 4. Dependency Injection (`di/`)

Modular DI configuration using GetIt:
- `DIContainer` orchestrates module registration
- Domain-specific modules register services and cubits
- Lazy singleton pattern for efficient memory usage

## State Management

The app uses the **Cubit** pattern from flutter_bloc:
- One cubit per use case
- States defined using Freezed unions
- Cubits registered via DI modules

See [STATE_MANAGEMENT.md](./STATE_MANAGEMENT.md) for detailed patterns.

## Navigation

Declarative routing with `auto_route`:
- Routes defined in `lib/utils/router/router.dart`
- Auth guard for protected routes
- Deep linking support

## Responsive Design

Adaptive UI pattern:
- Base widget with `AdaptiveBuilder`
- `_handset.dart` for mobile layouts
- `_tablet.dart` for tablet/desktop layouts

## Error Handling

Centralized error handling:
- `Failure` class with type, severity, and context
- `ErrorHandlerService` for logging, analytics, and Crashlytics
- `CrashlyticsService` for crash reporting (release mode only)
- `PRFErrorView` and `PRFErrorSnackbar` for UI feedback

See [SERVICE_LAYER.md](./SERVICE_LAYER.md) for details.

## Cubit Organization

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
