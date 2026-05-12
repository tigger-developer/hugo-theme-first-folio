# shellcheck shell=bash
# ABOUTME: RT-54.35 — back-compat: a page's own <h1> shows .Title even when linkTitle is set.
# ABOUTME: The page header is content, not navigation; linkTitle is for nav contexts only.

# What user action does this test simulate?
#   The user opens /journal/typography-guide/ (which has linkTitle "Typography" and
#   a long Title "A Comprehensive Guide to ..."), reads the article's main heading.
# What would the user observe?
#   The article's <h1> shows the full long .Title, not the short linkTitle.

run_test() {
    local build
    if ! build=$(build_examplesite); then
        return 1
    fi

    # The first <h1> on the page is the article title (subsequent <h1>s are body content).
    local first_h1
    first_h1=$(htmlq -f "$build/journal/typography-guide/index.html" -t 'h1' 2>/dev/null | head -1)

    if [[ "$first_h1" == "A Comprehensive Guide to Typography in the First Folio Theme" ]]; then
        return 0
    else
        printf '    expected page <h1> to be the full .Title (back-compat)\n' >&2
        printf '    got: %s\n' "$first_h1" >&2
        return 1
    fi
}
