# shellcheck shell=bash
# ABOUTME: RT-54.27 — stats shortcode wraps its child stat elements in a .stats-grid container.
# ABOUTME: At least one .stats-grid contains three or more direct .stat children.

# What user action does this test simulate?
#   The user opens /journal/shortcode-showcase/ and looks at a row of stats wrapped
#   in {{< stats >}} ... {{< /stats >}}.
# What would the user observe?
#   A grid container with multiple stat blocks arranged side by side (responsive
#   reflow itself is UT-54.1; here we verify the wrapping structure).

run_test() {
    local build
    if ! build=$(build_examplesite); then
        return 1
    fi
    local page="$build/journal/shortcode-showcase/index.html"

    # Count .stats-grid elements and total .stat elements inside them.
    local grid_count
    grid_count=$(htmlq -f "$page" '.stats-grid' 2>/dev/null | grep -c 'class="stats-grid"')

    if (( grid_count < 1 )); then
        printf '    expected at least one .stats-grid element on shortcode-showcase\n' >&2
        return 1
    fi

    # Look for stats nested inside stats-grid. htmlq supports descendant selector.
    local nested_count
    nested_count=$(htmlq -f "$page" '.stats-grid .stat' 2>/dev/null | grep -c 'class="stat"')

    if (( nested_count < 3 )); then
        printf '    expected >=3 .stat elements nested inside .stats-grid (got %d)\n' "$nested_count" >&2
        return 1
    fi
    return 0
}
