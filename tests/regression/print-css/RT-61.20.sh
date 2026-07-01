# shellcheck shell=bash
# ABOUTME: RT-61.20 — print.css emits a ::after text affordance for hidden media (video/iframe).

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local flat; flat="$(print_css_flat)" || return 1
    if ! echo "$flat" | grep -qE '(\.video|\.cf-stream|\.video-wrapper|figure\.video|video|iframe)[^{]*::after[^{]*\{[^}]*content:'; then
        # Try without file (only the flat string)
        if ! echo "$flat" | grep -qE '(\.video|\.cf-stream|\.video-wrapper|figure\.video)[^{,]*::after[^{]*\{[^}]*content:'; then
            printf '    no ::after content affordance for hidden video/iframe media\n' >&2
            return 1
        fi
    fi
    return 0
}
