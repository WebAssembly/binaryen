;; Test that the instrumentation increases the memory bounds if necessary

;; RUN: wasm-split %s --instrument -S -o - | filecheck %s

;; CHECK: (memory $0 1 1)
;; CHECK: (export "__write_profile" (func $__write_profile))

(module
  (memory $0 0 0)
)
