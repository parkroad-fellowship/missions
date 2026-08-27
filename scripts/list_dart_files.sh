#!/usr/bin/env bash
# Lists every .dart file in the Flutter project (excluding build artifacts,
# generated plugin registrants, and tool caches), relative to the app root.
#
# Usage:
#   ./scripts/list_dart_files.sh            # print all files
#   ./scripts/list_dart_files.sh | wc -l    # count them

set -euo pipefail

cd "$(dirname "$0")/.."

find . \
  -name "*.dart" \
  -not -path "./build/*" \
  -not -path "./.dart_tool/*" \
  -not -path "*/ephemeral/*" \
  -not -name "*.g.dart" \
  -not -name "*.freezed.dart" \
  -not -name "*.gr.dart" \
  -not -name "app_localizations*.dart" \
  | sed 's|^\./||' \
  | sort
