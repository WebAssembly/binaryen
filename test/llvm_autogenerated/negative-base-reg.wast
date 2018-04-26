(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\90\04\00\00")
 (export "main" (func $main))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $main (; 0 ;) (result i32)
  (local $0 i32)
  (set_local $0
   (i32.const -128)
  )
  (loop $label$0
   (i32.store
    (i32.add
     (get_local $0)
     (i32.const 144)
    )
    (i32.const 1)
   )
   (br_if $label$0
    (tee_local $0
     (i32.add
      (get_local $0)
      (i32.const 4)
     )
    )
   )
  )
  (return
   (i32.const 0)
  )
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
;; METADATA: { "asmConsts": {},"staticBump": 1168, "initializers": [], "declares": [], "externs": [], "implementedFunctions": ["_main","_stackSave","_stackAlloc","_stackRestore"], "exports": ["main","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
