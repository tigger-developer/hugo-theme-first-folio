# shellcheck shell=bash
# ABOUTME: RT-54.30 — `{{< stats >}}` without columns leaves grid-template-columns to the CSS default.
# ABOUTME: Asserts that at least one .stats-grid has no inline grid-template-columns style.

# What user action does this test simulate?
#   The user opens /journal/shortcode-showcase/ and looks at a stats block with no
#   `columns=` parameter. The visual reflow at different viewport widths is UT-54.1.
#   Here we verify the under-the-hood condition that enables it: no inline override.
# What would the user observe?
#   At the HTML level: a .stats-grid element with no inline grid-template-columns
#   style attribute. The CSS default rule then drives the auto-fit reflow.

run_test() {
    local build
    if ! build=$(build_examplesite); then
        return 1
    fi
    local page="$build/journal/shortcode-showcase/index.html"

    # Count all .stats-grid elements vs those that carry an inline style with
    # grid-template-columns. htmlq -a style only outputs lines for elements that
    # HAVE that attribute, so the difference tells us how many grids fell through
    # to the CSS default.
    local total_grids styled_grids
    total_grids=$(htmlq -f "$page" '.stats-grid' 2>/dev/null | grep -c 'class="stats-grid"')
    styled_grids=$(htmlq -f "$page" -a style '.stats-grid' 2>/dev/null | grep -c 'grid-template-columns')

    if (( total_grids == 0 )); then
        printf '    no .stats-grid elements found — example content missing?\n' >&2
        return 1
    fi

    if (( total_grids > styled_grids )); then
        # At least one .stats-grid has no inline grid-template-columns override.
        return 0
    else
        printf '    expected at least one .stats-grid without inline grid-template-columns (auto-fit default)\n' >&2
        printf '    total .stats-grid: %d ; with grid-template-columns inline: %d\n' "$total_grids" "$styled_grids" >&2
        return 1
    fi
}
