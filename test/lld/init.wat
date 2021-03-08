(module
 (type $none_=>_none (func))
 (type $none_=>_i32 (func (result i32)))
 (type $i32_i32_=>_i32 (func (param i32 i32) (result i32)))
 (memory $0 2)
 (table $0 1 1 funcref)
 (global $global$0 (mut i32) (i32.const 66112))
 (export "memory" (memory $0))
 (export "__wasm_call_ctors" (func $__wasm_call_ctors))
 (export "main" (func $main))
 (func $__wasm_call_ctors
  (call $init_x)
  (call $init_y)
 )
 (func $init_x
  (i32.store offset=568
   (i32.const 0)
   (i32.const 14)
  )
 )
 (func $init_y
  (i32.store offset=572
   (i32.const 0)
   (i32.const 144)
  )
 )
 (func $__original_main (result i32)
  (i32.add
   (i32.load offset=568
    (i32.const 0)
   )
   (i32.load offset=572
    (i32.const 0)
   )
  )
 )
 (func $main (param $0 i32) (param $1 i32) (result i32)
  (call $__original_main)
 )
 ;; custom section "producers", size 112
)

