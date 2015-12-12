(module
  (memory 0 4294967295)
  (func $f (param $$0 i32) (param $$1 f32) (param $$2 i64) (param $$3 i64) (param $$4 i32)
    (block $fake_return_waka123
      (block
        (call $printi
          (get_local $$0)
        )
        (call $printf
          (get_local $$1)
        )
        (call $printv)
        (call $split_arg
          (get_local $$3)
          (get_local $$2)
        )
        (call $expanded_arg
          (get_local $$4)
        )
        (call $lowered_result)
        (br $fake_return_waka123)
      )
    )
  )
)
