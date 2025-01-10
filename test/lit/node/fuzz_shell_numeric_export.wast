;; Test that numeric exports appear in the right position. The JS rules
;; affecting the order of instance.exports can be confusing, and we want the
;; actual order in the wasm.

(module
  (func $a (export "a") (result i32)
    (i32.const 10)
  )

  (func $0 (export "0") (result i32)
    (i32.const 20)
  )

  (func $c (export "c") (result i32)
    (i32.const 30)
  )
)

;; Run in wasm-opt and in node to see they agree.
;; RUN: wasm-opt %s -o %t.wasm -q --fuzz-exec-before | filecheck %s
;; RUN: node %S/../../../scripts/fuzz_shell.js %t.wasm | filecheck %s
;;
;; CHECK: [fuzz-exec] calling a
;; CHECK: [fuzz-exec] note result: a => 10
;; CHECK: [fuzz-exec] calling 0
;; CHECK: [fuzz-exec] note result: 0 => 20
;; CHECK: [fuzz-exec] calling c
;; CHECK: [fuzz-exec] note result: c => 30

