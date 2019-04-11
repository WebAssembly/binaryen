(module
 (type $0 (func (param i32) (result i32)))
 (type $1 (func))
 (type $2 (func (result i32)))
 (import "env" "memory" (memory $0 0))
 (data (global.get $gimport$2) "\00\00\00\00Hello, world\00")
 (import "env" "__indirect_function_table" (table $timport$1 1 funcref))
 (elem (global.get $gimport$3) $puts)
 (import "env" "__memory_base" (global $gimport$2 i32))
 (import "env" "__table_base" (global $gimport$3 i32))
 (import "GOT.mem" "external_var" (global $gimport$5 (mut i32)))
 (import "GOT.func" "puts" (global $gimport$6 (mut i32)))
 (import "env" "puts" (func $puts (param i32) (result i32)))
 (global $global$0 i32 (i32.const 0))
 (export "__wasm_call_ctors" (func $__wasm_call_ctors))
 (export "print_message" (func $print_message))
 (export "ptr" (global $global$0))
 (func $__wasm_call_ctors (; 1 ;) (type $1)
  (call $__wasm_apply_relocs)
 )
 (func $__wasm_apply_relocs (; 2 ;) (type $1)
  (i32.store
   (i32.add
    (global.get $gimport$2)
    (i32.const 0)
   )
   (i32.add
    (global.get $gimport$3)
    (i32.const 0)
   )
  )
 )
 (func $print_message (; 3 ;) (type $2) (result i32)
  (drop
   (call $puts
    (i32.add
     (global.get $gimport$2)
     (i32.const 4)
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

