(module
 (import "env" "js_func" (func $a_js_func))
 (import "env" "js_func_unused" (func $an_unused_js_func))
 (import "env" "DYNAMICTOP_PTR" (global $DYNAMICTOP_PTR$asm2wasm$import i32))
 (import "env" "DYNAMICTOP_PTR_unused" (global $DYNAMICTOP_PTR$asm2wasm$import_unused i32))
 (import "env" "memory" (memory $0 256 256))
 (import "env" "table" (table 10 10 funcref))

 (export "wasm_func" (func $a_wasm_func))
 (export "wasm_func_unused" (func $an_unused_wasm_func))

 (global $__THREW__ (mut i32) (i32.const 0))
 (global $__THREW__unused (mut i32) (i32.const 0))
 (global $from_segment (mut i32) (i32.const 0))
 (global $from_segment_2 (mut i32) (i32.const 0))
 (global $from_segment_never_used (mut i32) (i32.const 0))

 (data (i32.const 1024) "abcd")
 (data (global.get $from_segment) "abcd")
 (elem (global.get $from_segment_2) $table_func)

 (func $a_wasm_func
  (call $a_js_func)
  (drop (global.get $DYNAMICTOP_PTR$asm2wasm$import))
  (drop (global.get $__THREW__))
 )
 (func $an_unused_wasm_func
  (drop (global.get $DYNAMICTOP_PTR$asm2wasm$import_unused))
  (drop (global.get $__THREW__unused))
 )
 (func $table_func
 )
)

