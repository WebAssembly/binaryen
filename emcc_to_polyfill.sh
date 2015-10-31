#!/bin/sh
emcc $1 -o a.html --separate-asm
# we now have a.asm.js and a.js, combine them
# a.normal.js: just normal combination of the files. no wasm yet
cat src/templates/normal.js > a.normal.js
cat a.asm.js >> a.normal.js
cat a.js >> a.normal.js

