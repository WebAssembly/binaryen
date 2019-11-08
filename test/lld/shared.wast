(module
 (type $0 (func (param i32) (result i32)))
 (type $1 (func))
 (type $2 (func (result i32)))
 (import "env" "memory" (memory $0 0))
 (data (global.get $gimport$2) "Hello, world\00\00\00\00\00\00\00\00\01\00\00\00")
 (import "env" "__indirect_function_table" (table $timport$1 2 funcref))
 (elem (global.get $gimport$3) $puts $print_message\28\29)
 (import "env" "__memory_base" (global $gimport$2 i32))
 (import "env" "__table_base" (global $gimport$3 i32))
 (import "GOT.mem" "external_var" (global $gimport$5 (mut i32)))
 (import "GOT.func" "puts" (global $gimport$6 (mut i32)))
 (import "GOT.func" "_Z13print_messagev" (global $gimport$7 (mut i32)))
 (import "env" "puts" (func $puts (param i32) (result i32)))
 (global $global$0 i32 (i32.const 16))
 (global $global$1 i32 (i32.const 20))
 (export "__wasm_call_ctors" (func $__wasm_call_ctors))
 (export "_Z13print_messagev" (func $print_message\28\29))
 (export "ptr_puts" (global $global$0))
 (export "ptr_local_func" (global $global$1))
 (func $__wasm_call_ctors (; 1 ;) (type $1)
  (call $__wasm_apply_relocs)
 )
 (func $__wasm_apply_relocs (; 2 ;) (type $1)
  (i32.store
   (i32.add
    (global.get $gimport$2)
    (i32.const 16)
   )
   (i32.add
    (global.get $gimport$3)
    (i32.const 0)
   )
  )
  (i32.store
   (i32.add
    (global.get $gimport$2)
    (i32.const 20)
   )
   (i32.add
    (global.get $gimport$3)
    (i32.const 1)
   )
  )
 )
 (func $print_message\28\29 (; 3 ;) (type $2) (result i32)
  (drop
   (call $puts
    (i32.add
     (global.get $gimport$2)
     (i32.const 0)
    )
   )
  )
  (i32.load
   (global.get $gimport$5)
  )
 )
 ;; custom section "dylink", size 5
 ;; custom section "producers", size 111
)

