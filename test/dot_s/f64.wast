(module
  (memory 0 4294967295)
  (func $fadd64 (param $$0 f64) (param $$1 f64) (result f64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f64.add
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $fsub64 (param $$0 f64) (param $$1 f64) (result f64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f64.sub
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $fmul64 (param $$0 f64) (param $$1 f64) (result f64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f64.mul
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $fdiv64 (param $$0 f64) (param $$1 f64) (result f64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f64.div
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $fabs64 (param $$0 f64) (result f64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f64.abs
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $fneg64 (param $$0 f64) (result f64)
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
  (func $copysign64 (param $$0 f64) (param $$1 f64) (result f64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f64.copysign
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $sqrt64 (param $$0 f64) (result f64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f64.sqrt
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $ceil64 (param $$0 f64) (result f64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f64.ceil
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $floor64 (param $$0 f64) (result f64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f64.floor
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $trunc64 (param $$0 f64) (result f64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f64.trunc
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $nearest64 (param $$0 f64) (result f64)
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
  (func $nearest64_via_rint (param $$0 f64) (result f64)
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
  (func $fmin64 (param $$0 f64) (result f64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f64.min
            (f64.const 0)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $fmax64 (param $$0 f64) (result f64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f64.max
            (f64.const 0)
            (get_local $$0)
          )
        )
      )
    )
  )
)
