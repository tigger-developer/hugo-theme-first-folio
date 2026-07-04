# shellcheck shell=bash
# ABOUTME: RT-64.8 - Makefile target generates audiobook media metadata for exampleSite.

run_test() {
    local out
    out="$(mktemp -t "ff-audiobook-media-XXXXXX.yaml")"

    if ! make -C "$THEME_ROOT" generate-audiobook-metadata FIRST_FOLIO_MEDIA_OUTPUT="$out" >/dev/null; then
        rm -f "$out"
        return 1
    fi

    local length duration
    length="$(yq '."first-folio-demo-podcast"."episode-1".byteLength' "$out")"
    duration="$(yq '."first-folio-demo-podcast"."episode-1".duration' "$out")"
    rm -f "$out"

    [[ "$length" == "64280" ]] || return 1
    [[ "$duration" =~ ^00:00:0[34]$ ]]
}
