(module
  (memory 1)
  (export "memory" memory)
  (type $FUNCSIG$v (func))
  (export "__exit" $__exit)
  (export "__needs_exit" $__needs_exit)
  (export "dynCall_v" $dynCall_v)
  (table $__exit)
  (func $__exit (type $FUNCSIG$v)
    (local $$0 i32)
    (return)
  )
  (func $__needs_exit (result i32)
    (call $__exit)
    (return
      (i32.const 0)
    )
  )
  (func $dynCall_v (param $fptr i32)
    (return
      (call_indirect $FUNCSIG$v
        (get_local $fptr)
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": [] }
