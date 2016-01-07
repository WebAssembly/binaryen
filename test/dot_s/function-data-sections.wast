(module
  (memory 16 4294967295 (segment 4 "\00\00\00\00") (segment 8 "\01\00\00\00") (segment 12 "33\13@"))
  (export "foo" $foo)
  (export "bar" $bar)
  (export "qux" $qux)
  (func $foo
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123)
      )
    )
  )
  (func $bar (param $$0 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (get_local $$0)
        )
      )
    )
  )
  (func $qux (param $$0 f64) (param $$1 f64) (result f64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f64.add
            (get_local $$0)
            (get_local $$1)
          )
        )
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 15 }
