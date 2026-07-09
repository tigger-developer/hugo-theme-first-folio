# shellcheck shell=bash
# ABOUTME: RT-75.9 - metadata generation writes media facts, not editorial labels.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local out
    local out_dir
    out_dir="$(mktemp -d "$AGENT_TMP/ff-generated-media-contract-XXXXXX")"
    out="$out_dir/first_folio_media.yaml"

    FIRST_FOLIO_MEDIA_OUTPUT="$out" make -s -C "$THEME_ROOT" generate-audiobook-metadata || return 1

    [[ "$(yq '.first-folio-demo-audiobook.chapter-1.src' "$out")" == "/audio/audiobook-demo/chapter01.m4a" ]] || return 1
    [[ "$(yq '.first-folio-demo-audiobook.chapter-1.label' "$out")" == "null" ]] || return 1
    [[ "$(yq '.first-folio-demo-audiobook.chapter-1.displayNumber' "$out")" == "null" ]] || return 1
    [[ "$(yq '.first-folio-demo-podcast.episode-2.label' "$out")" == "null" ]] || return 1
    [[ "$(yq '.first-folio-demo-podcast.episode-2.displayNumber' "$out")" == "null" ]]
}
