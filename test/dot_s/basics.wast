(module
  (memory 52 4294967295 (segment 16 "hello, world!\n\00") (segment 32 "vcq") (segment 48 "\16\00\00\00"))
  (import $puts "env" "puts" (param i32))
  (export "main" $main)
  (table $main)
  (func $main (param $$0 i32) (param $$1 i32) (result i32)
    (block $fake_return_waka123
      (block
        (call_import $puts
          (i32.const 16)
        )
        (block $.LBB0_5
          (block $.LBB0_4
            (br_if
              (i32.ne
                (i32.sub
                  (get_local $$0)
                  (i32.and
                    (i32.add
                      (get_local $$0)
                      (i32.shr_u
                        (i32.shr_s
                          (get_local $$0)
                          (i32.const 31)
                        )
                        (i32.const 30)
                      )
                    )
                    (i32.const -4)
                  )
                )
                (i32.const 1)
              )
              $.LBB0_4
            )
            (loop $.LBB0_1
              (block
                (set_local $$0
                  (i32.add
                    (i32.gt_s
                      (get_local $$0)
                      (i32.const 10)
                    )
                    (get_local $$0)
                  )
                )
                (block $.LBB0_3
                  (br_if
                    (i32.ne
                      (i32.rem_s
                        (get_local $$0)
                        (i32.const 5)
                      )
                      (i32.const 3)
                    )
                    $.LBB0_3
                  )
                  (set_local $$0
                    (i32.add
                      (i32.rem_s
                        (get_local $$0)
                        (i32.const 111)
                      )
                      (get_local $$0)
                    )
                  )
                )
                (br_if
                  (i32.eq
                    (i32.rem_s
                      (get_local $$0)
                      (i32.const 7)
                    )
                    (i32.const 0)
                  )
                  $.LBB0_5
                )
                (br $.LBB0_1)
              )
            )
          )
          (set_local $$0
            (i32.add
              (get_local $$0)
              (i32.const -12)
            )
          )
          (i32.const 0)
        )
        (br $fake_return_waka123
          (get_local $$0)
        )
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 51 }
