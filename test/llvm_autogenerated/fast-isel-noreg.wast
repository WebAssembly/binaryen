(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "a" (func $a))
 (export "b" (func $b))
 (export "c" (func $c))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $a (; 0 ;) (result i32)
  (return
   (i32.const 0)
  )
 )
 (func $b (; 1 ;) (result i32)
  (block $label$0
   (br_if $label$0
    (i32.const 1)
   )
   (unreachable)
  )
  (return
   (i32.const 0)
  )
 )
 (func $c (; 2 ;) (result i32)
  (i32.store
   (i32.const 0)
   (i32.const 0)
  )
  (return
   (i32.const 0)
  )
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
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [], "declares": [], "externs": [], "implementedFunctions": ["_a","_b","_c","_stackSave","_stackAlloc","_stackRestore"], "exports": ["a","b","c","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
