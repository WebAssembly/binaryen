#!/usr/bin/env bash

set -e
echo "travis-test build:wasm"
emconfigure cmake -DCMAKE_BUILD_TYPE=Release
emmake make -j4 binaryen_wasm
echo "travis-test test:wasm"
python3 -m scripts.test.binaryenjs
echo "travis-test done:wasm"

echo "travis-test build:js"
emmake make -j4 binaryen_js
echo "travis-test test:js"
python3 -m scripts.test.binaryenjs
echo "travis-test done:js"
