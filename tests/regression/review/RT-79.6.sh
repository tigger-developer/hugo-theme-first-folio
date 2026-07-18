# shellcheck shell=bash
# ABOUTME: RT-79.6 - public docs describe localized review-card attribution.

run_test() {
    grep -qF 'attribution:' "$THEME_ROOT/docs/reviews.md" || return 1
    grep -qF 'section/topic remains visible' "$THEME_ROOT/docs/reviews.md" || return 1
    grep -qF 'review.attribution.en' "$THEME_ROOT/docs/config.md" || return 1
    grep -qF 'connector plus creator' "$THEME_ROOT/docs/frontmatter.md"
}
