(module
  (table $t 1 1 funcref)
  (elem (i32.const 0) $f)
  (func $f)
)
(module
  (table $t 1 1 funcref)
  (elem (table $t) (i32.const 0) func $f)
  (func $f)
)
(module
  (table $t1 1 1 funcref)
  (table $t2 1 1 funcref)
  (elem (table $t1) (i32.const 0) func $f)
  (func $f)
)
(module
  (type $t1 (func))
  (import "a" "b" (table $t1 1 10 funcref))
  (func $g)
  (table $t2 funcref (elem $g $f))
  (func $f
    (call_indirect (type $t1) (i32.const 0))
  )
)