# shellcheck shell=bash
# ABOUTME: RT-54.25 — stat with prefix + suffix emits .stat-prefix and .stat-suffix elements.
# ABOUTME: Asserts that `{{< stat number="20" label="Years" prefix="~" suffix="+" >}}` renders all four pieces.

# What user action does this test simulate?
#   The user opens /journal/shortcode-showcase/ and reads a stat block with both a
#   prefix and a suffix (e.g. "~20+ Years").
# What would the user observe?
#   The prefix glyph ("~") appears before the value, the value ("20") in the middle,
#   the suffix ("+") after, and the label ("Years") below.

run_test() {
    local build
    if ! build=$(build_examplesite); then
        return 1
    fi
    local page="$build/journal/shortcode-showcase/index.html"

    local prefixes suffixes values labels
    prefixes=$(htmlq -f "$page" -t '.stat-prefix' 2>/dev/null)
    suffixes=$(htmlq -f "$page" -t '.stat-suffix' 2>/dev/null)
    values=$(htmlq -f "$page" -t '.stat-value' 2>/dev/null)
    labels=$(htmlq -f "$page" -t '.stat-label' 2>/dev/null)

    local -a failures=()
    grep -qFx "~" <<< "$prefixes" || failures+=("expected .stat-prefix '~'")
    grep -qFx "20" <<< "$values"  || failures+=("expected .stat-value '20'")
    grep -qFx "+" <<< "$suffixes" || failures+=("expected .stat-suffix '+'")
    grep -qFx "Years" <<< "$labels" || failures+=("expected .stat-label 'Years'")

    if (( ${#failures[@]} > 0 )); then
        printf '    %s\n' "${failures[@]}" >&2
        return 1
    fi
    return 0
}
