(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (export "main" (func $main))
 (export "f1" (func $f1))
 (export "f2" (func $f2))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $main (; 0 ;) (result i32)
  (return
   (i32.const 5)
  )
 )
 (func $f1 (; 1 ;)
  (return)
 )
 (func $f2 (; 2 ;)
  (return)
 )
 (func $stackSave (; 3 ;) (result i32)
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (; 4 ;) (param $0 i32) (result i32)
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
 (func $stackRestore (; 5 ;) (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": ["main","f1","f2"], "declares": [], "externs": [], "implementedFunctions": ["_main","_f1","_f2","_stackSave","_stackAlloc","_stackRestore"], "exports": ["main","f1","f2","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
