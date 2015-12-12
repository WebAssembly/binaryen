(module
  (memory 0 4294967295)
  (func $load_u_i1_i32 (param $$0 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.load align=8
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $load_s_i1_i32 (param $$0 i32) (result i32)
    (local $$1 i32)
    (block $fake_return_waka123
      (block
        (set_local $$1
          (i32.const 31)
        )
        (br $fake_return_waka123
          (i32.shr_s
            (get_local $$1)
            (i32.shl
              (get_local $$1)
              (i32.load align=8
                (get_local $$0)
              )
            )
          )
        )
      )
    )
  )
  (func $load_u_i1_i64 (param $$0 i32) (result i64)
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
  (func $load_s_i1_i64 (param $$0 i32) (result i64)
    (local $$1 i64)
    (block $fake_return_waka123
      (block
        (set_local $$1
          (i64.const 63)
        )
        (br $fake_return_waka123
          (i64.shr_s
            (get_local $$1)
            (i64.shl
              (get_local $$1)
              (i64.load align=8
                (get_local $$0)
              )
            )
          )
        )
      )
    )
  )
  (func $store_i32_i1 (param $$0 i32) (param $$1 i32)
    (block $fake_return_waka123
      (block
        (i32.store align=8
          (get_local $$0)
          (i32.and
            (i32.const 1)
            (get_local $$1)
          )
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $store_i64_i1 (param $$0 i32) (param $$1 i64)
    (block $fake_return_waka123
      (block
        (i64.store align=8
          (get_local $$0)
          (i64.and
            (i64.const 1)
            (get_local $$1)
          )
        )
        (br $fake_return_waka123)
      )
    )
  )
)
