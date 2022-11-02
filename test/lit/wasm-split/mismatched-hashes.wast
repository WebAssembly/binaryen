;; Check that using different inputs for the instrumentation and splitting steps
;; results in an error.

;; Instrument the module
;; RUN: wasm-split --instrument %s -o %t.instrumented.wasm

;; Generate a profile
;; RUN: node %S/call_exports.mjs %t.instrumented.wasm %t.prof

;; Attempt to split the instrumented module
;; RUN: not wasm-split %t.instrumented.wasm --profile=%t.prof -o1 %t.1.wasm -o2 %t.2.wasm \
;; RUN:   2>&1 | filecheck %s

;; CHECK:      error: checksum in profile does not match module checksum.
;; CHECK-SAME: The split module must be the original module that was instrumented
;; CHECK-SAME: to generate the profile.

;; Check that the matching module succeeds
;; RUN: wasm-split %s --profile=%t.prof -o1 %t.1.wasm -o2 %t.2.wasm

(module
 (memory 0 0)
 (export "memory" (memory 0 0))
)
