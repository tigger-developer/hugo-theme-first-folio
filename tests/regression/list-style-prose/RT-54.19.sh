# shellcheck shell=bash
# ABOUTME: RT-54.19 — `list_style: prose` page contains no .carousel-container.

# What user action does this test simulate?
#   The user opens /profile/ (list_style: prose). No carousel of pinned pages
#   should appear — prose mode is for landing pages that compose their own body.
# What would the user observe?
#   No rotating carousel.

run_test() {
    local build
    if ! build=$(build_examplesite); then return 1; fi
    local page="$build/profile/index.html"

    if [[ ! -f "$page" ]]; then
        printf '    expected built page at %s\n' "$page" >&2
        return 1
    fi

    if grep -q 'class="carousel-container"' "$page"; then
        printf '    found .carousel-container in /profile/ — prose mode should not render the carousel\n' >&2
        return 1
    fi
    return 0
}
