# shellcheck shell=bash
# ABOUTME: RT-76.20 - revealed spoiler text uses body colour at full opacity and the block label is one rem.
# ABOUTME: The assertions inspect the stylesheet delivered by the built example site.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local main_css
    main_css="$(spoiler_built_css "main")" || return 1

    local content_rule
    content_rule="$(grep -A 4 '^\.spoiler__content {' "$main_css")"
    grep -qF 'color: inherit;' <<< "$content_rule" || return 1
    grep -qF 'opacity: 1;' <<< "$content_rule" || return 1

    local label_rule
    label_rule="$(grep -A 16 '^\.spoiler--block > \.spoiler__label \.spoiler__control-label {' "$main_css")"
    grep -qF 'font-size: 1rem;' <<< "$label_rule"
}
