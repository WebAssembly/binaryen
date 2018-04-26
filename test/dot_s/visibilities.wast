(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (export "foo" (func $foo))
 (export "bar" (func $bar))
 (export "qux" (func $qux))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $foo (; 0 ;)
  (return)
 )
 (func $bar (; 1 ;)
  (return)
 )
 (func $qux (; 2 ;)
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
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": [], "declares": [], "externs": [], "implementedFunctions": ["_foo","_bar","_qux","_stackSave","_stackAlloc","_stackRestore"], "exports": ["foo","bar","qux","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
