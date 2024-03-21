;; Test that declaring non-final types without GC is a validation error.

;; RUN:  not wasm-opt %s -all --disable-gc 2>&1 | filecheck %s

;; CHECK: all used types should be allowed

(module
  (type $f1 (sub (func)))

  (func $test (type $f1)
    (unreachable)
  )
)