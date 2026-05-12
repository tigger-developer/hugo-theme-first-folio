# shellcheck shell=bash
# ABOUTME: RT-54.16 — REMOVED. Original intent: grep theme.css for kebab-case .pull-quote-* class rules.
# ABOUTME: Removed because grepping source CSS violates TESTING.md "real-user test" rule (tier 1 source).

# REMOVED 2026-05-12.
# Reason: The original test would have asserted that `assets/css/theme.css` contains
# .pull-quote-name, .pull-quote-role, .pull-quote-photo, .pull-quote-attribution,
# .pull-quote-featured. Per WEB.md's three-tier model, that's a tier-1 source grep.
#
# Coverage of AC54.7 ("kebab-case CSS, no BEM") now lives implicitly in the
# rendered-HTML tests: RT-54.3 .. RT-54.13 all assert on those class names
# appearing on rendered <figure>/<img>/<span> elements. If the class names were
# wrong (e.g. BEM-style `pull-quote__name`), those tests would fail.
#
# File retained per ISSUES.md (test IDs and artifacts immutable post-Gate 1).
# No `run_test` function: the harness will SKIP this file.
