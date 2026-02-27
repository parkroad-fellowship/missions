# PRF Super App

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

A Flutter-based mobile application built with a clean, modular architecture. Supports iOS, Android, Web, and Windows.

## Quick Start

```sh
# Development
flutter run --flavor development --target lib/main_development.dart

# Staging
flutter run --flavor staging --target lib/main_staging.dart

# Production
flutter run --flavor production --target lib/main_production.dart
```

## Documentation

See [docs/DOCUMENTATION.md](docs/DOCUMENTATION.md) for the full project documentation, including:

- Project structure and architecture
- Folder conventions and naming rules
- State management patterns (Cubit)
- Service layer and error handling
- Feature development guide
- Code generation workflow
- Key dependencies
- Testing and translations

[coverage_badge]: coverage_badge.svg
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
