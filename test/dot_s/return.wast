(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (export "return_i32" (func $return_i32))
 (export "return_void" (func $return_void))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $return_i32 (; 0 ;) (result i32)
  (i32.const 5)
 )
 (func $return_void (; 1 ;)
 )
 (func $fallthrough_return_nested_loop_i32 (; 2 ;) (result i32)
  (loop $label$0 (result i32)
   (loop $label$1 (result i32)
    (return
     (i32.const 1)
    )
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
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": [], "declares": [], "externs": [], "implementedFunctions": ["_return_i32","_return_void","_stackSave","_stackAlloc","_stackRestore"], "exports": ["return_i32","return_void","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
