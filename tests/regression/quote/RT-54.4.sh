# shellcheck shell=bash
# ABOUTME: RT-54.4 — quote with `name=` + `role=` renders .pull-quote-name and .pull-quote-role with the role alone (no organisation).

# What user action does this test simulate?
#   The user reads a testimonial with only a name and role (no organisation).
# What would the user observe?
#   First line: name. Second line: role text alone, no comma.

run_test() {
    local build
    if ! build=$(build_examplesite); then return 1; fi
    local page="$build/journal/shortcode-showcase/index.html"

    local attributions
    attributions=$(htmlq -f "$page" '.pull-quote-attribution' 2>/dev/null)

    # Expect a block with name "Sherlock Holmes" and role "Consulting Detective", no comma in the role line.
    local block
    block=$(awk '/pull-quote-name">Sherlock Holmes</{flag=1} flag{print; if (/<\/figcaption>/){exit}}' <<< "$attributions")

    if [[ -z "$block" ]]; then
        printf '    no attribution block for Sherlock Holmes found\n' >&2
        return 1
    fi
    # Must have a .pull-quote-role with "Consulting Detective" and no comma followed by another token.
    local role_text
    role_text=$(htmlq -t '.pull-quote-role' <<< "$block" 2>/dev/null)
    if [[ "$role_text" == "Consulting Detective" ]]; then
        return 0
    fi
    printf '    expected .pull-quote-role text "Consulting Detective" alone (no organisation joined); got %s\n' "$role_text" >&2
    return 1
}
