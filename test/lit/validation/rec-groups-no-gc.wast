;; Test that using rec groups types without GC is a validation error.

;; RUN:  not wasm-opt %s --hybrid -all --disable-gc 2>&1 | filecheck %s

;; CHECK: all used types should be allowed

(module
  (rec
    (type $f1 (func))
    (type $f2 (func))
  )

  (func $test (type $f1)
    (unreachable)
  )
)
