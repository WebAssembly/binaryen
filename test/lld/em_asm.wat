(module
 (type $0 (func (param i32 i32 i32) (result i32)))
 (type $1 (func))
 (type $2 (func (result i32)))
 (type $3 (func (param i32 i32) (result i32)))
 (import "env" "emscripten_asm_const_int" (func $emscripten_asm_const_int (param i32 i32 i32) (result i32)))
 (memory $0 2)
 (data (i32.const 568) "{ Module.print(\"Hello world\"); }\00\00{ return $0 + $1; }\00ii\00{ Module.print(\"Got \" + $0); }\00i\00")
 (table $0 1 1 funcref)
 (global $global$0 (mut i32) (i32.const 66208))
 (global $global$1 i32 (i32.const 658))
 (export "memory" (memory $0))
 (export "__wasm_call_ctors" (func $__wasm_call_ctors))
 (export "main" (func $main))
 (export "__data_end" (global $global$1))
 (func $__wasm_call_ctors (; 1 ;) (type $1)
 )
 (func $__original_main (; 2 ;) (type $2) (result i32)
  (local $0 i32)
  (global.set $global$0
   (local.tee $0
    (i32.sub
     (global.get $global$0)
     (i32.const 32)
    )
   )
  )
  (drop
   (call $emscripten_asm_const_int
    (i32.const 568)
    (i32.const 601)
    (i32.const 0)
   )
  )
  (i64.store offset=16
   (local.get $0)
   (i64.const 115964117005)
  )
  (i32.store
   (local.get $0)
   (call $emscripten_asm_const_int
    (i32.const 602)
    (i32.const 622)
    (i32.add
     (local.get $0)
     (i32.const 16)
    )
   )
  )
  (drop
   (call $emscripten_asm_const_int
    (i32.const 625)
    (i32.const 656)
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
 (func $main (; 3 ;) (type $3) (param $0 i32) (param $1 i32) (result i32)
  (call $__original_main)
 )
 ;; custom section "producers", size 112
)

