#!/usr/bin/env bash

set -e

echo "emcc-tests: build:wasm"
emcmake cmake -DCMAKE_BUILD_TYPE=Release
emmake make -j4 binaryen_wasm
echo "emcc-tests: test:wasm"
./check.py binaryenjs
echo "emcc-tests: done:wasm"

echo "emcc-tests: build:js"
emmake make -j4 binaryen_js
echo "emcc-tests: test:js"
./check.py binaryenjs_wasm
echo "emcc-tests: done:js"
