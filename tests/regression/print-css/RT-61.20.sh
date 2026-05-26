# shellcheck shell=bash
# ABOUTME: RT-61.20 — print.css emits a ::after text affordance for hidden media (video/iframe).

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local css; css="$(print_css_path)" || return 1
    # An ::after with content text on a video/iframe wrapper. Be lenient about wrapper class names.
    if ! grep -qE '(video|iframe|\.video|\.cf-stream|\.video-wrapper)[^{]*::after[^{]*\{[^}]*content:' "$css"; then
        printf '    no ::after content affordance for hidden video/iframe media\n' >&2
        return 1
    fi
    return 0
}
