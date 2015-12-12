(module
  (memory 0 4294967295)
  (func $sti32 (param $$0 i32) (param $$1 i32)
    (block $fake_return_waka123
      (block
        (i32.store align=4
          (get_local $$0)
          (get_local $$1)
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $sti64 (param $$0 i32) (param $$1 i64)
    (block $fake_return_waka123
      (block
        (i64.store align=8
          (get_local $$0)
          (get_local $$1)
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $stf32 (param $$0 i32) (param $$1 f32)
    (block $fake_return_waka123
      (block
        (f32.store align=4
          (get_local $$0)
          (get_local $$1)
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $stf64 (param $$0 i32) (param $$1 f64)
    (block $fake_return_waka123
      (block
        (f64.store align=8
          (get_local $$0)
          (get_local $$1)
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $stoff (param $$0 i32) (param $$1 i32)
    (block $fake_return_waka123
      (block
        (i32.store align=4 offset=1
          (get_local $$0)
          (get_local $$1)
        )
        (br $fake_return_waka123)
      )
    )
  )
)
