# shellcheck shell=bash
# ABOUTME: RT-78.45 - review demonstrations publish distinct fictional identities.
# ABOUTME: Rendered article pages expose twelve unique reviewed-item titles and creators.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local build_dir
    build_dir="$(review_example_dir)" || return 1

    local -a routes
    mapfile -t routes < <(review_demo_routes)
    local -a titles=()
    local -a creators=()
    local route
    for route in "${routes[@]}"; do
        local page="$build_dir/$route/index.html"
        titles+=("$(htmlq -f "$page" -t '.review-title')")
        creators+=("$(htmlq -f "$page" -t '.review-creator')")
    done

    [[ "$(printf '%s\n' "${titles[@]}" | sort -u | wc -l | tr -d ' ')" -eq 12 ]] || return 1
    [[ "$(printf '%s\n' "${creators[@]}" | sort -u | wc -l | tr -d ' ')" -eq 12 ]]
}
