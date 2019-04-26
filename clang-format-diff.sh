#!/bin/bash
FORMAT_MSG=$(git clang-format master HEAD -q --diff)
if [ -n "$FORMAT_MSG" -a "$FORMAT_MSG" != "no modified files to format" ]
then
  echo "Run git clang-format before committing!"
  echo
  # Run git clang-format once again to show the error
  git clang-format master HEAD -q --diff
  exit 1
fi
