(module
 (import "env" "g1" (global $g1 i32))
 (import "env" "g2" (global $g2 i32))

 (table $tbl 1 funcref)
 (elem (offset (global.get $g1)) funcref (ref.func $f))

 (memory 3)
 (data (offset (global.get $g2)) "xxx")

 (export "f" (func $f))
 (func $f (param i32)
  (call_indirect (param i32) (local.get 0) (i32.load8_u (i32.const 0))))
)
