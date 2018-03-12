(module
 (type $FUNCSIG$vi (func (param i32)))
 (import "env" "memory" (memory $0 1))
 (import "env" "emscripten_asm_const_v" (func $emscripten_asm_const_v (param i32)))
 (table 0 anyfunc)
 (data (i32.const 16) "{ Module.print(\"hello, world!\"); }\00")
 (export "main" (func $main))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $main (; 1 ;) (result i32)
  (call $emscripten_asm_const_v
   (i32.const 0)
  )
  (return
   (i32.const 0)
  )
 )
 (func $stackSave (; 2 ;) (result i32)
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (; 3 ;) (param $0 i32) (result i32)
  (local $1 i32)
  (i32.store offset=4
   (i32.const 0)
   (tee_local $1
    (i32.and
     (i32.sub
      (i32.load offset=4
       (i32.const 0)
      )
      (get_local $0)
     )
     (i32.const -16)
    )
   )
  )
  (get_local $1)
 )
 (func $stackRestore (; 4 ;) (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
)
;; METADATA: { "asmConsts": {"0": ["{ Module.print(\"hello, world!\"); }", ["v"]]},"staticBump": 51, "initializers": [], "declares": [], "externs": [], "implementedFunctions": ["_main","_stackSave","_stackAlloc","_stackRestore"], "exports": ["main","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
