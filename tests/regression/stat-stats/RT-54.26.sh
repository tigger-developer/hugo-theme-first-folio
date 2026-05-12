# shellcheck shell=bash
# ABOUTME: RT-54.26 — stat without prefix/suffix omits the .stat-prefix and .stat-suffix elements.
# ABOUTME: Verifies that prefix and suffix are optional: their elements appear only when set.

# What user action does this test simulate?
#   The user opens /journal/shortcode-showcase/. Some stat blocks have no prefix or
#   suffix (e.g. the "80 / Countries" standalone). The user expects no stray glyph
#   characters around those numbers.
# What would the user observe?
#   Stat blocks without prefix/suffix render no .stat-prefix or .stat-suffix
#   elements; only .stat-value and .stat-label appear. Counts of prefix/suffix
#   elements across the page are strictly less than the total count of stat
#   elements — the difference is the stats without optional affixes.

run_test() {
    local build
    if ! build=$(build_examplesite); then
        return 1
    fi
    local page="$build/journal/shortcode-showcase/index.html"

    # Count distinct elements of each class. htmlq returns one line per match.
    local stat_count prefix_count suffix_count
    stat_count=$(htmlq -f "$page" '.stat-value' 2>/dev/null | grep -c '<')
    prefix_count=$(htmlq -f "$page" '.stat-prefix' 2>/dev/null | grep -c '<')
    suffix_count=$(htmlq -f "$page" '.stat-suffix' 2>/dev/null | grep -c '<')

    if (( stat_count == 0 )); then
        printf '    no .stat-value elements found on shortcode-showcase — example content missing?\n' >&2
        return 1
    fi

    local -a failures=()
    if (( prefix_count >= stat_count )); then
        failures+=("expected at least one stat without prefix (prefix=$prefix_count, stat=$stat_count)")
    fi
    if (( suffix_count >= stat_count )); then
        failures+=("expected at least one stat without suffix (suffix=$suffix_count, stat=$stat_count)")
    fi

    if (( ${#failures[@]} > 0 )); then
        printf '    %s\n' "${failures[@]}" >&2
        return 1
    fi
    return 0
}
