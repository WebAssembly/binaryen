(module
  (memory 0 4294967295)
  (export "z2s_func" $z2s_func)
  (export "s2z_func" $s2z_func)
  (export "z2s_call" $z2s_call)
  (export "s2z_call" $s2z_call)
  (func $z2s_func (param $$0 i32) (result i32)
    (local $$1 i32)
    (block $fake_return_waka123
      (block
        (set_local $$1
          (i32.const 24)
        )
        (br $fake_return_waka123
          (i32.shr_s
            (get_local $$1)
            (i32.shl
              (get_local $$1)
              (get_local $$0)
            )
          )
        )
      )
    )
  )
  (func $s2z_func (param $$0 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.and
            (i32.const 255)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $z2s_call (param $$0 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (call $z2s_func
            (i32.and
              (i32.const 255)
              (get_local $$0)
            )
          )
        )
      )
    )
  )
  (func $s2z_call (param $$0 i32) (result i32)
    (local $$1 i32)
    (block $fake_return_waka123
      (block
        (set_local $$1
          (i32.const 24)
        )
        (br $fake_return_waka123
          (i32.shr_s
            (get_local $$1)
            (i32.shl
              (get_local $$1)
              (call $s2z_func
                (i32.shr_s
                  (get_local $$1)
                  (i32.shl
                    (get_local $$1)
                    (get_local $$0)
                  )
                )
              )
            )
          )
        )
      )
    )
  )
)
