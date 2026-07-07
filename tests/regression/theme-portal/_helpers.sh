# shellcheck shell=bash
# ABOUTME: Shared helpers for issue #65 Hugo theme portal readiness tests.
# ABOUTME: Validates parsed theme metadata, preview media, and public example builds.

theme_toml_value() {
    local expression="$1"
    yq -p toml -oy -r "$expression" "$THEME_ROOT/theme.toml"
}

root_hugo_value() {
    local expression="$1"
    yq -r "$expression" "$THEME_ROOT/hugo.yaml"
}

build_theme_demo_live() {
    local out
    out="$(mktemp -d -t "ff-theme-portal-XXXXXX")"
    if hugo --quiet --source "$THEME_ROOT/exampleSite" --destination "$out" --environment theme-demo-live --minify; then
        echo "$out"
        return 0
    fi
    printf '    theme-demo-live Hugo build failed\n' >&2
    return 1
}

image_dimensions() {
    local image="$1"
    magick identify -format '%w %h' "$image"
}

expect_image_size() {
    local image="$1"
    local min_width="$2"
    local min_height="$3"
    local dimensions
    dimensions="$(image_dimensions "$image")" || return 1
    local width="${dimensions%% *}"
    local height="${dimensions##* }"

    if (( width < min_width || height < min_height )); then
        printf '    %s is %sx%s, expected at least %sx%s\n' "$image" "$width" "$height" "$min_width" "$min_height" >&2
        return 1
    fi

    if (( width * 2 != height * 3 )); then
        printf '    %s is %sx%s, expected 3:2 aspect ratio\n' "$image" "$width" "$height" >&2
        return 1
    fi
}
