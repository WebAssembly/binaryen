(module
 (type $0 (func (param i32) (result i32)))
 (type $1 (func))
 (type $2 (func (result i32)))
 (import "env" "memory" (memory $0 0))
 (data (global.get $gimport$2) "Hello, world\00")
 (import "env" "__indirect_function_table" (table $timport$1 0 funcref))
 (import "env" "__memory_base" (global $gimport$2 i32))
 (import "env" "__table_base" (global $gimport$3 i32))
 (import "GOT.func" "puts" (global $gimport$5 (mut i32)))
 (import "GOT.mem" "external_var" (global $gimport$6 (mut i32)))
 (import "env" "puts" (func $puts (param i32) (result i32)))
 (export "__wasm_call_ctors" (func $__wasm_call_ctors))
 (export "print_message" (func $print_message))
 (func $__wasm_call_ctors (; 1 ;) (type $1)
 )
 (func $print_message (; 2 ;) (type $2) (result i32)
  (drop
   (i32.add
    (global.get $gimport$2)
    (i32.const 0)
   )
  )
  (drop
   (call $print_message)
  )
  (i32.load
   (global.get $gimport$6)
  )
 )
 ;; custom section "dylink", size 5
 ;; custom section "producers", size 125
)

