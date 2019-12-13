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

CLANG_DIR=$(dirname $(dirname $(which clang-tidy)))
CLANG_TIDY_DIFF=$CLANG_DIR/share/clang/clang-tidy-diff.py
TIDY_MSG=$(git diff -U0 $BRANCH... | $CLANG_TIDY_DIFF -quiet -p1 2> /dev/null)
if [ -n "$TIDY_MSG" -a "$TIDY_MSG" != "No relevant changes found." ]
then
  echo "Please run clang-tidy before committing, or apply this diff:"
  echo
  # Run clang-tidy once again to show the error
  git diff -U0 $BRANCH... | $CLANG_TIDY_DIFF -quiet -p1 2> /dev/null
  exit 1
fi
