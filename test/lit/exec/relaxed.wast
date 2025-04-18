;; NOTE: Assertions have been generated by update_lit_checks.py --all-items --output=fuzz-exec and should not be edited.

;; RUN: wasm-opt %s -all --fuzz-exec-before -q -o /dev/null 2>&1 | filecheck %s

(module
 (import "fuzzing-support" "log-i32" (func $log (param i32)))

 ;; CHECK:      [fuzz-exec] calling i32x4.dot_i8x16_i7x16_add_s
 ;; CHECK-NEXT: [LoggingExternalInterface logging 8]
 ;; CHECK-NEXT: [LoggingExternalInterface logging 14]
 ;; CHECK-NEXT: [LoggingExternalInterface logging 22]
 ;; CHECK-NEXT: [LoggingExternalInterface logging 32]
 (func $i32x4.dot_i8x16_i7x16_add_s (export "i32x4.dot_i8x16_i7x16_add_s")
  (local $v v128)
  (local.set $v
   (i32x4.dot_i8x16_i7x16_add_s
    (v128.const i32x4 0 1 2 3)
    (v128.const i32x4 4 5 6 7)
    (v128.const i32x4 8 9 10 11)
   )
  )
  (call $log
   (i32x4.extract_lane 0
    (local.get $v)
   )
  )
  (call $log
   (i32x4.extract_lane 1
    (local.get $v)
   )
  )
  (call $log
   (i32x4.extract_lane 2
    (local.get $v)
   )
  )
  (call $log
   (i32x4.extract_lane 3
    (local.get $v)
   )
  )
 )
)

