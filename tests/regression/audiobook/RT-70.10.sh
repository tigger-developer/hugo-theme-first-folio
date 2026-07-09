# shellcheck shell=bash
# ABOUTME: RT-70.10 - feed setup copy is generic, configurable, and Link-based.
# ABOUTME: Rendered defaults avoid URL wording in listener-facing instructions.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(podcast_demo_page)" || return 1

    local panel_count
    panel_count="$(htmlq -f "$page" '.audiobook-subscribe-panel' | htmlq '.audiobook-subscribe-panel' | wc -l | tr -d ' ')"
    [[ "$panel_count" == "1" ]] || return 1

    local panel_text
    panel_text="$(htmlq -f "$page" -t '.audiobook-subscribe-panel')"
    grep -qF 'Copy this Podcast Feed Link.' <<< "$panel_text" || return 1
    grep -qF 'In your podcast app, look for Add Link or Add Feed, then paste it there.' <<< "$panel_text" || return 1
    grep -qF 'Unfortunately Apple and Android do not provide a reliable one-tap Link for private feeds.' <<< "$panel_text" || return 1

    if grep -qF 'URL' <<< "$panel_text"; then
        printf 'subscription panel used URL in default user-facing copy\n' >&2
        return 1
    fi
}
