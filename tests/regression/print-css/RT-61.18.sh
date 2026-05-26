# shellcheck shell=bash
# ABOUTME: RT-61.18 — print.css forces <details> content to be visible regardless of [open] state.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local css; css="$(print_css_path)" || return 1
    # Look for a details rule that forces visibility of children
    if ! grep -qE 'details[^{]*\{' "$css"; then
        printf '    no rule targeting <details>\n' >&2
        return 1
    fi
    # Either details > * { display: block } or details:not([open]) > *:not(summary)
    if ! grep -qE 'details[^{]*>[[:space:]]*\*[^{]*\{[^}]*display:[[:space:]]*(block|contents|inline|inherit|revert|initial)' "$css"; then
        printf '    no details > * { display: ... } rule forcing visibility\n' >&2
        return 1
    fi
    return 0
}
