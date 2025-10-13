;; RUN: wasm-opt %s -all --fuzz-exec-before --fuzz-exec-second=%s.second -q -o /dev/null 2>&1 | filecheck %s

;; Test for confusion regarding internal function names when using call_ref from
;; JS. This module returns a funcref, which the other module will get, then
;; send to JS to be call_ref'd.

(module $primary
 (import "fuzzing-support" "log" (func $log (param i32)))

 (func $get (export "get") (result funcref)
  (call $log (i32.const 10))
  (ref.func $get)
 )
)

;; CHECK: [fuzz-exec] calling func
;; CHECK-NEXT: [exception thrown: tag nullref]
;; CHECK-NEXT: [fuzz-exec] running second module
;; CHECK-NEXT: [fuzz-exec] calling func2-internal
;; CHECK-NEXT: [exception thrown: tag nullref]
;; CHECK-NEXT: [fuzz-exec] calling func2-imported
;; CHECK-NEXT: func2-imported => null


