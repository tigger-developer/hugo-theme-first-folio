# shellcheck shell=bash
# ABOUTME: RT-53.3 — REMOVED. Original intent: assert `color: rgba(255, 255, 255, 0.85)` rule on carousel hover.
# ABOUTME: Removed because grepping source CSS violates TESTING.md "real-user test" rule.

# REMOVED 2026-05-12.
# Reason: Same as RT-53.1 / RT-53.2 — grep-based source-code assertion. The visual tint
# affordance is verified by UT-53.2 in the AC table (hover -> title dims to ~85% white).
#
# File retained per ISSUES.md (test IDs and artifacts immutable post-Gate 1).
# No `run_test` function: the harness will SKIP this file.
