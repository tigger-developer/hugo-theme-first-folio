# shellcheck shell=bash
# ABOUTME: RT-61.12 — print.css does NOT override font-family on headings, pull-quote, code, pre, kbd.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local css; css="$(print_css_path)" || return 1
    # Look for any rule selecting h1-h6, .pull-quote, code, pre, kbd that sets font-family.
    # If found, the test fails — those fonts must remain at their screen typeface.
    local offenders=()
    # Bash-portable inspection
    if grep -qE '(^|,|[[:space:]])(h[1-6])([[:space:]]|,|\{)[^{}]*\{[^}]*font-family' "$css"; then
        offenders+=("h1-h6")
    fi
    if grep -qE '\.pull-quote[^{]*\{[^}]*font-family' "$css"; then
        offenders+=(".pull-quote")
    fi
    if grep -qE '(^|,|[[:space:]])(code|pre|kbd)([[:space:]]|,|\{)[^{}]*\{[^}]*font-family' "$css"; then
        offenders+=("code/pre/kbd")
    fi
    if (( ${#offenders[@]} > 0 )); then
        printf '    print.css unexpectedly overrides font-family on: %s\n' "${offenders[*]}" >&2
        return 1
    fi
    return 0
}
