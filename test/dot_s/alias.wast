(module
  (memory 0)
  (export "__exit" $__exit)
  (export "__needs_exit" $__needs_exit)
  (func $__exit
    (local $$0 i32)
    (return)
  )
  (func $__needs_exit
    (call $__exit)
    (return)
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 4 }
