#!/bin/sh

#
# Pre-commit hook to run stylelint on files being staged
#

echo "=== Running stylelint..."

STYLELINT="node_modules/.bin/stylelint"
FILES=()

if [[ ! -x "$STYLELINT" ]]; then
  echo "\t\033[41mPlease install stylelint\033[0m (yarn install)"
  exit 1
fi

for file in $(git diff --diff-filter=d --cached --name-only | grep -E '\.(css|scss|sass)$')
do
  # we only want to lint the staged changes, not any un-staged changes
  git show ":$file" | "$STYLELINT" --stdin-filename "$file"
  if [ $? -ne 0 ]; then
    FILES=("${FILES[@]}" "$file")
  fi
done

if [ ${#FILES[@]} -ne 0 ]; then
  echo "\033[0;31mStylelint failed for ${#FILES[@]} files.\033[0m
Please check your code and try again. You can run StyleLint manually via '$ node_modules/.bin/stylelint app/assets/stylesheets/<directory|file>'"
  exit 1
elif [ ${#FILES[@]} -eq 0 ]; then
  echo "Stylelint completed with no warnings or errors."
fi
