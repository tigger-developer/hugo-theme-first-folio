# shellcheck shell=bash
# ABOUTME: RT-54.5 — quote with `name=` + `organization=` (no role) renders the organisation alone on the role line.

# What user action does this test simulate?
#   The user reads a testimonial with name and organisation, no role.
# What would the user observe?
#   First line: name. Second line: organisation alone.

run_test() {
    local build
    if ! build=$(build_examplesite); then return 1; fi
    local page="$build/journal/shortcode-showcase/index.html"

    local attributions
    attributions=$(htmlq -f "$page" '.pull-quote-attribution' 2>/dev/null)

    local block
    block=$(awk '/pull-quote-name">Hermione Granger</{flag=1} flag{print; if (/<\/figcaption>/){exit}}' <<< "$attributions")
    if [[ -z "$block" ]]; then
        printf '    no attribution block for Hermione Granger found\n' >&2
        return 1
    fi
    local role_text
    role_text=$(htmlq -t '.pull-quote-role' <<< "$block" 2>/dev/null)
    if [[ "$role_text" == "Ministry of Magic" ]]; then
        return 0
    fi
    printf '    expected .pull-quote-role text "Ministry of Magic" (organisation alone); got %s\n' "$role_text" >&2
    return 1
}
