(module
 (type $0 (func (result i32)))
 (type $1 (func (param i32) (result i32)))
 (type $2 (func (param i32 i32 i32) (result i32)))
 (type $3 (func (param i32 i32) (result i32)))
 (import "env" "_Z24emscripten_asm_const_intIJEEiPKcDpT_" (func $import$0 (param i32) (result i32)))
 (import "env" "_Z24emscripten_asm_const_intIJiiEEiPKcDpT_" (func $import$1 (param i32 i32 i32) (result i32)))
 (import "env" "_Z24emscripten_asm_const_intIJiEEiPKcDpT_" (func $import$2 (param i32 i32) (result i32)))
 (global $global$0 (mut i32) (i32.const 66656))
 (table 1 1 anyfunc)
 (memory $0 2)
 (data (i32.const 1024) "{ Module.print(\"Hello world\"); }\00{ return $0 + $1; }\00{ Module.print(\"Got \" + $0); }\00")
 (export "memory" (memory $0))
 (export "main" (func $main))
 (func $main (; 3 ;) (type $0) (result i32)
  (drop
   (call $import$0
    (i32.const 1024)
   )
  )
  (drop
   (call $import$2
    (i32.const 1077)
    (call $import$1
     (i32.const 1057)
     (i32.const 13)
     (i32.const 27)
    )
   )
  )
  (i32.const 0)
 )
 ;; custom section "linking", size 3
)

