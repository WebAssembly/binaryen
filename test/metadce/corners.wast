(module
 (import "env" "STACKTOP" (global $STACKTOP$asm2wasm$import i32))
 (import "env" "UNUSEDTOP" (global $UNUSEDTOP$asm2wasm$import i32))

 (import "env" "imported_twice" (func $imported_twice_a)) ;; and used just once,
 (import "env" "imported_twice" (func $imported_twice_b)) ;; but the other should not kill the import for both!

 (import "env" "an-imported-table-func" (func $imported_table_func))

 (import "env" "table" (table 10 10 funcref))

 (global $STACKTOP (mut i32) (global.get $STACKTOP$asm2wasm$import))
 (global $UNUSEDTOP (mut i32) (global.get $UNUSEDTOP$asm2wasm$import))

 (elem (i32.const 0) $imported_table_func)

 (export "stackAlloc" (func $stackAlloc))

 (func $stackAlloc
  (drop (global.get $STACKTOP))
  (call $imported_twice_a)
 )
)
