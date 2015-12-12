(module
  (memory 0 4294967295)
  (func $fadd32 (param $$0 f32) (param $$1 f32) (result f32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f32.add
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $fsub32 (param $$0 f32) (param $$1 f32) (result f32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f32.sub
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $fmul32 (param $$0 f32) (param $$1 f32) (result f32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f32.mul
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $fdiv32 (param $$0 f32) (param $$1 f32) (result f32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f32.div
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $fabs32 (param $$0 f32) (result f32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f32.abs
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $fneg32 (param $$0 f32) (result f32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.neg
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $copysign32 (param $$0 f32) (param $$1 f32) (result f32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f32.copysign
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $sqrt32 (param $$0 f32) (result f32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f32.sqrt
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $ceil32 (param $$0 f32) (result f32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f32.ceil
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $floor32 (param $$0 f32) (result f32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f32.floor
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $trunc32 (param $$0 f32) (result f32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f32.trunc
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $nearest32 (param $$0 f32) (result f32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.nearest
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $nearest32_via_rint (param $$0 f32) (result f32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.nearest
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $fmin32 (param $$0 f32) (result f32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f32.min
            (f32.const 0)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $fmax32 (param $$0 f32) (result f32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f32.max
            (f32.const 0)
            (get_local $$0)
          )
        )
      )
    )
  )
)
