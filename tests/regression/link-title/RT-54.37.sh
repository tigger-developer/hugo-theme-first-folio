# shellcheck shell=bash
# ABOUTME: RT-54.37 — breadcrumb top-section segment renders .LinkTitle (not just sub-sections).
# ABOUTME: Section "poetry" has Title "Poetry and Verse" + linkTitle "Poetry"; expect linkTitle.

# What user action does this test simulate?
#   The user loads /poetry/half-remembered/glass/, reads the breadcrumb's top segment
#   (the link to the root section).
# What would the user observe?
#   The top-section segment shows "Poetry" (poetry's linkTitle), not "Poetry and Verse"
#   (its longer .Title). All breadcrumb nav segments honour linkTitle, not just
#   sub-sections.

run_test() {
    local build
    if ! build=$(build_examplesite); then
        return 1
    fi

    local top_section_text
    top_section_text=$(htmlq -f "$build/poetry/half-remembered/glass/index.html" -t '.breadcrumb-seg.breadcrumb-section.breadcrumb-bright' 2>/dev/null)

    if [[ "$top_section_text" == "Poetry" ]]; then
        return 0
    else
        printf '    expected breadcrumb top-section segment to be "Poetry" (linkTitle), got: %s\n' "$top_section_text" >&2
        return 1
    fi
}
