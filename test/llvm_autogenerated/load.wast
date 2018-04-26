(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "ldi32" (func $ldi32))
 (export "ldi64" (func $ldi64))
 (export "ldf32" (func $ldf32))
 (export "ldf64" (func $ldf64))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $ldi32 (; 0 ;) (param $0 i32) (result i32)
  (return
   (i32.load
    (get_local $0)
   )
  )
 )
 (func $ldi64 (; 1 ;) (param $0 i32) (result i64)
  (return
   (i64.load
    (get_local $0)
   )
  )
 )
 (func $ldf32 (; 2 ;) (param $0 i32) (result f32)
  (return
   (f32.load
    (get_local $0)
   )
  )
 )
 (func $ldf64 (; 3 ;) (param $0 i32) (result f64)
  (return
   (f64.load
    (get_local $0)
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
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [], "declares": [], "externs": [], "implementedFunctions": ["_ldi32","_ldi64","_ldf32","_ldf64","_stackSave","_stackAlloc","_stackRestore"], "exports": ["ldi32","ldi64","ldf32","ldf64","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
