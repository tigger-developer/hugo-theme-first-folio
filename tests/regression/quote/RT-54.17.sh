# shellcheck shell=bash
# ABOUTME: RT-54.17 — REMOVED. Original intent: grep theme.css for absence of BEM-style `pull-quote__` separator.
# ABOUTME: Removed because grepping source CSS violates TESTING.md "real-user test" rule (tier 1 source).

# REMOVED 2026-05-12.
# Reason: Same as RT-54.16 — tier-1 source grep is an anti-pattern. Convention
# enforcement (kebab-case, no BEM) is better captured by the rendered HTML the
# theme actually produces — which the other quote RTs already query for the
# expected kebab-case class names.
#
# File retained per ISSUES.md (test IDs and artifacts immutable post-Gate 1).
# No `run_test` function: the harness will SKIP this file.
