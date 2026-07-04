# shellcheck shell=bash
# ABOUTME: RT-64.5 - front matter media metadata remains backward compatible.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local feed
    feed="$(audiobook_fixture_feed "audiobook-no-local-template")" || return 1

    local length
    length="$(xmlstarlet sel -t -v '/rss/channel/item[1]/enclosure/@length' "$feed")"
    [[ "$length" == "12345" ]]
}
