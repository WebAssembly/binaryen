(module
 (memory $0 2)
 (table $0 1 1 funcref)
 (elem (i32.const 0) $foo)
 (global $global$0 (mut i32) (i32.const 66112))
 (global $global$1 i32 (i32.const 66112))
 (global $global$2 i32 (i32.const 576))
 (export "memory" (memory $0))
 (export "__heap_base" (global $global$1))
 (export "__data_end" (global $global$2))
 (export "__wasm_call_ctors" (func $__wasm_call_ctors))
 (func $foo (result i32))
 (func $__wasm_call_ctors
  (nop)
 )
)

