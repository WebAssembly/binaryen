;; RUN: not wasm-opt %s -all 2>&1 | filecheck %s

;; CHECK: global initializer should only refer to previous globals

(module
  (global $a i32 (global.get $b))
  (global $b i32 (global.get $a))
)
