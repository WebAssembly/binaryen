(module
 (type $FUNCSIG$i (func (result i32)))
 (import "env" "return_something" (func $return_something (result i32)))
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "unused_first" (func $unused_first))
 (export "unused_second" (func $unused_second))
 (export "call_something" (func $call_something))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $unused_first (; 1 ;) (param $0 i32) (param $1 i32) (result i32)
  (return
   (get_local $1)
  )
 )
 (func $unused_second (; 2 ;) (param $0 i32) (param $1 i32) (result i32)
  (return
   (get_local $0)
  )
 )
 (func $call_something (; 3 ;)
  (drop
   (call $return_something)
  )
  (return)
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
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [], "declares": ["return_something"], "externs": [], "implementedFunctions": ["_unused_first","_unused_second","_call_something","_stackSave","_stackAlloc","_stackRestore"], "exports": ["unused_first","unused_second","call_something","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
