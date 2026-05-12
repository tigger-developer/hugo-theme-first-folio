# shellcheck shell=bash
# ABOUTME: RT-54.31 — sidebar partial renders .LinkTitle for section index pages.
# ABOUTME: Sub-section "transport-and-trains" has linkTitle "Trains"; expect that in the sidebar.

# What user action does this test simulate?
#   The user loads /photography/ (a section index that renders a section-list sidebar
#   listing its sub-sections), reads the sidebar entries.
# What would the user observe?
#   The sub-section "transport-and-trains" appears in the sidebar with its linkTitle
#   value "Trains", not its long article title "Vintage and Modern Railways: ...".

run_test() {
    local build
    if ! build=$(build_examplesite); then
        return 1
    fi

    local sidebar_links
    sidebar_links=$(htmlq -f "$build/photography/index.html" -t '.sidebar-link' 2>/dev/null)

    if grep -qFx "Trains" <<< "$sidebar_links"; then
        return 0
    else
        printf '    expected "Trains" among .sidebar-link entries on /photography/\n' >&2
        printf '    got:\n%s\n' "$sidebar_links" | sed 's/^/      /' >&2
        return 1
    fi
}
