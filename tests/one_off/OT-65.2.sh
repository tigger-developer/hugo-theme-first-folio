#!/usr/bin/env bash
# ABOUTME: OT-65.2 - verify the upstream Hugo theme portal PR deploy preview is passing.
# ABOUTME: Set THEME_PORTAL_PR to the pull request number in gohugoio/hugoThemesSiteBuilder.
set -euo pipefail

pr="${THEME_PORTAL_PR:-}"
if [[ -z "$pr" ]]; then
    printf 'THEME_PORTAL_PR must be set to the upstream PR number\n' >&2
    exit 2
fi

state="$(gh pr view "$pr" --repo gohugoio/hugoThemesSiteBuilder --json statusCheckRollup --jq '
  [.statusCheckRollup[] | select(.name | test("deploy|build|preview"; "i")) | .conclusion] | unique | join(",")
')"

if [[ "$state" != "SUCCESS" ]]; then
    printf 'expected deploy/build/preview status SUCCESS, got %s\n' "$state" >&2
    exit 1
fi
