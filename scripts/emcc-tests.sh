#!/usr/bin/env bash

set -o errexit
set -o pipefail

mkdir -p emcc-build

# TODO
# ninja -C emcc-build binaryen_embind_wasm
# NODE=nodejs ./check.py --binaryen-bin=emcc-build/bin binaryenjs_embind
#

echo "emcc-tests: build:wasm"
emcmake cmake -B emcc-build -DCMAKE_BUILD_TYPE=Release -G Ninja
ninja -C emcc-build binaryen_wasm
echo "emcc-tests: test:wasm"
./check.py --binaryen-bin=emcc-build/bin binaryenjs_wasm
echo "emcc-tests: done:wasm"

echo "emcc-tests: build:js"
ninja -C emcc-build  binaryen_js
echo "emcc-tests: test:js"
./check.py --binaryen-bin=emcc-build/bin binaryenjs
echo "emcc-tests: done:js"
