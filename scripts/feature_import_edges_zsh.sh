#!/usr/bin/env zsh
ROOT_DIR="$(cd "$(dirname "${(%):-%N}")/.." && pwd)"
cd "$ROOT_DIR"

if ! command -v rg >/dev/null 2>&1; then
  echo "ripgrep (rg) is required for edge reporting."
  exit 1
fi

echo "Feature import edges (owner -> target)"

typeset -A edges

while IFS=':' read -r file line_no rest; do
  [[ -z "$file" ]] && continue

  rel="${file#*lib/features/}"
  owner="${rel%%/*}"

  if [[ "$rest" =~ "package:app/features/([^/]+)/" ]]; then
    target="${match[1]}"
    key="${owner}->${target}"
    if [[ -z "${edges[$key]}" ]]; then
      edges[$key]=1
    else
      edges[$key]=$((edges[$key] + 1))
    fi
  fi
done < <(rg --glob '*.dart' --no-heading --line-number "^import 'package:app/features/" lib/features)

if [[ ${#edges} -eq 0 ]]; then
  echo "No feature-to-feature import edges found."
else
  for key in "${(k)edges[@]}"; do
    echo "${key}: ${edges[$key]}"
  done | sort
fi

echo

echo "Non-feature to feature import edges (path -> target)"
rg --glob '*.dart' --no-heading --line-number "^import 'package:app/features/" lib --glob '!lib/features/**' \
  | sed -E "s#^([^:]+):([0-9]+):import 'package:app/features/([^/]+)/.*#\1 -> \3#" \
  | sort \
  | uniq -c \
  | sort -nr
