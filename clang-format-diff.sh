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

MERGE_BASE=$(git merge-base $BRANCH HEAD)
FORMAT_MSG=$(git clang-format $MERGE_BASE -q --diff -- src/)
if [ -n "$FORMAT_MSG" -a "$FORMAT_MSG" != "no modified files to format" ]
then
  echo "Run git clang-format before committing!"
  echo
  # Run git clang-format again, this time without capruting stdout.  This way
  # clang-format format the message nicely and add color.
  git clang-format $MERGE_BASE -q --diff -- src/
  exit 1
fi
