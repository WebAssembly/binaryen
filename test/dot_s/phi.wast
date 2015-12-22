(module
  (memory 0 4294967295)
  (export "test0" $test0)
  (export "test1" $test1)
  (func $test0 (param $$0 i32) (result i32)
    (block $fake_return_waka123
      (block
        (block $BB0_2
          (br_if
            (i32.gt_s
              (get_local $$0)
              (i32.const -1)
            )
            $BB0_2
          )
          (set_local $$0
            (i32.div_s
              (get_local $$0)
              (i32.const 3)
            )
          )
        )
        (br $fake_return_waka123
          (get_local $$0)
        )
      )
    )
  )
  (func $test1 (param $$0 i32) (result i32)
    (local $$1 i32)
    (local $$2 i32)
    (local $$3 i32)
    (local $$4 i32)
    (local $$5 i32)
    (block $fake_return_waka123
      (block
        (set_local $$2
          (i32.const 1)
        )
        (set_local $$3
          (i32.const 0)
        )
        (set_local $$4
          (get_local $$2)
        )
        (set_local $$5
          (get_local $$3)
        )
        (loop $BB1_2 $BB1_1
          (block
            (set_local $$5
              (i32.add
                (get_local $$5)
                (get_local $$2)
              )
            )
            (set_local $$1
              (get_local $$4)
            )
            (set_local $$4
              (get_local $$3)
            )
            (set_local $$3
              (get_local $$1)
            )
            (br_if
              (i32.lt_s
                (get_local $$5)
                (get_local $$0)
              )
              $BB1_1
            )
          )
        )
        (br $fake_return_waka123
          (get_local $$4)
        )
      )
    )
  )
)
;; METADATA: { "asmConsts": {} }
