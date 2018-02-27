(module
 (type $FUNCSIG$ii (func (param i32) (result i32)))
 (import "env" "foo" (func $foo (param i32) (result i32)))
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 16) "(int x)<::>{ Module.print(\"got x=\" + x); }\00")
 (export "main" (func $main))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $main (; 1 ;) (result i32)
  (return
   (call $foo
    (i32.const 15)
   )
  )
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
;; METADATA: { "asmConsts": {},"emJsFuncs": {"foo": "(int x)<::>{ Module.print(\"got x=\" + x); }"},"staticBump": 59, "initializers": [], "declares": [], "externs": [], "implementedFunctions": ["_main","_stackSave","_stackAlloc","_stackRestore"], "exports": ["main","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
