(module
 (type $0 (func (param i32) (result i32)))
 (type $1 (func (param i32 i32 i32) (result i32)))
 (type $2 (func (param i32 i32) (result i32)))
 (type $3 (func (result i32)))
 (type $4 (func))
 (import "env" "_Z24emscripten_asm_const_intIJEEiPKcDpT_" (func $_Z24emscripten_asm_const_intIJEEiPKcDpT_ (param i32) (result i32)))
 (import "env" "_Z24emscripten_asm_const_intIJiiEEiPKcDpT_" (func $_Z24emscripten_asm_const_intIJiiEEiPKcDpT_ (param i32 i32 i32) (result i32)))
 (import "env" "_Z24emscripten_asm_const_intIJiEEiPKcDpT_" (func $_Z24emscripten_asm_const_intIJiEEiPKcDpT_ (param i32 i32) (result i32)))
 (global $global$0 (mut i32) (i32.const 66192))
 (global $global$1 i32 (i32.const 66192))
 (global $global$2 i32 (i32.const 652))
 (table 1 1 anyfunc)
 (memory $0 2)
 (data (i32.const 568) "{ Module.print(\"Hello world\"); }\00{ return $0 + $1; }\00{ Module.print(\"Got \" + $0); }\00")
 (export "memory" (memory $0))
 (export "__wasm_call_ctors" (func $__wasm_call_ctors))
 (export "main" (func $main))
 (export "__heap_base" (global $global$1))
 (export "__data_end" (global $global$2))
 (func $main (; 3 ;) (type $3) (result i32)
  (drop
   (call $_Z24emscripten_asm_const_intIJEEiPKcDpT_
    (i32.const 568)
   )
  )
  (drop
   (call $_Z24emscripten_asm_const_intIJiEEiPKcDpT_
    (i32.const 621)
    (call $_Z24emscripten_asm_const_intIJiiEEiPKcDpT_
     (i32.const 601)
     (i32.const 13)
     (i32.const 27)
    )
   )
  )
  (i32.const 0)
 )
 (func $__wasm_call_ctors (; 4 ;) (type $4)
 )
 ;; custom section "linking", size 3
)

