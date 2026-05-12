# shellcheck shell=bash
# ABOUTME: RT-54.21 — `list_style: prose` page contains no pagination element.

# What user action does this test simulate?
#   The user opens /profile/ (list_style: prose). No pagination should appear —
#   there's no list to paginate.
# What would the user observe?
#   No "Previous / Next" pagination block.

run_test() {
    local build
    if ! build=$(build_examplesite); then return 1; fi
    local page="$build/profile/index.html"

    if [[ ! -f "$page" ]]; then
        printf '    expected built page at %s\n' "$page" >&2
        return 1
    fi

    # The theme's pagination partial wraps in <nav class="pagination">.
    if grep -qE 'class="pagination"' "$page"; then
        printf '    found .pagination in /profile/ — prose mode should not render pagination\n' >&2
        return 1
    fi
    return 0
}
