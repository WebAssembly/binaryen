#!/bin/bash

# In some Travis CI settings in which the build directory is a subdirectory of
# binaryen/, we don't have the compilation database file in binaryen/. We skip
# the test in this case.
if [ ! -f compile_commands.json ]
then
  echo "Compilation database file does not exist. Skipping clang-tidy test."
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
