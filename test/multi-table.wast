(module
  (import "a" "b" (table $t1 1 10 funcref))
  (table $t2 3 3 funcref)
  (table $t3 4 4 funcref)

  ;; add to $t1
  (elem (i32.const 0) $f)

  ;; add to $t2
  (elem (table $t2) (i32.const 0) func $f)
  (elem $activeNonZeroOffset (table $t2) (offset (i32.const 1)) func $f $g)

  (elem $e3-1 (table $t3) (i32.const 0) funcref (ref.func $f) (ref.null func))
  (elem $e3-2 (table $t3) (offset (i32.const 2)) funcref (item ref.func $f) (item (ref.func $g)))

  (elem $passive funcref (item ref.func $f) (item (ref.func $g)) (ref.null func))
  (elem $empty func)
  (elem $declarative declare func $h)

  (func $f (drop (ref.func $h)))
  (func $g)
  (func $h)
)