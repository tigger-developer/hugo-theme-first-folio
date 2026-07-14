# shellcheck shell=bash
# ABOUTME: RT-78.21 - valid optional review combinations build without diagnostics.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local out err
    out="$(mktemp -d "$REGRESSION_TMP/review-valid-diagnostic-XXXXXX")"
    err="$(mktemp "$REGRESSION_TMP/review-valid-diagnostic-stderr-XXXXXX")"
    hugo --source "$FIXTURES_ROOT/review-valid" --destination "$out" --themesDir "$THEME_ROOT/.." --theme "$(basename "$THEME_ROOT")" > /dev/null 2>"$err" || return 1
    ! grep -qE 'review\.(title|artwork|rating|itemType)' "$err"
}
