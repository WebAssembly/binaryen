;; Test that declaring supertypes without GC is a validation error.

;; RUN:  not wasm-opt %s --hybrid -all --disable-gc 2>&1 | filecheck %s

;; CHECK: all used types should be allowed

(module
  (type $f1 (func_subtype func))
  (type $f2 (func_subtype $f1))

  (func $test (type $f2)
    (unreachable)
  )
 )