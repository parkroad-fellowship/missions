#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

# Baselines captured at migration start.
BASELINE_INDEX_IMPORTS=0
BASELINE_NON_FEATURE_FEATURE_IMPORTS=54

if ! command -v rg >/dev/null 2>&1; then
  echo "ripgrep (rg) is required for architecture guardrails."
  exit 1
fi

count_index_imports="$( (rg --glob '*.dart' --no-heading --line-number "_index\\.dart" lib || true) | wc -l | tr -d ' ' )"
count_non_feature_feature_imports="$( (rg --glob '*.dart' --no-heading --line-number "^import 'package:app/features/" lib --glob '!lib/features/**' || true) | wc -l | tr -d ' ' )"

echo "Architecture guardrails summary"
echo "- _index.dart references: ${count_index_imports} (baseline: ${BASELINE_INDEX_IMPORTS})"
echo "- non-feature -> feature imports: ${count_non_feature_feature_imports} (baseline: ${BASELINE_NON_FEATURE_FEATURE_IMPORTS})"

status=0

if (( count_index_imports > BASELINE_INDEX_IMPORTS )); then
  echo
  echo "Violation: _index.dart references increased beyond baseline."
  echo "Replace new barrel usage with direct imports."
  status=1
fi

if (( count_non_feature_feature_imports > BASELINE_NON_FEATURE_FEATURE_IMPORTS )); then
  echo
  echo "Violation: non-feature code imported additional feature internals."
  echo "Route imports through feature module entrypoints/public APIs instead."
  status=1
fi

# Hard guardrail that should always remain zero: top-level feature-to-feature imports.
# For the current structure, top-level features are under lib/features/<name>/.
# This forbids auth <-> home direct internal imports.
cross_feature_imports=""
while IFS=':' read -r file line_no rest; do
  [[ -z "${file}" ]] && continue

  rel_path="${file#*lib/features/}"
  owner="${rel_path%%/*}"

  if [[ "${rest}" =~ package:app/features/([^/]+)/ ]]; then
    target="${BASH_REMATCH[1]}"
    if [[ -n "${owner}" && "${owner}" != "${target}" ]]; then
      cross_feature_imports+="${file}:${line_no}:${rest}"$'\n'
    fi
  fi
done < <(rg --glob '*.dart' --no-heading --line-number "^import 'package:app/features/" lib/features || true)

if [[ -n "$cross_feature_imports" ]]; then
  echo
  echo "Violation: top-level feature-to-feature imports detected:"
  echo "$cross_feature_imports"
  status=1
fi

if (( status != 0 )); then
  exit "$status"
fi

echo "Architecture guardrails passed."
