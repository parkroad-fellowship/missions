#!/bin/sh

# Fail this script if any subcommand fails.
set -e

# debug log
set -x

# The default execution directory of this script is the ci_scripts directory.
cd $CI_PRIMARY_REPOSITORY_PATH  # Change working directory to the root of your cloned repo.

# Install Flutter using git.
git clone --filter=blob:none --no-checkout https://github.com/flutter/flutter.git $HOME/flutter
cd $HOME/flutter
git checkout 3.29.0

# Add Flutter to PATH for the current session.
export PATH="$PATH:$HOME/flutter/bin"

# Step out of the Flutter folder.
cd $CI_PRIMARY_REPOSITORY_PATH

app_env="$APP_ENV"
if [ "$app_env" = "production" ]; then
  # Rename main_production.dart to main.dart
  mv lib/main_production.dart lib/main.dart
fi

if [ "$app_env" = "staging" ]; then
  # Rename main_staging.dart to main.dart
  mv lib/main_staging.dart lib/main.dart
fi

if [ "$app_env" = "development" ]; then
  # Rename main_development.dart to main.dart
  mv lib/main_development.dart lib/main.dart
fi

# Install Flutter artifacts for iOS (--ios), or macOS (--macos) platforms.
flutter precache --ios

# Install Flutter dependencies.
flutter pub get

# # Check for any formatting issues
# dart format --set-exit-if-changed lib test

# Run code gen
dart run build_runner build --delete-conflicting-outputs

# # Run static analysis
# flutter analyze lib

# Install CocoaPods using Homebrew.
HOMEBREW_NO_AUTO_UPDATE=1 brew install cocoapods

# Install CocoaPods dependencies.
cd ios && pod install --repo-update --verbose && cd ..

exit 0