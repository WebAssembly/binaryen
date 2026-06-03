#!/bin/bash
#
# Runs Binaryen optimization stages as defined in j2wasm_application.bzl
# Usage: ./run_wasm_opts.sh <input.wat>
#
# Make sure 'wasm-opt' is in your PATH. You can get it via:
# blaze build //third_party/java_src/j2cl/third_party:binaryen
# and then run like this:
# WASM_OPT=./blaze-bin/third_party/java_src/j2cl/third_party/wasm-opt ./run_wasm_opts.sh <input.wat>
#
# Alternatively, binaryen may be available via apt:
# sudo apt-get install binaryen

set -euo pipefail

if [[ -z "${1-}" ]]; then
  echo "Usage: $0 <input.wat>"
  exit 1
fi

INPUT_WAT=$1
S1_OUT=intermediate1.wasm
S2_OUT=intermediate2.wasm
FINAL_OUT=output.wasm
WASM_OPT=${WASM_OPT:-wasm-opt}

echo "Using wasm-opt: $(which "$WASM_OPT" || echo "$WASM_OPT")"

COMMON_ARGS=(
  --enable-exception-handling
  --enable-gc
  --enable-reference-types
  --enable-sign-ext
  --enable-strings
  --enable-nontrapping-float-to-int
  --enable-bulk-memory
  --closed-world
  --traps-never-happen
)

STAGE1_ARGS=(
  --merge-j2cl-itables
  "--no-inline=*_<once>_*"
  --generate-global-effects
  -O3
  --cfp-reftest
  --optimize-j2cl
  --gufa
  --unsubtyping
  -O3
  --cfp-reftest
  --optimize-j2cl
  -O3
  --cfp-reftest
  --optimize-j2cl
)

STAGE2_ARGS=(
  "--no-inline=*_<once>_*"
  --generate-global-effects
  --partial-inlining-ifs=4
  -fimfs=25
  --gufa
  --unsubtyping
  -O3
  --cfp-reftest
  --optimize-j2cl
  -O3
  --cfp-reftest
  --optimize-j2cl
  -O3
  --cfp-reftest
  --optimize-j2cl
  --gufa
  --unsubtyping
  -O3
  --cfp-reftest
  --optimize-j2cl
  -O3
  --cfp-reftest
  --optimize-j2cl
)

STAGE3_ARGS=(
  "--no-full-inline=*_<once>_*"
  --generate-global-effects
  --partial-inlining-ifs=4
  --intrinsic-lowering
  --gufa
  --unsubtyping
  -O3
  --cfp-reftest
  --optimize-j2cl
  -O3
  --optimize-j2cl
  --cfp-reftest
  --type-merging
  -O3
  --cfp-reftest
  --optimize-j2cl
  --string-lowering-magic-imports-assert
  --remove-unused-module-elements
  --reorder-globals
  --type-finalizing
  --reorder-types
)

echo "Running stage 1: $INPUT_WAT -> $S1_OUT"
"$WASM_OPT" "$INPUT_WAT" "${COMMON_ARGS[@]}" "${STAGE1_ARGS[@]}" --debuginfo -o "$S1_OUT"

echo "Running stage 2: $S1_OUT -> $S2_OUT"
"$WASM_OPT" "$S1_OUT" "${COMMON_ARGS[@]}" "${STAGE2_ARGS[@]}" --debuginfo -o "$S2_OUT"

echo "Running stage 3: $S2_OUT -> $FINAL_OUT"
"$WASM_OPT" "$S2_OUT" "${COMMON_ARGS[@]}" "${STAGE3_ARGS[@]}" -o "$FINAL_OUT"

echo "Done. Intermediate files are $S1_OUT and $S2_OUT."
echo "Final output written to $FINAL_OUT"
