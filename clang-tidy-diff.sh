#!/bin/bash
# This only shows the result of clang-tidy.
CLANG_DIR=$(dirname $(dirname $(which clang-tidy)))
CLANG_TIDY_DIFF=$CLANG_DIR/share/clang/clang-tidy-diff.py
MERGE_BASE=$(git merge-base master HEAD)
git diff -U0 $MERGE_BASE | $CLANG_TIDY_DIFF -quiet -p1 2> /dev/null
