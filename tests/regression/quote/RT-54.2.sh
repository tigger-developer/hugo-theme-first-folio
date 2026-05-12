# shellcheck shell=bash
# ABOUTME: RT-54.2 — quote with no attribution and no structured fields emits a <figure> with no <figcaption>.

# What user action does this test simulate?
#   The user opens /journal/shortcode-showcase/, reads the unattributed quote example.
# What would the user observe?
#   The pull-quote body alone, no attribution line below.

run_test() {
    local build
    if ! build=$(build_examplesite); then return 1; fi
    local page="$build/journal/shortcode-showcase/index.html"

    # At least one .pull-quote on the page must have no figcaption.
    # htmlq returns one match per element; we compare counts.
    local pq_count fc_count
    pq_count=$(htmlq -f "$page" '.pull-quote' 2>/dev/null | grep -c 'class="pull-quote')
    fc_count=$(htmlq -f "$page" '.pull-quote figcaption' 2>/dev/null | grep -c '<figcaption')

    if (( pq_count == 0 )); then
        printf '    no .pull-quote elements on page\n' >&2
        return 1
    fi
    if (( pq_count > fc_count )); then
        # At least one .pull-quote has no figcaption.
        return 0
    fi
    printf '    expected at least one .pull-quote without a figcaption (got pq=%d fc=%d)\n' "$pq_count" "$fc_count" >&2
    return 1
}
