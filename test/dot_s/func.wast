(module
  (memory 0 4294967295)
  (export "f0" $f0)
  (export "f1" $f1)
  (export "f2" $f2)
  (export "f3" $f3)
  (export "f4" $f4)
  (export "f5" $f5)
  (func $f0
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123)
      )
    )
  )
  (func $f1 (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.const 0)
        )
      )
    )
  )
  (func $f2 (param $$0 i32) (param $$1 f32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.const 0)
        )
      )
    )
  )
  (func $f3 (param $$0 i32) (param $$1 f32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123)
      )
    )
  )
  (func $f4 (param $$0 i32) (result i32)
    (local $$1 i32)
    (block $fake_return_waka123
      (block
        (set_local $$1
          (i32.const 1)
        )
        (block $BB4_2
          (br_if
            (i32.eq
              (i32.and
                (get_local $$0)
                (get_local $$1)
              )
              (i32.const 0)
            )
            $BB4_2
          )
          (br $fake_return_waka123
            (i32.const 0)
          )
        )
        (br $fake_return_waka123
          (get_local $$1)
        )
      )
    )
  )
  (func $f5 (result f32)
    (block
      (unreachable)
    )
  )
)
;; METADATA: { "asmConsts": {} }