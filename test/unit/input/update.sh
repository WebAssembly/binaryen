#!/bin/bash

# This file updates the target_feature tests in the rare but unfortunate case
# that their roundtripped binary representations do not match the input anymore
# due to otherwise unrelated binary format changes.

WASM_OPT="../../../bin/wasm-opt" # edit when building out of tree

$WASM_OPT atomics_target_feature.wasm --enable-threads -g --emit-target-features -o atomics_target_feature.wasm
$WASM_OPT bulkmem_data.wasm --enable-bulk-memory -g --emit-target-features -o bulkmem_data.wasm
$WASM_OPT bulkmem_target_feature.wasm --enable-bulk-memory -g --emit-target-features -o bulkmem_target_feature.wasm
$WASM_OPT exception_handling_target_feature.wasm --enable-exception-handling --enable-reference-types -g --emit-target-features -o exception_handling_target_feature.wasm
$WASM_OPT gc_target_feature.wasm --enable-reference-types --enable-gc -g --emit-target-features -o gc_target_feature.wasm
$WASM_OPT mutable_globals_target_feature.wasm --enable-mutable-globals -g --emit-target-features -o mutable_globals_target_feature.wasm
$WASM_OPT reference_types_target_feature.wasm --enable-reference-types -g --emit-target-features -o reference_types_target_feature.wasm
$WASM_OPT signext_target_feature.wasm --enable-sign-ext -g --emit-target-features -o signext_target_feature.wasm
$WASM_OPT simd_target_feature.wasm --enable-simd -g --emit-target-features -o simd_target_feature.wasm
$WASM_OPT truncsat_target_feature.wasm --enable-nontrapping-float-to-int -g --emit-target-features -o truncsat_target_feature.wasm
$WASM_OPT tail_call_target_feature.wasm --enable-tail-call -g --emit-target-features -o tail_call_target_feature.wasm
