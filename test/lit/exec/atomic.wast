;; NOTE: Assertions have been generated by update_lit_checks.py --output=fuzz-exec and should not be edited.

;; RUN: wasm-opt %s -all --fuzz-exec-before -q -o /dev/null 2>&1 | filecheck %s

(module
 (import "fuzzing-support" "log-i32" (func $log (param i32)))

 (memory $0 23 256 shared)

 ;; CHECK:      [fuzz-exec] calling wait_and_log
 ;; CHECK-NEXT: [LoggingExternalInterface logging 0]
 (func $wait_and_log (export "wait_and_log")
  (call $log
   (memory.atomic.wait64
    (i32.const 0)
    (i64.const 0)
    (i64.const 0)
   )
  )
 )
)
