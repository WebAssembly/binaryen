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

;; First we call $get from this module. When we run the second module, we call
;; it once to get a ref to itself, then call_ref it, logging 10 twice.

;; CHECK: [fuzz-exec] calling get
;; CHECK-NEXT: [LoggingExternalInterface logging 10]
;; CHECK-NEXT: [fuzz-exec] note result: get => function
;; CHECK-NEXT: [fuzz-exec] running second module
;; CHECK-NEXT: [fuzz-exec] calling run
;; CHECK-NEXT: [LoggingExternalInterface logging 10]
;; CHECK-NEXT: [LoggingExternalInterface logging 10]

