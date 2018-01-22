(module
 (type $0 (func (result i32)))
 (type $1 (func (param i32) (result i32)))
 (type $2 (func))
 (import "env" "puts" (func $puts (param i32) (result i32)))
 (global $global$0 (mut i32) (i32.const 66576))
 (global $global$1 i32 (i32.const 66576))
 (table 1 1 anyfunc)
 (memory $0 2)
 (data (i32.const 1024) "Hello, world\00")
 (export "memory" (memory $0))
 (export "main" (func $main))
 (export "__wasm_call_ctors" (func $__wasm_call_ctors))
 (export "__heap_base" (global $global$1))
 (func $main (; 1 ;) (type $0) (result i32)
  (drop
   (call $puts
    (i32.const 1024)
   )
  )
  (i32.const 0)
 )
 (func $__wasm_call_ctors (; 2 ;) (type $2)
 )
 ;; custom section "linking", size 3
)

