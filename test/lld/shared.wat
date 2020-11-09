(module
 (type $none_=>_none (func))
 (type $none_=>_i32 (func (result i32)))
 (type $i32_=>_i32 (func (param i32) (result i32)))
 (import "env" "memory" (memory $mimport$0 0))
 (data (global.get $gimport$0) "Hello, world\00\00\00\00\00\00\00\00\00\00\00\00")
 (import "env" "__indirect_function_table" (table $timport$0 0 funcref))
 (import "env" "__memory_base" (global $gimport$0 i32))
 (import "env" "__table_base" (global $gimport$1 i32))
 (import "GOT.mem" "external_var" (global $gimport$2 (mut i32)))
 (import "GOT.func" "puts" (global $gimport$3 (mut i32)))
 (import "GOT.func" "_Z13print_messagev" (global $gimport$4 (mut i32)))
 (import "env" "puts" (func $puts (param i32) (result i32)))
 (global $global$0 i32 (i32.const 16))
 (global $global$1 i32 (i32.const 20))
 (export "__wasm_call_ctors" (func $__wasm_call_ctors))
 (export "_Z13print_messagev" (func $print_message\28\29))
 (export "ptr_puts" (global $global$0))
 (export "ptr_local_func" (global $global$1))
 (func $__wasm_call_ctors
  (call $__wasm_apply_relocs)
 )
 (func $__wasm_apply_relocs
  (i32.store
   (i32.add
    (global.get $gimport$0)
    (i32.const 16)
   )
   (global.get $gimport$3)
  )
  (i32.store
   (i32.add
    (global.get $gimport$0)
    (i32.const 20)
   )
   (global.get $gimport$4)
  )
 )
 (func $print_message\28\29 (result i32)
  (drop
   (call $puts
    (i32.add
     (global.get $gimport$0)
     (i32.const 0)
    )
   )
  )
  (i32.load
   (global.get $gimport$2)
  )
 )
 ;; dylink section
 ;;   memorysize: 24
 ;;   memoryalignment: 2
 ;;   tablesize: 0
 ;;   tablealignment: 0
 ;; custom section "producers", size 112
)

