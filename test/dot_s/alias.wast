(module
 (type $FUNCSIG$v (func))
 (import "env" "memory" (memory $0 1))
 (table 2 2 anyfunc)
 (elem (i32.const 0) $__wasm_nullptr $__exit)
 (data (i32.const 16) "\d2\04\00\00\00\00\00\00)\t\00\00")
 (export "__exit" (func $__exit))
 (export "__needs_exit" (func $__needs_exit))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (export "dynCall_v" (func $dynCall_v))
 (func $__exit (; 0 ;) (type $FUNCSIG$v)
  (drop
   (i32.add
    (i32.load
     (i32.const 16)
    )
    (i32.load
     (i32.const 24)
    )
   )
  )
 )
 (func $__needs_exit (; 1 ;) (result i32)
  (call $__exit)
  (return
   (i32.const 1)
  )
 )
 (func $__wasm_nullptr (; 2 ;) (type $FUNCSIG$v)
  (unreachable)
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
 (func $dynCall_v (; 6 ;) (param $fptr i32)
  (call_indirect (type $FUNCSIG$v)
   (get_local $fptr)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 28, "initializers": [], "declares": [], "externs": [], "implementedFunctions": ["___exit","___needs_exit","_stackSave","_stackAlloc","_stackRestore","_dynCall_v"], "exports": ["__exit","__needs_exit","stackSave","stackAlloc","stackRestore","dynCall_v"], "invokeFuncs": [] }
