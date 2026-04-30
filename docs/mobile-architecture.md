# Mobile App Architecture

## Overview

PRF Missions follows a modular Flutter architecture centered around feature isolation, Cubit state management, and clear domain boundaries.

## Core Structure

- `lib/features/`: User-facing feature modules.
- `lib/di/`: Dependency injection modules and container setup.
- `lib/enums/`: Shared enums and domain constants.
- `integration_test/`: End-to-end and screenshot tests.

## Release Readiness

Run these before release:

- `dart format .`
- `flutter analyze`
- `flutter test`
