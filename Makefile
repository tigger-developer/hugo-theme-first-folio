# ABOUTME: Top-level make targets for the hugo-theme-first-folio theme.
# ABOUTME: `make test` runs regression tests; `make lint` runs shell linting.

SHELL := /usr/bin/env bash

.PHONY: test test-one-off lint help

help:
	@printf 'Available targets:\n'
	@printf '  test          run regression tests (tests/regression/)\n'
	@printf '  test-one-off  run one-off tests (tests/one_off/); use ISSUE=N to filter\n'
	@printf '  lint          shellcheck on test scripts\n'

test: lint
	@bash tests/regression/run.sh

test-one-off:
ifdef ISSUE
	@find tests/one_off -name "OT-$(ISSUE).*.sh" -print -exec bash {} \;
else
	@find tests/one_off -name "OT-*.sh" -print -exec bash {} \;
endif

lint:
	@if command -v shellcheck >/dev/null 2>&1; then \
		find tests -name '*.sh' -print0 | xargs -0 shellcheck; \
	else \
		printf 'shellcheck not installed; skipping lint\n'; \
	fi
