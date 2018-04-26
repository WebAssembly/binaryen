(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (export "test_traps" (func $test_traps))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $test_traps (; 0 ;) (param $0 f32) (param $1 f64) (result i32)
  (i32.div_u
   (i32.trunc_s/f32
    (get_local $0)
   )
   (i32.trunc_u/f64
    (get_local $1)
   )
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
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": [], "declares": [], "externs": [], "implementedFunctions": ["_test_traps","_stackSave","_stackAlloc","_stackRestore"], "exports": ["test_traps","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
