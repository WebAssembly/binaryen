(module
  (memory 1
    (segment 0 "\00\00\00\00")
    (segment 4 "\01\00\00\00")
    (segment 8 "33\13@")
  )
  (export "memory" memory)
  (export "foo" $foo)
  (export "bar" $bar)
  (export "qux" $qux)
  (func $foo
    (return)
  )
  (func $bar (param $$0 i32) (result i32)
    (return
      (get_local $$0)
    )
  )
  (func $qux (param $$0 f64) (param $$1 f64) (result f64)
    (return
      (f64.add
        (get_local $$0)
        (get_local $$1)
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 12, "initializers": [] }
