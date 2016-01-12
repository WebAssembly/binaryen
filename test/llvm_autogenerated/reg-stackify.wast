(module
  (memory 0 4294967295)
  (export "no0" $no0)
  (export "no1" $no1)
  (export "yes0" $yes0)
  (export "yes1" $yes1)
  (export "stack_uses" $stack_uses)
  (export "multiple_uses" $multiple_uses)
  (func $no0 (param $$0 i32) (param $$1 i32) (result i32)
    (block $fake_return_waka123
      (block
        (set_local $$1
          (i32.load align=4
            (get_local $$1)
          )
        )
        (i32.store align=4
          (get_local $$0)
          (i32.const 0)
        )
        (br $fake_return_waka123
          (get_local $$1)
        )
      )
    )
  )
  (func $no1 (param $$0 i32) (param $$1 i32) (result i32)
    (block $fake_return_waka123
      (block
        (set_local $$1
          (i32.load align=4
            (get_local $$1)
          )
        )
        (i32.store align=4
          (get_local $$0)
          (i32.const 0)
        )
        (br $fake_return_waka123
          (get_local $$1)
        )
      )
    )
  )
  (func $yes0 (param $$0 i32) (param $$1 i32) (result i32)
    (block $fake_return_waka123
      (block
        (i32.store align=4
          (get_local $$0)
          (i32.const 0)
        )
        (br $fake_return_waka123
          (i32.load align=4
            (get_local $$1)
          )
        )
      )
    )
  )
  (func $yes1 (param $$0 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.load align=4
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $stack_uses (param $$0 i32) (param $$1 i32) (param $$2 i32) (param $$3 i32) (result i32)
    (local $$4 i32)
    (local $$5 i32)
    (block $fake_return_waka123
      (block
        (set_local $$5
          (i32.const 2)
        )
        (set_local $$4
          (i32.const 1)
        )
        (block $label$0
          (br_if
            (i32.ne
              (i32.xor
                (i32.xor
                  (i32.lt_s
                    (get_local $$0)
                    (get_local $$4)
                  )
                  (i32.lt_s
                    (get_local $$1)
                    (get_local $$5)
                  )
                )
                (i32.xor
                  (i32.lt_s
                    (get_local $$2)
                    (get_local $$4)
                  )
                  (i32.lt_s
                    (get_local $$3)
                    (get_local $$5)
                  )
                )
              )
              (get_local $$4)
            )
            $label$0
          )
          (br $fake_return_waka123
            (i32.const 0)
          )
        )
        (br $fake_return_waka123
          (get_local $$4)
        )
      )
    )
  )
  (func $multiple_uses (param $$0 i32) (param $$1 i32) (param $$2 i32)
    (local $$3 i32)
    (block $fake_return_waka123
      (block
        (set_local $$3
          (i32.load align=4
            (get_local $$2)
          )
        )
        (block $label$0
          (br_if
            (i32.ge_u
              (get_local $$3)
              (get_local $$1)
            )
            $label$0
          )
          (br_if
            (i32.lt_u
              (get_local $$3)
              (get_local $$0)
            )
            $label$0
          )
          (i32.store align=4
            (get_local $$2)
            (get_local $$3)
          )
        )
        (br $fake_return_waka123)
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 0 }
