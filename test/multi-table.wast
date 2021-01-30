(module
  (import "a" "b" (table $t1 1 10 funcref))
  (table $t2 3 3 funcref)

  ;; add to $t1
  (elem (i32.const 0) $f)

  ;; add to $t2
  (elem (table $t2) (i32.const 0) func $f)
  (elem (table $t2) (offset (i32.const 1)) func $f $g)

  (func $f)
  (func $g)
)