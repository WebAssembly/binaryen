(module
 (type $FUNCSIG$v (func))
 (import "env" "memory" (memory $0 1))
 (table 2 2 anyfunc)
 (elem (i32.const 0) $__wasm_nullptr $__exit)
 (data (i32.const 16) "\d2\04\00\00\00\00\00\00)\t\00\00")
 (export "__exit" (func $__exit))
 (export "__needs_exit" (func $__needs_exit))
 (export "dynCall_v" (func $dynCall_v))
 (func $__exit (type $FUNCSIG$v)
  (return
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
 (func $__needs_exit (result i32)
  (call $__exit)
  (return
   (i32.const 1)
  )
 )
 (func $__wasm_nullptr (type $FUNCSIG$v)
  (unreachable)
 )
 (func $dynCall_v (param $fptr i32)
  (call_indirect $FUNCSIG$v
   (get_local $fptr)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 28, "initializers": [] }
