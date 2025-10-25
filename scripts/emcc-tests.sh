#!/usr/bin/env bash

set -o errexit
set -o pipefail

SRCDIR="$(dirname $(dirname ${BASH_SOURCE[0]}))"

mkdir -p emcc-build-dbg
echo "emcc-tests: build dbg"
emcmake cmake -S $SRCDIR -B emcc-build-dbg -DCMAKE_BUILD_TYPE=Debug -G Ninja
ninja -C emcc-build-dbg binaryen_js
echo "emcc-tests: test dbg"
$SRCDIR/check.py --binaryen-bin=emcc-build-dbg/bin binaryenjs

mkdir -p emcc-build
echo "emcc-tests: build"
emcmake cmake -S $SRCDIR -B emcc-build -DCMAKE_BUILD_TYPE=Release -G Ninja
ninja -C emcc-build binaryen_js
echo "emcc-tests: test"
$SRCDIR/check.py --binaryen-bin=emcc-build/bin binaryenjs
echo "emcc-tests: done"
