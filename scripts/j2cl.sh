#!/bin/bash

set -e

#
# Simplified version of
#
# https://github.com/google/j2cl/blob/e0dee1c7a726952c93d6ace95ddc39c7a6bcc74a/build_defs/internal_do_not_use/j2wasm_application.bzl#L4
#
# This can be useful for local testing of issues with j2cl output, by running
# this instead of setting up a full j2cl toolchain. Usage:
#
# j2cl.sh input.wasm output.wasm
#
# This will emit one file for each stage of compilation, as output.wasm.N.wasm.
#

COMMON="--enable-exception-handling --enable-gc --enable-reference-types --enable-sign-ext --enable-strings --enable-nontrapping-float-to-int --enable-bulk-memory --closed-world --traps-never-happen"

echo "Stage 1"
bin/wasm-opt $COMMON "--no-inline=*_<once>_*" -O3 --cfp-reftest --optimize-j2cl --gufa --unsubtyping -O3 --cfp-reftest --optimize-j2cl -O3 --cfp-reftest --optimize-j2cl $1 -o $2.1.wasm

echo "Stage 2"
bin/wasm-opt $COMMON  "--no-inline=*_<once>_*" --partial-inlining-ifs=4 -fimfs=25 --gufa --unsubtyping -O3 --cfp-reftest --optimize-j2cl -O3 --cfp-reftest --optimize-j2cl -O3 --cfp-reftest --optimize-j2cl --gufa --unsubtyping -O3 --cfp-reftest --optimize-j2cl -O3 --cfp-reftest --optimize-j2cl $2.1.wasm -o $2.2.wasm

echo "Stage 3"
bin/wasm-opt $COMMON "--no-full-inline=*_<once>_*" --partial-inlining-ifs=4 --intrinsic-lowering --gufa --unsubtyping -O3 --cfp-reftest --optimize-j2cl -O3 --optimize-j2cl --cfp-reftest --type-merging -O3 --cfp-reftest --optimize-j2cl --string-lowering --remove-unused-module-elements --reorder-globals --type-finalizing $2.2.wasm -o $2.3.wasm 

