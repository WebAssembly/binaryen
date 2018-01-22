(module
 (type $0 (func))
 (type $1 (func (result i32)))
 (global $global$0 (mut i32) (i32.const 66576))
 (global $global$1 i32 (i32.const 66576))
 (table 1 1 anyfunc)
 (memory $0 2)
 (data (i32.const 1024) "\00\00\00\00\00\00\00\00")
 (export "memory" (memory $0))
 (export "main" (func $main))
 (export "__wasm_call_ctors" (func $__wasm_call_ctors))
 (export "__heap_base" (global $global$1))
 (func $init_x (; 0 ;) (type $0)
  (i32.store offset=1024
   (i32.const 0)
   (i32.const 14)
  )
 )
 (func $init_y (; 1 ;) (type $0)
  (i32.store offset=1028
   (i32.const 0)
   (i32.const 144)
  )
 )
 (func $main (; 2 ;) (type $1) (result i32)
  (i32.add
   (i32.load offset=1024
    (i32.const 0)
   )
   (i32.load offset=1028
    (i32.const 0)
   )
  )
 )
 (func $__wasm_call_ctors (; 3 ;) (type $0)
  (call $init_x)
  (call $init_y)
 )
 ;; custom section "linking", size 3
)

