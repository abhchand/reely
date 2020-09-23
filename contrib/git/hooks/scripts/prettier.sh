#!/bin/sh

#
# Pre-commit hook to run prettier on files being staged
#

echo "=== Running prettier..."

PRETTIER="node_modules/.bin/prettier"
FILES=()

if [[ ! -x "$PRETTIER" ]]; then
  echo "\t\033[41mPlease install prettier\033[0m (yarn install)"
  exit 1
fi

for file in $(git diff --diff-filter=d --cached --name-only)
do
  # we only want to lint the staged changes, not any un-staged changes
  echo "Validating $file"
  $PRETTIER --check "$file"
  if [ $? -ne 0 ]; then
    FILES=("${FILES[@]}" "$file")
  fi
done

if [ ${#FILES[@]} -ne 0 ]; then
  echo "\033[0;31mPrettier failed for ${#FILES[@]} files.\033[0m
Please check your code and try again. You can run Prettier manually via '$ node_modules/.bin/prettier <file>'"
  exit 1
elif [ ${#FILES[@]} -eq 0 ]; then
  echo "Prettier completed with no warnings or errors."
fi
