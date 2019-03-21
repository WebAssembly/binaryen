(module
 (type $0 (func (param i32 i32 i32) (result i32)))
 (type $1 (func))
 (type $2 (func (result i32)))
 (type $3 (func (param i32 i32 i32)))
 (type $4 (func (param i32 i32)))
 (type $5 (func (param i32) (result i32)))
 (type $6 (func (param i32 i32) (result i32)))
 (import "env" "emscripten_asm_const_int" (func $emscripten_asm_const_int (param i32 i32 i32) (result i32)))
 (memory $0 2)
 (data (i32.const 568) "{ Module.print(\"Hello world\"); }\00{ return $0 + $1; }\00{ Module.print(\"Got \" + $0); }\00")
 (table $0 1 1 funcref)
 (global $global$0 (mut i32) (i32.const 66192))
 (global $global$1 i32 (i32.const 66192))
 (global $global$2 i32 (i32.const 652))
 (export "memory" (memory $0))
 (export "__wasm_call_ctors" (func $__wasm_call_ctors))
 (export "__heap_base" (global $global$1))
 (export "__data_end" (global $global$2))
 (export "main" (func $main))
 (func $__wasm_call_ctors (; 1 ;) (type $1)
 )
 (func $__original_main (; 2 ;) (type $2) (result i32)
  (local $0 i32)
  (local $1 i32)
  (global.set $global$0
   (local.tee $0
    (i32.sub
     (global.get $global$0)
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
    (i32.const 568)
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
   (local.tee $1
    (call $emscripten_asm_const_int
     (i32.const 601)
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
   (local.get $1)
  )
  (drop
   (call $emscripten_asm_const_int
    (i32.const 621)
    (i32.add
     (local.get $0)
     (i32.const 24)
    )
    (local.get $0)
   )
  )
  (global.set $global$0
   (i32.add
    (local.get $0)
    (i32.const 32)
   )
  )
  (i32.const 0)
 )
 (func $__em_asm_sig_builder::inner<>\20const\20__em_asm_sig_builder::__em_asm_sig<>\28\29 (; 3 ;) (type $2) (result i32)
  (i32.const 0)
 )
 (func $__em_asm_sig_builder::inner<int\2c\20int>\20const\20__em_asm_sig_builder::__em_asm_sig<int\2c\20int>\28int\2c\20int\29 (; 4 ;) (type $3) (param $0 i32) (param $1 i32) (param $2 i32)
  (local $3 i32)
  (global.set $global$0
   (local.tee $3
    (i32.sub
     (global.get $global$0)
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
  (global.set $global$0
   (i32.add
    (local.get $3)
    (i32.const 16)
   )
  )
 )
 (func $__em_asm_sig_builder::inner<int>\20const\20__em_asm_sig_builder::__em_asm_sig<int>\28int\29 (; 5 ;) (type $4) (param $0 i32) (param $1 i32)
  (local $2 i32)
  (global.set $global$0
   (local.tee $2
    (i32.sub
     (global.get $global$0)
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
  (global.set $global$0
   (i32.add
    (local.get $2)
    (i32.const 16)
   )
  )
 )
 (func $__em_asm_sig_builder::sig_char\28int\29 (; 6 ;) (type $5) (param $0 i32) (result i32)
  (i32.const 105)
 )
 (func $main (; 7 ;) (type $6) (param $0 i32) (param $1 i32) (result i32)
  (call $__original_main)
 )
 ;; custom section "producers", size 125
)

