(module
  (memory 20 4294967295)
  (export "single_block" $single_block)
  (export "foo" $foo)
  (export "bar" $bar)
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
    (block $fake_return_waka123
      (block
        (set_local $$0
          (i32.const 0)
        )
        (loop $label$1 $label$0
          (i32.store offset=8 align=4
            (i32.const 0)
            (i32.const 0)
          )
          (set_local $$0
            (i32.add
              (get_local $$0)
              (i32.const 1)
            )
          )
          (br_if
            (i32.ne
              (get_local $$0)
              (i32.const 256)
            )
            $label$0
          )
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $bar
    (local $$0 f32)
    (block $fake_return_waka123
      (block
        (set_local $$0
          (f32.const 0)
        )
        (loop $label$1 $label$0
          (i32.store offset=8 align=4
            (i32.const 0)
            (i32.const 0)
          )
          (set_local $$0
            (f32.add
              (get_local $$0)
              (f32.const 1)
            )
          )
          (br_if
            (f32.ne
              (get_local $$0)
              (f32.const 256)
            )
            $label$0
          )
        )
        (br $fake_return_waka123)
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 19 }
