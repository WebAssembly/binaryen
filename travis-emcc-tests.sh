#!/usr/bin/env bash

set -e
echo "travis-test build"
emconfigure cmake -DCMAKE_BUILD_TYPE=Release
emmake make -j4 binaryen_js
mkdir -p out
cp bin/binaryen_js.js out/binaryen.js
echo "travis-test test"
python3 -m scripts.test.binaryenjs
echo "travis-test yay!"
