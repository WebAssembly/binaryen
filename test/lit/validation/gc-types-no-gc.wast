;; Test that using GC types without GC is a validation error.

;; RUN: not wasm-opt --hybrid -all --disable-gc %s 2>&1 | filecheck %s

;; CHECK: Recursion groups require GC [--enable-gc] and isorecursive types [--hybrid]
;; CHECK: Struct types require GC [--enable-gc]
;; CHECK: Array types require GC [--enable-gc]

(module
  (rec
    (type $f1 (func))
    (type $f2 (func))
  )

  (type $struct (struct))
  (type $array (array i32))

  (func $test1 (type $f1)
    (unreachable)
  )

  (func $test2 (param (ref $struct) (ref $array))
    (unreachable)
  )
)
