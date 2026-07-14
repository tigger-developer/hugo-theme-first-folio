# shellcheck shell=bash
# ABOUTME: RT-76.14 - concealed spoilers ship inert symbol masks without protected words.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(spoiler_example_page)" || return 1

    [[ "$(htmlq -f "$page" '.spoiler--inline > .spoiler__label > .spoiler__mask[inert][aria-hidden="true"]' | grep -c 'spoiler__mask')" -eq 4 ]] || return 1
    [[ "$(htmlq -f "$page" '.spoiler--block > .spoiler__mask[inert][aria-hidden="true"]' | grep -c 'spoiler__mask')" -eq 1 ]] || return 1

    local mask_text
    mask_text="$(htmlq -f "$page" -t '.spoiler__mask')"
    if grep -qE 'saboteur|missing diary|red key|blue door|letters stopped|opening mystery' <<< "$mask_text"; then
        return 1
    fi
    grep -qE '[—·×]' <<< "$mask_text" || return 1

    local fonts_css
    fonts_css="$(spoiler_built_css "fonts")" || return 1
    grep -qF "font-family: 'First Folio Spoiler Mask'" "$fonts_css" || return 1

    local build_dir
    build_dir="$(build_examplesite)" || return 1
    [[ -s "$build_dir/fonts/FirstFolioSpoilerMask.woff2" ]]
}
