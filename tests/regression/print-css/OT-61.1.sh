# shellcheck shell=bash
# ABOUTME: OT-61.1 — built site contains a fingerprinted print.css artefact under /css/.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local css; css="$(print_css_path)" || return 1
    if [[ ! -s "$css" ]]; then
        printf '    print.css exists but is empty: %s\n' "$css" >&2
        return 1
    fi
    return 0
}
