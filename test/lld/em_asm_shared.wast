(module
 (type $0 (func (param i32 i32 i32) (result i32)))
 (type $1 (func))
 (type $2 (func (result i32)))
 (type $3 (func (param i32 i32 i32)))
 (type $4 (func (param i32 i32)))
 (type $5 (func (param i32) (result i32)))
 (type $6 (func (param i32 i32) (result i32)))
 (import "env" "memory" (memory $0 0))
 (data (global.get $gimport$3) "{ Module.print(\"Hello world\"); }\00{ return $0 + $1; }\00{ Module.print(\"Got \" + $0); }\00")
 (import "env" "__indirect_function_table" (table $timport$1 0 funcref))
 (import "env" "__stack_pointer" (global $gimport$2 (mut i32)))
 (import "env" "__memory_base" (global $gimport$3 i32))
 (import "env" "__table_base" (global $gimport$4 i32))
 (import "env" "emscripten_asm_const_int" (func $emscripten_asm_const_int (param i32 i32 i32) (result i32)))
 (export "__wasm_call_ctors" (func $__wasm_call_ctors))
 (export "__original_main" (func $__original_main))
 (export "_ZN20__em_asm_sig_builder12__em_asm_sigIJEEEKNS_5innerIJDpT_EEES3_" (func $__em_asm_sig_builder::inner<>\20const\20__em_asm_sig_builder::__em_asm_sig<>\28\29))
 (export "_ZN20__em_asm_sig_builder12__em_asm_sigIJiiEEEKNS_5innerIJDpT_EEES3_" (func $__em_asm_sig_builder::inner<int\2c\20int>\20const\20__em_asm_sig_builder::__em_asm_sig<int\2c\20int>\28int\2c\20int\29))
 (export "_ZN20__em_asm_sig_builder12__em_asm_sigIJiEEEKNS_5innerIJDpT_EEES3_" (func $__em_asm_sig_builder::inner<int>\20const\20__em_asm_sig_builder::__em_asm_sig<int>\28int\29))
 (export "_ZN20__em_asm_sig_builder8sig_charEi" (func $__em_asm_sig_builder::sig_char\28int\29))
 (export "main" (func $main))
 (func $__wasm_call_ctors (; 1 ;) (type $1)
  (call $__wasm_apply_relocs)
 )
 (func $__wasm_apply_relocs (; 2 ;) (type $1)
 )
 (func $__original_main (; 3 ;) (type $2) (result i32)
  (local $0 i32)
  (local $1 i32)
  (local $2 i32)
  (global.set $gimport$2
   (local.tee $0
    (i32.sub
     (global.get $gimport$2)
     (i32.const 32)
    )
   )
  )
  (i32.store8 offset=24
   (local.get $0)
   (call $__em_asm_sig_builder::inner<>\20const\20__em_asm_sig_builder::__em_asm_sig<>\28\29)
  )
  (drop
   (call $emscripten_asm_const_int
    (i32.add
     (local.tee $1
      (global.get $gimport$3)
     )
     (i32.const 0)
    )
    (i32.add
     (local.get $0)
     (i32.const 24)
    )
    (i32.const 0)
   )
  )
  (call $__em_asm_sig_builder::inner<int\2c\20int>\20const\20__em_asm_sig_builder::__em_asm_sig<int\2c\20int>\28int\2c\20int\29
   (i32.add
    (local.get $0)
    (i32.const 24)
   )
   (i32.const 13)
   (i32.const 27)
  )
  (i64.store offset=16
   (local.get $0)
   (i64.const 115964117005)
  )
  (call $__em_asm_sig_builder::inner<int>\20const\20__em_asm_sig_builder::__em_asm_sig<int>\28int\29
   (i32.add
    (local.get $0)
    (i32.const 24)
   )
   (local.tee $2
    (call $emscripten_asm_const_int
     (i32.add
      (local.get $1)
      (i32.const 33)
     )
     (i32.add
      (local.get $0)
      (i32.const 24)
     )
     (i32.add
      (local.get $0)
      (i32.const 16)
     )
    )
   )
  )
  (i32.store
   (local.get $0)
   (local.get $2)
  )
  (drop
   (call $emscripten_asm_const_int
    (i32.add
     (local.get $1)
     (i32.const 53)
    )
    (i32.add
     (local.get $0)
     (i32.const 24)
    )
    (local.get $0)
   )
  )
  (global.set $gimport$2
   (i32.add
    (local.get $0)
    (i32.const 32)
   )
  )
  (i32.const 0)
 )
 (func $__em_asm_sig_builder::inner<>\20const\20__em_asm_sig_builder::__em_asm_sig<>\28\29 (; 4 ;) (type $2) (result i32)
  (i32.const 0)
 )
 (func $__em_asm_sig_builder::inner<int\2c\20int>\20const\20__em_asm_sig_builder::__em_asm_sig<int\2c\20int>\28int\2c\20int\29 (; 5 ;) (type $3) (param $0 i32) (param $1 i32) (param $2 i32)
  (local $3 i32)
  (global.set $gimport$2
   (local.tee $3
    (i32.sub
     (global.get $gimport$2)
     (i32.const 16)
    )
   )
  )
  (i32.store8 offset=13
   (local.get $3)
   (call $__em_asm_sig_builder::sig_char\28int\29
    (local.get $1)
   )
  )
  (local.set $2
   (call $__em_asm_sig_builder::sig_char\28int\29
    (local.get $2)
   )
  )
  (i32.store8
   (i32.add
    (local.get $0)
    (i32.const 2)
   )
   (i32.const 0)
  )
  (i32.store8 offset=14
   (local.get $3)
   (local.get $2)
  )
  (i32.store16 align=1
   (local.get $0)
   (i32.load16_u offset=13 align=1
    (local.get $3)
   )
  )
  (global.set $gimport$2
   (i32.add
    (local.get $3)
    (i32.const 16)
   )
  )
 )
 (func $__em_asm_sig_builder::inner<int>\20const\20__em_asm_sig_builder::__em_asm_sig<int>\28int\29 (; 6 ;) (type $4) (param $0 i32) (param $1 i32)
  (local $2 i32)
  (global.set $gimport$2
   (local.tee $2
    (i32.sub
     (global.get $gimport$2)
     (i32.const 16)
    )
   )
  )
  (local.set $1
   (call $__em_asm_sig_builder::sig_char\28int\29
    (local.get $1)
   )
  )
  (i32.store8 offset=15
   (local.get $2)
   (i32.const 0)
  )
  (i32.store8 offset=14
   (local.get $2)
   (local.get $1)
  )
  (i32.store16 align=1
   (local.get $0)
   (i32.load16_u offset=14
    (local.get $2)
   )
  )
  (global.set $gimport$2
   (i32.add
    (local.get $2)
    (i32.const 16)
   )
  )
 )
 (func $__em_asm_sig_builder::sig_char\28int\29 (; 7 ;) (type $5) (param $0 i32) (result i32)
  (i32.const 105)
 )
 (func $main (; 8 ;) (type $6) (param $0 i32) (param $1 i32) (result i32)
  (call $__original_main)
 )
 ;; custom section "dylink", size 5
 ;; custom section "producers", size 111
)

