(module
  (memory 1)
  (export "memory" memory)
  (export "test0" $test0)
  (export "test1" $test1)
  (export "test2" $test2)
  (export "test3" $test3)
  (func $test0 (result i32)
    (return
      (i32.const 192)
    )
  )
  (func $test1 (result i32)
    (return
      (i32.const 204)
    )
  )
  (func $test2 (result i32)
    (return
      (i32.const 4)
    )
  )
  (func $test3 (result i32)
    (return
      (i32.const 16)
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 216, "initializers": [] }
