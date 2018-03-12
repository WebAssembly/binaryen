(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "return_i32" (func $return_i32))
 (export "return_i32_twice" (func $return_i32_twice))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $return_i32 (; 0 ;) (param $0 i32) (result i32)
  (get_local $0)
 )
 (func $return_i32_twice (; 1 ;) (param $0 i32) (result i32)
  (block $label$0
   (br_if $label$0
    (i32.eqz
     (get_local $0)
    )
   )
   (i32.store
    (i32.const 0)
    (i32.const 0)
   )
   (return
    (i32.const 1)
   )
  )
  (i32.store
   (i32.const 0)
   (i32.const 2)
  )
  (i32.const 3)
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
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [], "declares": [], "externs": [], "implementedFunctions": ["_return_i32","_return_i32_twice","_stackSave","_stackAlloc","_stackRestore"], "exports": ["return_i32","return_i32_twice","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
