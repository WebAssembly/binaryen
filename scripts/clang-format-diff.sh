#!/bin/bash

set -o errexit
set -o pipefail

if [ -n "$1" ]; then
  BRANCH="$1"
elif [ -n "$GITHUB_BASE_REF" ]; then
  BRANCH="origin/$GITHUB_BASE_REF"
else
  BRANCH="@{upstream}"
fi

MERGE_BASE=$(git merge-base $BRANCH HEAD)
FORMAT_MSG=$(git clang-format $MERGE_BASE -q --diff -- src/)
if [ -n "$FORMAT_MSG" -a "$FORMAT_MSG" != "no modified files to format" ]
then
  echo "Please run git clang-format before committing, or apply this diff:"
  echo
  # Run git clang-format again, this time without capruting stdout.  This way
  # clang-format format the message nicely and add color.
  git clang-format $MERGE_BASE -q --diff -- src/
  exit 1
fi
