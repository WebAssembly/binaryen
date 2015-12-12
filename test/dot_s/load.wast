(module
  (memory 0 4294967295)
  (func $ldi32 (param $$0 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.load align=4
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $ldi64 (param $$0 i32) (result i64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.load align=8
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $ldf32 (param $$0 i32) (result f32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f32.load align=4
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $ldf64 (param $$0 i32) (result f64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f64.load align=8
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $ldoff (param $$0 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.load align=4
            (get_local $$0)
          )
        )
      )
    )
  )
)
