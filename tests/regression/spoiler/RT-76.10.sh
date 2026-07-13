# shellcheck shell=bash
# ABOUTME: RT-76.10 - valid spoiler examples build without spoiler diagnostics.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local out
    local err
    out="$(mktemp -d "$AGENT_TMP/ff-spoiler-valid-XXXXXX")"
    err="$(mktemp "$AGENT_TMP/ff-spoiler-valid-stderr-XXXXXX")"
    local result=1

    if hugo --source "$THEME_ROOT/exampleSite" --destination "$out" > /dev/null 2>"$err"; then
        if ! grep -qi 'spoiler shortcode' "$err"; then
            result=0
        fi
    else
        printf '    valid spoiler example build failed:\n%s\n' "$(cat "$err")" >&2
    fi

    rm -rf "$out" "$err"
    return "$result"
}
