(module
  (memory 0 4294967295)
  (export "trunc_i8_i32" $trunc_i8_i32)
  (export "trunc_i16_i32" $trunc_i16_i32)
  (export "trunc_i8_i64" $trunc_i8_i64)
  (export "trunc_i16_i64" $trunc_i16_i64)
  (export "trunc_i32_i64" $trunc_i32_i64)
  (export "trunc_i8_i32_off" $trunc_i8_i32_off)
  (func $trunc_i8_i32 (param $$0 i32) (param $$1 i32)
    (block $fake_return_waka123
      (block
        (i32.store align=8
          (get_local $$0)
          (get_local $$1)
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $trunc_i16_i32 (param $$0 i32) (param $$1 i32)
    (block $fake_return_waka123
      (block
        (i32.store align=16
          (get_local $$0)
          (get_local $$1)
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $trunc_i8_i64 (param $$0 i32) (param $$1 i64)
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
  (func $trunc_i16_i64 (param $$0 i32) (param $$1 i64)
    (block $fake_return_waka123
      (block
        (i64.store align=16
          (get_local $$0)
          (get_local $$1)
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $trunc_i32_i64 (param $$0 i32) (param $$1 i64)
    (block $fake_return_waka123
      (block
        (i64.store align=32
          (get_local $$0)
          (get_local $$1)
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $trunc_i8_i32_off (param $$0 i32) (param $$1 i32)
    (block $fake_return_waka123
      (block
        (i32.store align=8 offset=1234
          (get_local $$0)
          (get_local $$1)
        )
        (br $fake_return_waka123)
      )
    )
  )
)
; METADATA: { "asmConsts": {} }