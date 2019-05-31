#!/bin/bash
set -e
CLANG_TIDY=$(realpath $(which clang-tidy))
CLANG_DIR=$(dirname $(dirname $CLANG_TIDY))
CLANG_TIDY_DIFF=$CLANG_DIR/share/clang/clang-tidy-diff.py
if [ ! -f $CLANG_TIDY_DIFF ]; then
  echo "not found: $CLANG_TIDY_DIFF"
  exit 1
fi
DIFF=$(git diff -U0 "@{upstream}")
echo "Running $CLANG_TIDY_DIFF"
TIDY_MSG=$(echo $DIFF | $CLANG_TIDY_DIFF -quiet -p1 2> /dev/null)
if [ -n "$TIDY_MSG" -a "$TIDY_MSG" != "No relevant changes found." ]
then
  echo "Fix clang-tidy errors before committing!"
  echo
  # Run clang-tidy once again to show the error
  git diff -U0 "@{upstream}" | $CLANG_TIDY_DIFF -quiet -p1 2> /dev/null
  exit 1
fi
