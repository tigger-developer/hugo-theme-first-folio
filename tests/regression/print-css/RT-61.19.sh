# shellcheck shell=bash
# ABOUTME: RT-61.19 — print.css hides <video> and <iframe>.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local css; css="$(print_css_path)" || return 1
    # video and iframe must each be hidden somewhere in the file
    if ! grep -qE '(^|,|[[:space:]])video([[:space:]]|,|\{)[^{}]*\{[^}]*display:[[:space:]]*none' "$css"; then
        printf '    no display:none rule for <video>\n' >&2
        return 1
    fi
    if ! grep -qE '(^|,|[[:space:]])iframe([[:space:]]|,|\{)[^{}]*\{[^}]*display:[[:space:]]*none' "$css"; then
        printf '    no display:none rule for <iframe>\n' >&2
        return 1
    fi
    return 0
}
