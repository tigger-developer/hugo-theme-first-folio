# shellcheck shell=bash
# ABOUTME: RT-54.18 — `list_style: prose` page renders its .Content body.

# What user action does this test simulate?
#   The user opens /profile/ (an exampleSite section with list_style: prose) and
#   reads the page.
# What would the user observe?
#   The body markdown of _index.md appears on the page.

run_test() {
    local build
    if ! build=$(build_examplesite); then return 1; fi
    local page="$build/profile/index.html"

    if [[ ! -f "$page" ]]; then
        printf '    expected built page at %s — fixture page may be missing or build failed\n' "$page" >&2
        return 1
    fi

    if grep -qF "PROSE BODY MARKER" "$page"; then
        return 0
    fi
    printf '    expected "PROSE BODY MARKER" in rendered /profile/index.html\n' >&2
    return 1
}
