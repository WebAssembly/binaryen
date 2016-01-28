(module
  (memory 0 4294967295)
  (export "__exit" $__exit)
  (export "__needs_exit" $__needs_exit)
  (func $__exit
    (local $$0 i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123)
      )
    )
  )
  (func $__needs_exit
    (block $fake_return_waka123
      (block
        (call $__exit)
        (br $fake_return_waka123)
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 4 }
