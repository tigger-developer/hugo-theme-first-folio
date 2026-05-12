# shellcheck shell=bash
# ABOUTME: RT-54.6 — quote with `name=` + `role=` + `organization=` renders "role, organization" comma-joined on the role line.

# What user action does this test simulate?
#   The user reads a testimonial with name, role, and organisation all set.
# What would the user observe?
#   First line: name. Second line: "role, organisation" comma-separated.

run_test() {
    local build
    if ! build=$(build_examplesite); then return 1; fi
    local page="$build/journal/shortcode-showcase/index.html"

    local attributions
    attributions=$(htmlq -f "$page" '.pull-quote-attribution' 2>/dev/null)

    local block
    block=$(awk '/pull-quote-name">Frodo Baggins</{flag=1} flag{print; if (/<\/figcaption>/){exit}}' <<< "$attributions")
    # Note: this AC needs a different test fixture than RT-54.3 (which is name-only).
    # The full-fields exemplar in shortcode-showcase will be a different speaker.
    # Use a different example name to avoid collision with RT-54.3's name-only test.
    block=$(awk '/pull-quote-name">Aragorn</{flag=1} flag{print; if (/<\/figcaption>/){exit}}' <<< "$attributions")
    if [[ -z "$block" ]]; then
        printf '    no attribution block for Aragorn found\n' >&2
        return 1
    fi
    local role_text
    role_text=$(htmlq -t '.pull-quote-role' <<< "$block" 2>/dev/null)
    # Expected: "Ranger of the North, Heirs of Isildur" (or whatever the example sets).
    if [[ "$role_text" == *","* ]] && [[ "$role_text" == *"Ranger"* ]]; then
        return 0
    fi
    printf '    expected .pull-quote-role to contain "Ranger" and a comma (role, organization joined); got %s\n' "$role_text" >&2
    return 1
}
