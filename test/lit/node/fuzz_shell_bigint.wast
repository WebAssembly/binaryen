;; Test that bigints are printed correctly in JS, both the low and high bits.

(module
  (func $big (export "big") (result i64)
    (i64.const -1)
  )

  (func $medium (export "medium") (result i64)
    ;; A number big enough to hit the JS 2^53 precision limit. We must print it
    ;; carefully.
    (i64.const 0x1000000000000001)
  )
)

;; RUN: wasm-opt %s -o %t.wasm -q
;; RUN: node %S/../../../scripts/fuzz_shell.js %t.wasm | filecheck %s

;; CHECK:      [fuzz-exec] calling big
;; CHECK-NEXT: [fuzz-exec] note result: big => -1 -1
;; CHECK-NEXT: [fuzz-exec] calling medium
;; CHECK-NEXT: [fuzz-exec] note result: medium => 1 268435456

