# shellcheck shell=bash
# ABOUTME: RT-70.16 - audio documentation covers shared UX and override contract.
# ABOUTME: The docs explain platform limits without requiring template copies.

run_test() {
    local doc="$THEME_ROOT/docs/audiobook.md"

    grep -qF 'single web player' "$doc" || return 1
    grep -qF 'Listen in your favourite podcast app' "$doc" || return 1
    grep -qF 'Copied Podcast Feed Link' "$doc" || return 1
    grep -qF 'Save to your Home Screen' "$doc" || return 1
    grep -qF 'Copy this page Link' "$doc" || return 1
    grep -qF 'params.audiobook.subscribe' "$doc" || return 1
    grep -qF 'Apple and Android do not provide a reliable one-tap Link for private feeds' "$doc" || return 1
    grep -qF 'serial' "$doc" || return 1
    grep -qF 'episodic' "$doc" || return 1
}
