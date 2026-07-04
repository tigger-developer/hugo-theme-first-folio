# shellcheck shell=bash
# ABOUTME: RT-62.5 - demo audio files are served as public HTTP artefacts.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    start_examplesite_server 46813 || return 1
    trap stop_examplesite_server RETURN

    local chapter
    for chapter in 00 01 02 03 04 05 06; do
        local url="$EXAMPLESITE_SERVER_URL/audio/audiobook-demo/chapter${chapter}.m4a"
        local status
        status="$(http_status "$url")"
        if [[ "$status" != "200" ]]; then
            printf '    expected %s to return HTTP 200, got %s\n' "$url" "$status" >&2
            return 1
        fi

        local size
        size="$(http_download_size "$url")"
        if (( size <= 0 )); then
            printf '    expected %s to have nonzero response body\n' "$url" >&2
            return 1
        fi
    done
}
