;; RUN: not wasm-opt %s --new-wat-parser -all 2>&1 | filecheck %s

;; CHECK: global initializer should only refer to previous globals

(module
  (global $a i32 (global.get $b))
  (global $b i32 (global.get $a))
)
