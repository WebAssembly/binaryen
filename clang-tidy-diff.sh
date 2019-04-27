#!/bin/bash

# In settings in which build directory is different than binaryen/, we don't
# have this file in binaryen/, so we skip the test.
if [ ! -f compile_commands.json ]
  exit 0
fi

CLANG_DIR=$(dirname $(dirname $(which clang-tidy)))
CLANG_TIDY_DIFF=$CLANG_DIR/share/clang/clang-tidy-diff.py
MERGE_BASE=$(git merge-base master HEAD)
TIDY_MSG=$(git diff -U0 $MERGE_BASE | $CLANG_TIDY_DIFF -quiet -p1 2> /dev/null)
if [ -n "$TIDY_MSG" -a "$TIDY_MSG" != "No relevant changes found." ]
then
  echo "Run clang-tidy before committing!"
  echo
  # Run clang-tidy once again to show the error
  git diff -U0 $MERGE_BASE | $CLANG_TIDY_DIFF -quiet -p1
  exit 1
fi
