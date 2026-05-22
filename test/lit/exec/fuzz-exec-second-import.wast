;; RUN: wasm-opt %s -all --fuzz-exec-before --fuzz-exec-second=%s.second -q -o /dev/null 2>&1 | filecheck %s

;; Check that imported externref globals work in second modules as well.

(module
  (import "__fuzz_import" "extern$" (global $gimport$0 externref))

  (func (export "check") (result i32)
    (ref.is_null (global.get $gimport$0))
  )
)

;; CHECK:      [fuzz-exec] export check
;; CHECK-NEXT: [fuzz-exec] note result: check => 0
;; CHECK:      [fuzz-exec] export check_second
;; CHECK-NEXT: [fuzz-exec] note result: check_second => 0
