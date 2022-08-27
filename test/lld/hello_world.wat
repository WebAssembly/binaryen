(module
 (type $i32_=>_i32 (func (param i32) (result i32)))
 (type $none_=>_none (func))
 (type $none_=>_i32 (func (result i32)))
 (type $i32_i32_=>_i32 (func (param i32 i32) (result i32)))
 (import "env" "puts" (func $puts (param i32) (result i32)))
 (global $__stack_pointer (mut i32) (i32.const 66128))
 (memory $0 2)
 (data $.rodata (i32.const 568) "Hello, world\00")
 (table $0 1 1 funcref)
 (export "memory" (memory $0))
 (export "__wasm_call_ctors" (func $__wasm_call_ctors))
 (export "main" (func $main))
 (func $__wasm_call_ctors
 )
 (func $__original_main (result i32)
  (drop
   (call $puts
    (i32.const 568)
   )
  )
  (i32.const 0)
 )
 (func $main (param $0 i32) (param $1 i32) (result i32)
  (call $__original_main)
 )
 ;; custom section "producers", size 112
)

