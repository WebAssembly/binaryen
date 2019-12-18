#!/usr/bin/env bash

set -e
echo "travis-test build"
emconfigure cmake -DCMAKE_BUILD_TYPE=Release
emmake make -j4 binaryen_js
echo "travis-test test"
python3 -m scripts.test.binaryenjs
echo "travis-test yay!"
