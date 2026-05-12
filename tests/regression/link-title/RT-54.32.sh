# shellcheck shell=bash
# ABOUTME: RT-54.32 — breadcrumb sub-section segments render .LinkTitle.
# ABOUTME: Sub-section "half-remembered" has linkTitle "Half-Remembered"; expect that in the breadcrumb.

# What user action does this test simulate?
#   The user loads /poetry/half-remembered/glass/ (a leaf poem inside a sub-section),
#   reads the breadcrumb trail at the top of the article.
# What would the user observe?
#   The sub-section segment "half-remembered" shows the short linkTitle value
#   "Half-Remembered", not the long article title "Half-Remembered: A Collection of...".

run_test() {
    local build
    if ! build=$(build_examplesite); then
        return 1
    fi

    local subsection_text
    subsection_text=$(htmlq -f "$build/poetry/half-remembered/glass/index.html" -t '.breadcrumb-seg.breadcrumb-mid' 2>/dev/null)

    if grep -qFx "Half-Remembered" <<< "$subsection_text"; then
        return 0
    else
        printf '    expected "Half-Remembered" as the breadcrumb sub-section segment text\n' >&2
        printf '    got: %s\n' "$subsection_text" >&2
        return 1
    fi
}
