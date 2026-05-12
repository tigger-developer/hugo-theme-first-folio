# shellcheck shell=bash
# ABOUTME: RT-54.24 — basic stat shortcode emits .stat-value and .stat-label elements.
# ABOUTME: Asserts that `{{< stat number="80" label="Countries" >}}` renders with the expected structure.

# What user action does this test simulate?
#   The user opens /journal/shortcode-showcase/ (the canonical demo page) and reads
#   the stats section, looking at a standalone "80 / Countries" stat block.
# What would the user observe?
#   A .stat container with a .stat-value showing "80" and a .stat-label showing
#   "Countries", visually rendered as a number + label pair.

run_test() {
    local build
    if ! build=$(build_examplesite); then
        return 1
    fi
    local page="$build/journal/shortcode-showcase/index.html"

    local stat_values stat_labels
    stat_values=$(htmlq -f "$page" -t '.stat-value' 2>/dev/null)
    stat_labels=$(htmlq -f "$page" -t '.stat-label' 2>/dev/null)

    local -a failures=()
    if ! grep -qFx "80" <<< "$stat_values"; then
        failures+=("expected .stat-value '80' in shortcode-showcase")
    fi
    if ! grep -qFx "Countries" <<< "$stat_labels"; then
        failures+=("expected .stat-label 'Countries' in shortcode-showcase")
    fi

    if (( ${#failures[@]} > 0 )); then
        printf '    %s\n' "${failures[@]}" >&2
        printf '    .stat-value values found:\n%s\n' "$stat_values" | sed 's/^/      /' >&2
        printf '    .stat-label values found:\n%s\n' "$stat_labels" | sed 's/^/      /' >&2
        return 1
    fi
    return 0
}
