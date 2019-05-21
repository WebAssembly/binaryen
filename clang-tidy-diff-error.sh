#!/bin/bash
# This exits with a non-zero code if there are clang-tidy errors
CLANG_DIR=$(dirname $(dirname $(which clang-tidy)))
CLANG_TIDY_DIFF=$CLANG_DIR/share/clang/clang-tidy-diff.py
MERGE_BASE=$(git merge-base master HEAD)
TIDY_MSG=$(git diff -U0 $MERGE_BASE | $CLANG_TIDY_DIFF -quiet -p1 2> /dev/null)
if [ -n "$TIDY_MSG" -a "$TIDY_MSG" != "No relevant changes found." ]
then
  echo "Fix clang-tidy errors before committing!"
  exit 1
fi
