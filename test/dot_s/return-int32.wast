(module
  (memory 0 4294967295)
  (export "return_i32" $return_i32)
  (func $return_i32 (param $$0 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (get_local $$0)
        )
      )
    )
  )
)
