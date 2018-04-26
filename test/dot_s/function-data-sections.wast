(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 12) "\00\00\00\00")
 (data (i32.const 16) "\01\00\00\00")
 (data (i32.const 20) "33\13@")
 (export "foo" (func $foo))
 (export "bar" (func $bar))
 (export "qux" (func $qux))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $foo (; 0 ;)
  (return)
 )
 (func $bar (; 1 ;) (param $0 i32) (result i32)
  (return
   (get_local $0)
  )
 )
 (func $qux (; 2 ;) (param $0 f64) (param $1 f64) (result f64)
  (return
   (f64.add
    (get_local $0)
    (get_local $1)
   )
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
;; METADATA: { "asmConsts": {},"staticBump": 24, "initializers": [], "declares": [], "externs": [], "implementedFunctions": ["_foo","_bar","_qux","_stackSave","_stackAlloc","_stackRestore"], "exports": ["foo","bar","qux","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
