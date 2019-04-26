#!/bin/bash
FORMAT_MSG=$(git clang-format master HEAD -q --diff --extensions c,cpp,h)
if [ -n "$FORMAT_MSG" -a "$FORMAT_MSG" != "no modified files to format" ]
then
  echo "Run git clang-format before committing!"
  echo
  echo $FORMAT_MSG
  exit 1
fi
