# shellcheck shell=bash
# ABOUTME: RT-54.20 — `list_style: prose` page contains no .masonry-grid.

# What user action does this test simulate?
#   The user opens /profile/ (list_style: prose). No grid of cards should appear.
# What would the user observe?
#   No masonry grid of section pages.

run_test() {
    local build
    if ! build=$(build_examplesite); then return 1; fi
    local page="$build/profile/index.html"

    if [[ ! -f "$page" ]]; then
        printf '    expected built page at %s\n' "$page" >&2
        return 1
    fi

    if grep -q 'class="masonry-grid"' "$page"; then
        printf '    found .masonry-grid in /profile/ — prose mode should not render the grid\n' >&2
        return 1
    fi
    return 0
}
