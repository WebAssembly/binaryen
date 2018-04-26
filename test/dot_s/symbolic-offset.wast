(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 12) "\01\00\00\00\00\00\00\00\00\00\00\00")
 (export "f" (func $f))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $f (; 0 ;) (param $0 i32) (param $1 i32)
  (i32.store offset=16
   (get_local $0)
   (get_local $1)
  )
  (return)
 )
 (func $stackSave (; 1 ;) (result i32)
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (; 2 ;) (param $0 i32) (result i32)
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
 (func $stackRestore (; 3 ;) (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 24, "initializers": [], "declares": [], "externs": [], "implementedFunctions": ["_f","_stackSave","_stackAlloc","_stackRestore"], "exports": ["f","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
