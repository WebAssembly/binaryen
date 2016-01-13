(module
  (memory 0 4294967295)
  (type $FUNCSIG$v (func))
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
        (block $label$0
          (br_if
            (i32.gt_u
              (get_local $$0)
              (i32.const 23)
            )
            $label$0
          )
          (block $label$1
            (block $label$2
              (block $label$3
                (block $label$4
                  (block $label$5
                    (block $label$6
                      (tableswitch 
                        (get_local $$0)
                        (table (br $label$6) (br $label$6) (br $label$6) (br $label$6) (br $label$6) (br $label$6) (br $label$6) (br $label$5) (br $label$5) (br $label$5) (br $label$5) (br $label$5) (br $label$5) (br $label$5) (br $label$5) (br $label$4) (br $label$4) (br $label$4) (br $label$4) (br $label$4) (br $label$4) (br $label$3) (br $label$2) (br $label$1)) (br $label$6)
                      )
                    )
                    (call_import $foo0)
                    (br $label$0)
                  )
                  (call_import $foo1)
                  (br $label$0)
                )
                (call_import $foo2)
                (br $label$0)
              )
              (call_import $foo3)
              (br $label$0)
            )
            (call_import $foo4)
            (br $label$0)
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
        (block $label$0
          (br_if
            (i64.gt_u
              (get_local $$0)
              (i64.const 23)
            )
            $label$0
          )
          (block $label$1
            (block $label$2
              (block $label$3
                (block $label$4
                  (block $label$5
                    (block $label$6
                      (tableswitch 
                        (i32.wrap/i64
                          (get_local $$0)
                        )
                        (table (br $label$6) (br $label$6) (br $label$6) (br $label$6) (br $label$6) (br $label$6) (br $label$6) (br $label$5) (br $label$5) (br $label$5) (br $label$5) (br $label$5) (br $label$5) (br $label$5) (br $label$5) (br $label$4) (br $label$4) (br $label$4) (br $label$4) (br $label$4) (br $label$4) (br $label$3) (br $label$2) (br $label$1)) (br $label$6)
                      )
                    )
                    (call_import $foo0)
                    (br $label$0)
                  )
                  (call_import $foo1)
                  (br $label$0)
                )
                (call_import $foo2)
                (br $label$0)
              )
              (call_import $foo3)
              (br $label$0)
            )
            (call_import $foo4)
            (br $label$0)
          )
          (call_import $foo5)
        )
        (br $fake_return_waka123)
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 0 }
