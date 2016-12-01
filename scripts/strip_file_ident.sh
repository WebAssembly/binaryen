#!/bin/sh
for file in $(find test/torture-s); do
    echo "$file"
    sed '/^\s*\.file/d; /^\s*\.ident/d' "$file" > out.s
    cp out.s "$file"
done
