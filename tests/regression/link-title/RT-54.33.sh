# shellcheck shell=bash
# ABOUTME: RT-54.33 — related-articles partial renders .LinkTitle for each linked page.
# ABOUTME: typography-guide has linkTitle "Typography"; expect that in related-articles lists.

# What user action does this test simulate?
#   The user loads /journal/navigation-features/ (which has typography-guide in its
#   related-articles strip via shared tags), looks at the related-articles list.
# What would the user observe?
#   The link to typography-guide shows its linkTitle "Typography", not its long
#   article title "A Comprehensive Guide to Typography in the First Folio Theme".

run_test() {
    local build
    if ! build=$(build_examplesite); then
        return 1
    fi

    local related_text
    related_text=$(htmlq -f "$build/journal/navigation-features/index.html" -t '.related-articles a' 2>/dev/null)

    if grep -qFx "Typography" <<< "$related_text"; then
        return 0
    else
        printf '    expected "Typography" among related-articles links on /journal/navigation-features/\n' >&2
        printf '    got:\n%s\n' "$related_text" | sed 's/^/      /' >&2
        return 1
    fi
}
