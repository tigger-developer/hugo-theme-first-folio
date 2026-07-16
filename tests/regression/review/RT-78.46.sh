# shellcheck shell=bash
# ABOUTME: RT-78.46 - every review publishes separate generated article and cover images.
# ABOUTME: All twenty-four raster assets have distinct URLs, content, and non-zero dimensions.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local build_dir
    build_dir="$(review_example_dir)" || return 1

    local -a routes
    mapfile -t routes < <(review_demo_routes)
    local -a asset_urls=()
    local -a asset_hashes=()
    local route
    for route in "${routes[@]}"; do
        local page="$build_dir/$route/index.html"
        local article_url="/$route/article.jpg"
        local cover_url="/$route/cover.jpg"
        grep -qF "$article_url" "$page" || return 1
        [[ "$(htmlq -f "$page" -a src '.review-artwork img')" == "$cover_url" ]] || return 1

        local asset_url
        for asset_url in "$article_url" "$cover_url"; do
            local asset_path="$build_dir/${asset_url#/}"
            [[ -f "$asset_path" ]] || return 1
            local dimensions
            dimensions="$(identify -format '%w %h' "$asset_path")" || return 1
            [[ "$dimensions" != '0 0' ]] || return 1
            asset_urls+=("$asset_url")
            asset_hashes+=("$(shasum -a 256 "$asset_path" | cut -d ' ' -f 1)")
        done
    done

    [[ "$(printf '%s\n' "${asset_urls[@]}" | sort -u | wc -l | tr -d ' ')" -eq 24 ]] || return 1
    [[ "$(printf '%s\n' "${asset_hashes[@]}" | sort -u | wc -l | tr -d ' ')" -eq 24 ]]
}
