(module
  (memory 0 4294967295)
  (export "shl_i3" $shl_i3)
  (export "shl_i53" $shl_i53)
  (export "sext_in_reg_i32_i64" $sext_in_reg_i32_i64)
  (export "fpext_f32_f64" $fpext_f32_f64)
  (export "fpconv_f64_f32" $fpconv_f64_f32)
  (func $shl_i3 (param $$0 i32) (param $$1 i32) (param $$2 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.shl
            (get_local $$0)
            (i32.and
              (get_local $$1)
              (i32.const 7)
            )
          )
        )
      )
    )
  )
  (func $shl_i53 (param $$0 i64) (param $$1 i64) (param $$2 i32) (result i64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.shl
            (get_local $$0)
            (i64.and
              (get_local $$1)
              (i64.const 9007199254740991)
            )
          )
        )
      )
    )
  )
  (func $sext_in_reg_i32_i64 (param $$0 i64) (result i64)
    (local $$1 i64)
    (block $fake_return_waka123
      (block
        (set_local $$1
          (i64.const 32)
        )
        (br $fake_return_waka123
          (i64.shr_s
            (i64.shl
              (get_local $$0)
              (get_local $$1)
            )
            (get_local $$1)
          )
        )
      )
    )
  )
  (func $fpext_f32_f64 (param $$0 i32) (result f64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f64.promote/f32
            (f32.load align=4
              (get_local $$0)
            )
          )
        )
      )
    )
  )
  (func $fpconv_f64_f32 (param $$0 i32) (result f32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f32.demote/f64
            (f64.load align=8
              (get_local $$0)
            )
          )
        )
      )
    )
  )
)
;; METADATA: { "asmConsts": {} }