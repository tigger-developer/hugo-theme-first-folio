# shellcheck shell=bash
# ABOUTME: RT-54.12 — `featured=true` adds the `pull-quote-featured` modifier class on the outer <figure>.

# What user action does this test simulate?
#   The user reads a "featured" testimonial — typographically larger / more prominent.
# What would the user observe?
#   The figure element carries both `pull-quote` and `pull-quote-featured` classes
#   on its outer element. CSS then applies the larger treatment.

run_test() {
    local build
    if ! build=$(build_examplesite); then return 1; fi
    local page="$build/journal/shortcode-showcase/index.html"

    # All <figure> elements with the pull-quote-featured class.
    local featured_figures
    featured_figures=$(htmlq -f "$page" 'figure.pull-quote.pull-quote-featured' 2>/dev/null)

    if [[ -n "$featured_figures" ]]; then
        return 0
    fi
    # shellcheck disable=SC2016
    printf '    expected at least one figure with both `pull-quote` and `pull-quote-featured` classes\n' >&2
    return 1
}
