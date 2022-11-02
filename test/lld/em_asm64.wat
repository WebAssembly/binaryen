(module
 (type $i64_i64_i64_=>_i32 (func (param i64 i64 i64) (result i32)))
 (type $none_=>_none (func))
 (type $none_=>_i32 (func (result i32)))
 (type $i32_i64_=>_i32 (func (param i32 i64) (result i32)))
 (import "env" "emscripten_asm_const_int" (func $emscripten_asm_const_int (param i64 i64 i64) (result i32)))
 (global $__stack_pointer (mut i64) (i64.const 66208))
 (global $global$1 i64 (i64.const 574))
 (global $global$2 i64 (i64.const 658))
 (memory $0 i64 2)
 (data $.rodata (i64.const 568) "\00ii\00i\00")
 (data $em_asm (i64.const 574) "{ Module.print(\"Hello world\"); }\00{ return $0 + $1; }\00{ Module.print(\"Got \" + $0); }\00")
 (table $0 1 1 funcref)
 (export "memory" (memory $0))
 (export "__wasm_call_ctors" (func $__wasm_call_ctors))
 (export "main" (func $main))
 (export "__start_em_asm" (global $global$1))
 (export "__stop_em_asm" (global $global$2))
 (func $__wasm_call_ctors
 )
 (func $__original_main (result i32)
  (local $0 i64)
  (global.set $__stack_pointer
   (local.tee $0
    (i64.sub
     (global.get $__stack_pointer)
     (i64.const 32)
    )
   )
  )
  (drop
   (call $emscripten_asm_const_int
    (i64.const 574)
    (i64.const 568)
    (i64.const 0)
   )
  )
  (i64.store offset=16
   (local.get $0)
   (i64.const 115964117005)
  )
  (i32.store
   (local.get $0)
   (call $emscripten_asm_const_int
    (i64.const 607)
    (i64.const 569)
    (i64.add
     (local.get $0)
     (i64.const 16)
    )
   )
  )
  (drop
   (call $emscripten_asm_const_int
    (i64.const 627)
    (i64.const 572)
    (local.get $0)
   )
  )
  (global.set $__stack_pointer
   (i64.add
    (local.get $0)
    (i64.const 32)
   )
  )
  (i32.const 0)
 )
 (func $main (param $0 i32) (param $1 i64) (result i32)
  (call $__original_main)
 )
 ;; custom section "producers", size 112
 ;; features section: memory64
)

