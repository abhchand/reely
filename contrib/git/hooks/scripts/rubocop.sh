#!/bin/sh

#
# Pre-commit hook to run rubocop on diffed files
#

echo "=== Running rubocop..."
bundle exec rubocop-git --config .rubocop.yml --cached
