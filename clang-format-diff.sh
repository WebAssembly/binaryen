#!/bin/bash
MERGE_BASE=$(git merge-base master HEAD)
FORMAT_MSG=$(git clang-format $MERGE_BASE -q --diff -- src/)
if [ -n "$FORMAT_MSG" -a "$FORMAT_MSG" != "no modified files to format" ]
then
  echo "Run git clang-format before committing!"
  echo
  # Run git clang-format once again to show the error
  git clang-format $MERGE_BASE -q --diff -- src/
  exit 1
fi
