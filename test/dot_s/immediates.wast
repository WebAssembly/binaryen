(module
  (memory 0 4294967295)
  (export "zero_i32" $zero_i32)
  (export "one_i32" $one_i32)
  (export "max_i32" $max_i32)
  (export "min_i32" $min_i32)
  (export "zero_i64" $zero_i64)
  (export "one_i64" $one_i64)
  (export "max_i64" $max_i64)
  (export "min_i64" $min_i64)
  (export "negzero_f32" $negzero_f32)
  (export "zero_f32" $zero_f32)
  (export "one_f32" $one_f32)
  (export "two_f32" $two_f32)
  (export "nan_f32" $nan_f32)
  (export "negnan_f32" $negnan_f32)
  (export "inf_f32" $inf_f32)
  (export "neginf_f32" $neginf_f32)
  (export "negzero_f64" $negzero_f64)
  (export "zero_f64" $zero_f64)
  (export "one_f64" $one_f64)
  (export "two_f64" $two_f64)
  (export "nan_f64" $nan_f64)
  (export "negnan_f64" $negnan_f64)
  (export "inf_f64" $inf_f64)
  (export "neginf_f64" $neginf_f64)
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
