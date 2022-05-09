(module
  (type $none_=>_none (func))
  (type $A (struct))
  (global $g1 (ref null $none_=>_none) (ref.func $f))
  (global $g2 i32 (i32.const 0))

  (import "a" "b" (table $t1 1 10 funcref))
  (table $t2 3 3 funcref)
  (table $t3 4 4 funcref)
  (table $textern 0 externref)

  ;; A table with a typed function references specialized type.
  (table $tspecial 5 5 (ref null $none_=>_none))

  ;; add to $t1
  (elem (i32.const 0) $f)

  ;; add to $t2
  (elem (table $t2) (i32.const 0) func $f)
  (elem $activeNonZeroOffset (table $t2) (offset (i32.const 1)) func $f $g)

  (elem $e3-1 (table $t3) (global.get $g2) funcref (ref.func $f) (ref.null func))
  (elem $e3-2 (table $t3) (offset (i32.const 2)) (ref null $none_=>_none) (item ref.func $f) (item (ref.func $g)))

  (elem $passive-1 func $f $g)
  (elem $passive-2 funcref (item ref.func $f) (item (ref.func $g)) (ref.null func))
  (elem $passive-3 (ref null $none_=>_none) (item ref.func $f) (item (ref.func $g)) (ref.null $none_=>_none) (global.get $g1))
  (elem $empty func)
  (elem $declarative declare func $h)

  ;; This elem will be emitted as usesExpressions because of the type of the
  ;; table.
  (elem $especial (table $tspecial) (i32.const 0) (ref null $none_=>_none) $f $h)

  (func $f (drop (ref.func $h)))
  (func $g)
  (func $h)
)
