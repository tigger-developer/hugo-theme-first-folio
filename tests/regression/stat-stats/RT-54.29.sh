# shellcheck shell=bash
# ABOUTME: RT-54.29 — `{{< stats columns=N >}}` emits .stats-grid with an inline grid-template-columns style for N columns.
# ABOUTME: Asserts that columns=4 produces a four-column fixed-column inline style override.

# What user action does this test simulate?
#   The user opens /journal/shortcode-showcase/ and looks at a `columns=4` stats grid
#   (four stats arranged in a fixed four-across layout).
# What would the user observe?
#   The grid lays out exactly four columns regardless of viewport width (visible
#   as four equal-width cells at desktop). Under the hood, the .stats-grid element
#   carries an inline style with `grid-template-columns: repeat(4, 1fr)` or
#   equivalent — overriding the auto-fit CSS default.

run_test() {
    local build
    if ! build=$(build_examplesite); then
        return 1
    fi
    local page="$build/journal/shortcode-showcase/index.html"

    # Find all .stats-grid elements and check their style attributes.
    # htmlq with -a fetches a specific attribute from selected elements.
    local styles
    styles=$(htmlq -f "$page" -a style '.stats-grid' 2>/dev/null)

    # At least one .stats-grid should have an inline style referencing 4 columns.
    if grep -qE 'grid-template-columns:[[:space:]]*repeat\([[:space:]]*4[[:space:]]*,' <<< "$styles"; then
        return 0
    else
        printf '    expected a .stats-grid with inline style grid-template-columns: repeat(4, ...)\n' >&2
        printf '    found inline styles:\n%s\n' "$styles" | sed 's/^/      /' >&2
        return 1
    fi
}
