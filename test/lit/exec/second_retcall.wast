
;; RUN: wasm-opt %s -all --fuzz-exec-before --fuzz-exec-second=%s.second -q -o /dev/null 2>&1 | filecheck %s

(module
 (import "fuzzing-support" "log-i32" (func $log-i32 (param i32)))

 (global $global funcref (ref.func $func))

 (export "global" (global $global))

 (func $func
  (call $log-i32
   (i32.const 42)
  )
 )
)

;; Export a funcref through a global, and return_call it from the other module.
;; It must be called ok, print 42, and not error.

;; CHECK:      [fuzz-exec] calling caller
;; CHECK-NEXT: [LoggingExternalInterface logging 42]

