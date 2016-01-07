(module
  (memory 0 4294967295)
  (import $foo0 "env" "foo0")
  (import $foo1 "env" "foo1")
  (import $foo2 "env" "foo2")
  (import $foo3 "env" "foo3")
  (import $foo4 "env" "foo4")
  (import $foo5 "env" "foo5")
  (export "bar32" $bar32)
  (export "bar64" $bar64)
  (func $bar32 (param $$0 i32)
    (block $fake_return_waka123
      (block
        (block $.LBB0_8
          (br_if
            (i32.gt_u
              (get_local $$0)
              (i32.const 23)
            )
            $.LBB0_8
          )
          (block $.LBB0_7
            (block $.LBB0_6
              (block $.LBB0_5
                (block $.LBB0_4
                  (block $.LBB0_3
                    (block $.LBB0_2
                      (tableswitch 
                        (get_local $$0)
                        (table (br $.LBB0_2) (br $.LBB0_2) (br $.LBB0_2) (br $.LBB0_2) (br $.LBB0_2) (br $.LBB0_2) (br $.LBB0_2) (br $.LBB0_3) (br $.LBB0_3) (br $.LBB0_3) (br $.LBB0_3) (br $.LBB0_3) (br $.LBB0_3) (br $.LBB0_3) (br $.LBB0_3) (br $.LBB0_4) (br $.LBB0_4) (br $.LBB0_4) (br $.LBB0_4) (br $.LBB0_4) (br $.LBB0_4) (br $.LBB0_5) (br $.LBB0_6) (br $.LBB0_7)) (case $.LBB0_2)
                      )
                    )
                    (call_import $foo0)
                    (br $.LBB0_8)
                  )
                  (call_import $foo1)
                  (br $.LBB0_8)
                )
                (call_import $foo2)
                (br $.LBB0_8)
              )
              (call_import $foo3)
              (br $.LBB0_8)
            )
            (call_import $foo4)
            (br $.LBB0_8)
          )
          (call_import $foo5)
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $bar64 (param $$0 i64)
    (block $fake_return_waka123
      (block
        (block $.LBB1_8
          (br_if
            (i64.gt_u
              (get_local $$0)
              (i64.const 23)
            )
            $.LBB1_8
          )
          (block $.LBB1_7
            (block $.LBB1_6
              (block $.LBB1_5
                (block $.LBB1_4
                  (block $.LBB1_3
                    (block $.LBB1_2
                      (tableswitch 
                        (i32.wrap/i64
                          (get_local $$0)
                        )
                        (table (br $.LBB1_2) (br $.LBB1_2) (br $.LBB1_2) (br $.LBB1_2) (br $.LBB1_2) (br $.LBB1_2) (br $.LBB1_2) (br $.LBB1_3) (br $.LBB1_3) (br $.LBB1_3) (br $.LBB1_3) (br $.LBB1_3) (br $.LBB1_3) (br $.LBB1_3) (br $.LBB1_3) (br $.LBB1_4) (br $.LBB1_4) (br $.LBB1_4) (br $.LBB1_4) (br $.LBB1_4) (br $.LBB1_4) (br $.LBB1_5) (br $.LBB1_6) (br $.LBB1_7)) (case $.LBB1_2)
                      )
                    )
                    (call_import $foo0)
                    (br $.LBB1_8)
                  )
                  (call_import $foo1)
                  (br $.LBB1_8)
                )
                (call_import $foo2)
                (br $.LBB1_8)
              )
              (call_import $foo3)
              (br $.LBB1_8)
            )
            (call_import $foo4)
            (br $.LBB1_8)
          )
          (call_import $foo5)
        )
        (br $fake_return_waka123)
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 0 }
