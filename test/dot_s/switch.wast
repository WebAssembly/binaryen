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
        (block $BB0_8
          (br_if
            (i32.gt_u
              (get_local $$0)
              (i32.const 23)
            )
            $BB0_8
          )
          (block $BB0_7
            (block $BB0_6
              (block $BB0_5
                (block $BB0_4
                  (block $BB0_3
                    (block $BB0_2
                      (tableswitch 
                        (get_local $$0)
                        (table (case $BB0_2) (case $BB0_2) (case $BB0_2) (case $BB0_2) (case $BB0_2) (case $BB0_2) (case $BB0_2) (case $BB0_3) (case $BB0_3) (case $BB0_3) (case $BB0_3) (case $BB0_3) (case $BB0_3) (case $BB0_3) (case $BB0_3) (case $BB0_4) (case $BB0_4) (case $BB0_4) (case $BB0_4) (case $BB0_4) (case $BB0_4) (case $BB0_5) (case $BB0_6) (case $BB0_7)) (case $BB0_2)
                      )
                    )
                    (call_import $foo0)
                    (br $BB0_8)
                  )
                  (call_import $foo1)
                  (br $BB0_8)
                )
                (call_import $foo2)
                (br $BB0_8)
              )
              (call_import $foo3)
              (br $BB0_8)
            )
            (call_import $foo4)
            (br $BB0_8)
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
        (block $BB1_8
          (br_if
            (i64.gt_u
              (get_local $$0)
              (i64.const 23)
            )
            $BB1_8
          )
          (block $BB1_7
            (block $BB1_6
              (block $BB1_5
                (block $BB1_4
                  (block $BB1_3
                    (block $BB1_2
                      (tableswitch 
                        (i32.wrap/i64
                          (get_local $$0)
                        )
                        (table (case $BB1_2) (case $BB1_2) (case $BB1_2) (case $BB1_2) (case $BB1_2) (case $BB1_2) (case $BB1_2) (case $BB1_3) (case $BB1_3) (case $BB1_3) (case $BB1_3) (case $BB1_3) (case $BB1_3) (case $BB1_3) (case $BB1_3) (case $BB1_4) (case $BB1_4) (case $BB1_4) (case $BB1_4) (case $BB1_4) (case $BB1_4) (case $BB1_5) (case $BB1_6) (case $BB1_7)) (case $BB1_2)
                      )
                    )
                    (call_import $foo0)
                    (br $BB1_8)
                  )
                  (call_import $foo1)
                  (br $BB1_8)
                )
                (call_import $foo2)
                (br $BB1_8)
              )
              (call_import $foo3)
              (br $BB1_8)
            )
            (call_import $foo4)
            (br $BB1_8)
          )
          (call_import $foo5)
        )
        (br $fake_return_waka123)
      )
    )
  )
)
;; METADATA: { "asmConsts": {} }