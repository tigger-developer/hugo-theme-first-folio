# shellcheck shell=bash
# ABOUTME: RT-61.16 — print.css does NOT add URL expansion to internal anchor or relative links.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local css; css="$(print_css_path)" || return 1
    if grep -qE 'a\[href\^=["\047]?#["\047]?\]::after' "$css"; then
        printf '    print.css applies ::after to internal anchor links — should not\n' >&2
        return 1
    fi
    if grep -qE 'a\[href\^=["\047]?/["\047]?\]::after' "$css"; then
        printf '    print.css applies ::after to relative path links — should not\n' >&2
        return 1
    fi
    # The expansion rule should be scoped to http (RT-61.15 already proves it exists)
    return 0
}
