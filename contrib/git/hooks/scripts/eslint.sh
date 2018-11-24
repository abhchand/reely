#!/bin/sh

#
# Pre-commit hook to run eslint on files being staged
#

echo "=== Running eslint..."

ESLINT="node_modules/.bin/eslint"

if [[ ! -x "$ESLINT" ]]; then
  echo "\t\033[41mPlease install ESlint\033[0m (yarn install)"
  exit 1
fi

for file in $(git diff --diff-filter=d --cached --name-only | grep -E '\.(js|jsx)$')
do
  git show ":$file" | "$ESLINT" --stdin --stdin-filename "$file" # we only want to lint the staged changes, not any un-staged changes
done
