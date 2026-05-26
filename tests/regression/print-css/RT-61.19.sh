# shellcheck shell=bash
# ABOUTME: RT-61.19 — print.css hides <video> and <iframe>.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local flat; flat="$(print_css_flat)" || return 1
    if ! echo "$flat" | grep -qE '\bvideo\b[^{]*\{[^}]*display:[[:space:]]*none'; then
        printf '    no display:none rule for <video>\n' >&2
        return 1
    fi
    if ! echo "$flat" | grep -qE '\biframe\b[^{]*\{[^}]*display:[[:space:]]*none'; then
        printf '    no display:none rule for <iframe>\n' >&2
        return 1
    fi
    return 0
}
