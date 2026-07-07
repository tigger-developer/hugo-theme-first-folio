#!/usr/bin/env bash
# ABOUTME: OT-65.4 - verify Go module resolution sees the portal-ready theme version.
# ABOUTME: Set EXPECTED_THEME_VERSION to the tag intended for portal submission.
set -euo pipefail

expected="${EXPECTED_THEME_VERSION:-}"
if [[ -z "$expected" ]]; then
    printf 'EXPECTED_THEME_VERSION must be set, for example v1.0.20\n' >&2
    exit 2
fi

resolved="$(go list -m -json "github.com/tadg-paul/hugo-theme-first-folio@$expected" | yq -p json -r '.Version')"
if [[ "$resolved" != "$expected" ]]; then
    printf 'expected module version %s, got %s\n' "$expected" "$resolved" >&2
    exit 1
fi
