;; Test that declaring supertypes without GC is a validation error.

;; RUN:  not wasm-opt %s -all --disable-gc 2>&1 | filecheck %s

;; CHECK: all used types should be allowed

(module
  (type $f1 (sub (func)))
  (type $f2 (sub $f1 (func)))

  (func $test (type $f2)
    (unreachable)
  )
 )