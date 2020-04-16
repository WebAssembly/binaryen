#!/bin/bash

set -o errexit

# When we are running on travis and *not* part of a pull request we don't
# have any upstream branch to compare against.
if [ "$TRAVIS_PULL_REQUEST" = "false" ]; then
  echo "Skipping since not running on travis PR"
  exit 0
fi

if [ -n "$TRAVIS_BRANCH" ]; then
  BRANCH=$TRAVIS_BRANCH
else
  BRANCH=origin/master
fi

CLANG_TIDY=$(which clang-tidy)
if [ ! -e "$CLANG_TIDY" ]; then
  echo "Failed to find clang-tidy ($CLANG_TIDY)"
  exit 1
fi

CLANG_DIR=$(dirname $(dirname $(readlink -f $CLANG_TIDY)))
CLANG_TIDY_DIFF=$CLANG_DIR/share/clang/clang-tidy-diff.py
if [ ! -e "$CLANG_TIDY_DIFF" ]; then
  echo "Failed to find clang-tidy-diff.py ($CLANG_TIDY_DIFF)"
  exit 1
fi
TIDY_MSG=$(git diff -U0 $BRANCH... | $CLANG_TIDY_DIFF -quiet -p1 2> /dev/null)
if [ -n "$TIDY_MSG" -a "$TIDY_MSG" != "No relevant changes found." ]; then
  echo "Please fix clang-tidy errors before committing"
  echo
  # Run clang-tidy once again to show the error
  git diff -U0 $BRANCH... | $CLANG_TIDY_DIFF -quiet -p1 2> /dev/null
  exit 1
fi
