(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "z2s_func" (func $z2s_func))
 (export "s2z_func" (func $s2z_func))
 (export "z2s_call" (func $z2s_call))
 (export "s2z_call" (func $s2z_call))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $z2s_func (; 0 ;) (param $0 i32) (result i32)
  (return
   (i32.shr_s
    (i32.shl
     (get_local $0)
     (i32.const 24)
    )
    (i32.const 24)
   )
  )
 )
 (func $s2z_func (; 1 ;) (param $0 i32) (result i32)
  (return
   (i32.and
    (get_local $0)
    (i32.const 255)
   )
  )
 )
 (func $z2s_call (; 2 ;) (param $0 i32) (result i32)
  (return
   (call $z2s_func
    (i32.and
     (get_local $0)
     (i32.const 255)
    )
   )
  )
 )
 (func $s2z_call (; 3 ;) (param $0 i32) (result i32)
  (return
   (i32.shr_s
    (i32.shl
     (call $s2z_func
      (i32.shr_s
       (i32.shl
        (get_local $0)
        (i32.const 24)
       )
       (i32.const 24)
      )
     )
     (i32.const 24)
    )
    (i32.const 24)
   )
  )
 )
 (func $stackSave (; 4 ;) (result i32)
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (; 5 ;) (param $0 i32) (result i32)
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
 (func $stackRestore (; 6 ;) (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [], "declares": [], "externs": [], "implementedFunctions": ["_z2s_func","_s2z_func","_z2s_call","_s2z_call","_stackSave","_stackAlloc","_stackRestore"], "exports": ["z2s_func","s2z_func","z2s_call","s2z_call","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
