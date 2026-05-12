# shellcheck shell=bash
# ABOUTME: RT-53.1 — REMOVED. Original intent: assert `animation: none` rule exists in theme.css.
# ABOUTME: Removed because grepping source CSS violates TESTING.md "real-user test" rule.

# REMOVED 2026-05-12.
# Reason: The original test passed by grepping `assets/css/theme.css` for a rule.
# Per TESTING.md (clarified update), tests must verify behaviour via the same entry
# point a user would use; grepping source code is the anti-pattern, not the test pattern.
# Hover behaviour requires either a human (UT) or a headless browser (Playwright, future
# Option B). For #53 the verification is captured by UT-53.1 in the AC table.
#
# File retained per ISSUES.md (test IDs and artifacts immutable post-Gate 1).
# No `run_test` function: the harness will SKIP this file.
