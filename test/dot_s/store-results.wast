(module
  (memory 0 4294967295 (segment 2 "\00\00\00\00\00\00\00\00\00\00\00\00"))
  (func $single_block (param $$0 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.store align=4
            (get_local $$0)
            (i32.const 0)
          )
        )
      )
    )
  )
  (func $foo
    (local $$0 i32)
    (local $$1 i32)
    (block $fake_return_waka123
      (block
        (set_local $$0
          (i32.const 0)
        )
        (set_local $$1
          (get_local $$0)
        )
        (loop $BB1_2 $BB1_1
          (block
            (i32.store align=4
              (i32.const 0)
              (get_local $$0)
            )
            (set_local $$1
              (i32.add
                (i32.const 1)
                (get_local $$1)
              )
            )
            (br_if
              (i32.ne
                (i32.const 256)
                (get_local $$1)
              )
              $BB1_1
            )
          )
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $bar
    (local $$0 i32)
    (local $$1 f32)
    (block $fake_return_waka123
      (block
        (set_local $$0
          (i32.const 0)
        )
        (set_local $$1
          (f32.const 0)
        )
        (loop $BB2_2 $BB2_1
          (block
            (i32.store align=4
              (get_local $$0)
              (i32.const 0)
            )
            (set_local $$1
              (f32.add
                (f32.const 1)
                (get_local $$1)
              )
            )
            (br_if
              (f32.ne
                (f32.const 256)
                (get_local $$1)
              )
              $BB2_1
            )
          )
        )
        (br $fake_return_waka123)
      )
    )
  )
)
