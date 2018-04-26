(module
 (import "env" "STACKTOP" (global $STACKTOP$asm2wasm$import i32))
 (global $STACKTOP (mut i32) (get_global $STACKTOP$asm2wasm$import))

 (import "env" "UNUSEDTOP" (global $UNUSEDTOP$asm2wasm$import i32))
 (global $UNUSEDTOP (mut i32) (get_global $UNUSEDTOP$asm2wasm$import))

 (import "env" "imported_twice" (func $imported_twice_a)) ;; and used just once,
 (import "env" "imported_twice" (func $imported_twice_b)) ;; but the other should not kill the import for both!

 (import "env" "an-imported-table-func" (func $imported_table_func))

 (import "env" "table" (table 10 10 anyfunc))
 (elem (i32.const 0) $imported_table_func)

 (export "stackAlloc" (func $stackAlloc))

 (func $stackAlloc
  (drop (get_global $STACKTOP))
  (call $imported_twice_a)
 )
)

