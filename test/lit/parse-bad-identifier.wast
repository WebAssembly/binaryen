;; RUN: not wasm-opt %s -S -o - 2>&1 | filecheck %s

;; CHECK: 7:10: error: expected valtype

(module
  ;; String identifiers must still be UTF-8.
  (global $"\ff" i32 (i32.const 0))
)
