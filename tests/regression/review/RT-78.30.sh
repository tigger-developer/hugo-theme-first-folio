# shellcheck shell=bash
# ABOUTME: RT-78.30 - list entries omit empty review creator elements.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local build_dir
    build_dir="$(review_fixture_dir)" || return 1
    [[ "$(htmlq -f "$build_dir/reviews/index.html" -t '.list-view-review-title' | grep -c 'The Nameless Work')" -eq 1 ]] || return 1
    [[ -z "$(htmlq -f "$build_dir/reviews/index.html" '[data-review-title="The Nameless Work"] .list-view-review-creator')" ]]
}
