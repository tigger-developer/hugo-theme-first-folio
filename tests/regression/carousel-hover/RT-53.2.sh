# shellcheck shell=bash
# ABOUTME: RT-53.2 — REMOVED. Original intent: regression guard for masonry / list-view animation overrides.
# ABOUTME: Removed because grepping source CSS violates TESTING.md "real-user test" rule.

# REMOVED 2026-05-12.
# Reason: Same as RT-53.1 — grep-based source-code assertion is an anti-pattern under
# the clarified TESTING.md rule. Whatever regression risk this guarded against is
# addressed visually by UT-53.1 (hover any card title -> consistent no-wiggle behaviour).
#
# File retained per ISSUES.md (test IDs and artifacts immutable post-Gate 1).
# No `run_test` function: the harness will SKIP this file.
