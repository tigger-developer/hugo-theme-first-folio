# shellcheck shell=bash
# ABOUTME: RT-54.13 — without `featured`, the <figure> carries only `pull-quote` (no featured modifier).

# What user action does this test simulate?
#   The user reads a default-styled quote — the typical inline pull-quote.
# What would the user observe?
#   No "featured" visual treatment — the figure has only the `pull-quote` class.

run_test() {
    local build
    if ! build=$(build_examplesite); then return 1; fi
    local page="$build/journal/shortcode-showcase/index.html"

    # Count all .pull-quote figures vs the subset with .pull-quote-featured.
    local total_count featured_count
    total_count=$(htmlq -f "$page" 'figure.pull-quote' 2>/dev/null | grep -c '<figure')
    featured_count=$(htmlq -f "$page" 'figure.pull-quote.pull-quote-featured' 2>/dev/null | grep -c '<figure')

    if (( total_count == 0 )); then
        printf '    no figure.pull-quote elements on page\n' >&2
        return 1
    fi
    if (( total_count > featured_count )); then
        # At least one non-featured pull-quote exists.
        return 0
    fi
    printf '    expected at least one figure.pull-quote without the featured modifier (total=%d featured=%d)\n' "$total_count" "$featured_count" >&2
    return 1
}
