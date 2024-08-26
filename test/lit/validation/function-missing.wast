;; Test that we validate functions declaration and usage for globals.

;; RUN: not wasm-opt %s -all 2>&1 | filecheck %s

(module
  ;; CHECK: function not defined
  (global (mut i32) (block))

  ;; CHECK: function not defined
  (global (mut i32) (return_call 0))

  (func $0
  )
)