(module
  (memory 0 4294967295)
  (func $zero_i32 (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.const 0)
        )
      )
    )
  )
  (func $one_i32 (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.const 1)
        )
      )
    )
  )
  (func $max_i32 (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.const 2147483647)
        )
      )
    )
  )
  (func $min_i32 (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i32.const -2147483648)
        )
      )
    )
  )
  (func $zero_i64 (result i64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.const 0)
        )
      )
    )
  )
  (func $one_i64 (result i64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.const 1)
        )
      )
    )
  )
  (func $max_i64 (result i64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.const 9223372036854775807)
        )
      )
    )
  )
  (func $min_i64 (result i64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (i64.const -9223372036854775808)
        )
      )
    )
  )
  (func $negzero_f32 (result f32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f32.const -0)
        )
      )
    )
  )
  (func $zero_f32 (result f32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f32.const 0)
        )
      )
    )
  )
  (func $one_f32 (result f32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f32.const 1)
        )
      )
    )
  )
  (func $two_f32 (result f32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f32.const 2)
        )
      )
    )
  )
  (func $nan_f32 (result f32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f32.const nan:7fc00000)
        )
      )
    )
  )
  (func $negnan_f32 (result f32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f32.const nan:ffc00000)
        )
      )
    )
  )
  (func $inf_f32 (result f32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f32.const inf)
        )
      )
    )
  )
  (func $neginf_f32 (result f32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f32.const -inf)
        )
      )
    )
  )
  (func $negzero_f64 (result f64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f64.const -0)
        )
      )
    )
  )
  (func $zero_f64 (result f64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f64.const 0)
        )
      )
    )
  )
  (func $one_f64 (result f64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f64.const 1)
        )
      )
    )
  )
  (func $two_f64 (result f64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f64.const 2)
        )
      )
    )
  )
  (func $nan_f64 (result f64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f64.const nan:7ff8000000000000)
        )
      )
    )
  )
  (func $negnan_f64 (result f64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f64.const nan:fff8000000000000)
        )
      )
    )
  )
  (func $inf_f64 (result f64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f64.const inf)
        )
      )
    )
  )
  (func $neginf_f64 (result f64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f64.const -inf)
        )
      )
    )
  )
)
