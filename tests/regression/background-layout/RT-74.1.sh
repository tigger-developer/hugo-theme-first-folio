# shellcheck shell=bash
# ABOUTME: RT-74.1 - dark background pages keep their image canvas fixed to the viewport.
# ABOUTME: Verifies the rendered exampleSite CSS and pages a browser receives.

run_test() {
    local build_dir
    build_dir="$(build_examplesite)" || return 1

    local css_file
    css_file="$(find "$build_dir/css" -name 'theme.*.css' -print -quit)"
    if [[ -z "$css_file" ]]; then
        printf '    theme CSS artefact not found under %s/css/\n' "$build_dir" >&2
        return 1
    fi

    local print_css_file
    print_css_file="$(find "$build_dir/css" -name 'print.*.css' -print -quit)"
    if [[ -z "$print_css_file" ]]; then
        printf '    print CSS artefact not found under %s/css/\n' "$build_dir" >&2
        return 1
    fi

    local background_page="$build_dir/journal/background-images/index.html"
    local podcast_page="$build_dir/podcast-demo/index.html"
    local audiobook_page="$build_dir/audiobook-demo/index.html"

    htmlq -f "$background_page" '.post-container.dark-bg' | grep -q '<' || return 1
    htmlq -f "$podcast_page" '.post-container.audio-layout.dark-bg' | grep -q '<' || return 1
    htmlq -f "$audiobook_page" '.post-container.audio-layout.dark-bg' | grep -q '<' || return 1

    local css_flat
    css_flat="$(tr '\n' ' ' < "$css_file")"

    if ! grep -qE '\.post-container\.dark-bg::before[^{]*\{[^}]*position:[[:space:]]*fixed' <<< "$css_flat"; then
        printf '    dark background pseudo-element is not fixed to the viewport\n' >&2
        return 1
    fi
    if ! grep -qE '\.post-container\.dark-bg::before[^{]*\{[^}]*inset:[[:space:]]*0' <<< "$css_flat"; then
        printf '    dark background pseudo-element does not cover the viewport\n' >&2
        return 1
    fi
    if ! grep -qE '\.post-container\.dark-bg::before[^{]*\{[^}]*background-repeat:[[:space:]]*no-repeat' <<< "$css_flat"; then
        printf '    dark background pseudo-element can still tile below the viewport\n' >&2
        return 1
    fi

    local print_css_flat
    print_css_flat="$(tr '\n' ' ' < "$print_css_file")"

    if ! grep -qE '\.post-container::before,[[:space:]]*\.post-container\.dark-bg::before[^{]*\{[^}]*background-image:[[:space:]]*none[[:space:]]*!important' <<< "$print_css_flat"; then
        printf '    print CSS does not suppress the dark background pseudo-element image\n' >&2
        return 1
    fi
}
