(module
  (memory 0 4294967295)
  (func $0 (param $$0 i32) (param $$1 i32) (result i32)
    (block $fake_return_waka123
      (block
        (call $puts
          (none.const ?)
        )
        (block $BB0_5
          (block $BB0_4
            (br_if
              (i32.ne
                (i32.sub
                  (i32.and
                    (i32.add
                      (i32.shr_u
                        (i32.shr_s
                          (i32.const 31)
                          (get_local $$0)
                        )
                        (i32.const 30)
                      )
                      (get_local $$0)
                    )
                    (i32.const -4)
                  )
                  (get_local $$0)
                )
                (i32.const 1)
              )
              $BB0_4
            )
            (set_local $$0
              (i32.add
                (i32.const -12)
                (get_local $$0)
              )
            )
          )
          (br $fake_return_waka123
            (get_local $$0)
          )
        )
      )
    )
  )
)
