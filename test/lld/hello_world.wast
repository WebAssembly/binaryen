(module
 (type $0 (func (param i32) (result i32)))
 (type $1 (func (result i32)))
 (type $2 (func))
 (import "env" "puts" (func $puts (param i32) (result i32)))
 (global $global$0 (mut i32) (i32.const 66128))
 (global $global$1 i32 (i32.const 66128))
 (global $global$2 i32 (i32.const 581))
 (table 1 1 funcref)
 (memory $0 2)
 (data (i32.const 568) "Hello, world\00")
 (export "memory" (memory $0))
 (export "__wasm_call_ctors" (func $__wasm_call_ctors))
 (export "main" (func $main))
 (export "__heap_base" (global $global$1))
 (export "__data_end" (global $global$2))
 (func $main (; 1 ;) (type $1) (result i32)
  (drop
   (call $puts
    (i32.const 568)
   )
  )
  (i32.const 0)
 )
 (func $__wasm_call_ctors (; 2 ;) (type $2)
 )
 ;; custom section "linking", size 3
)

