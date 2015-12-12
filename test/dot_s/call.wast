(module
  (memory 0 4294967295)
  (func $call_i32_nullary (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (call $i32_nullary)
        )
      )
    )
  )
  (func $call_i64_nullary (result i64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (call $i64_nullary)
        )
      )
    )
  )
  (func $call_float_nullary (result f32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (call $float_nullary)
        )
      )
    )
  )
  (func $call_double_nullary (result f64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (call $double_nullary)
        )
      )
    )
  )
  (func $call_void_nullary
    (block $fake_return_waka123
      (block
        (call $void_nullary)
        (br $fake_return_waka123)
      )
    )
  )
  (func $call_i32_unary (param $$0 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (call $i32_unary
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $call_i32_binary (param $$0 i32) (param $$1 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (call $i32_binary
            (get_local $$1)
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $call_indirect_void (param $$0 i32)
    (block $fake_return_waka123
      (block
        (call_import $$0)
        (br $fake_return_waka123)
      )
    )
  )
  (func $call_indirect_i32 (param $$0 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (call_import $$0)
        )
      )
    )
  )
  (func $tail_call_void_nullary
    (block $fake_return_waka123
      (block
        (call $void_nullary)
        (br $fake_return_waka123)
      )
    )
  )
  (func $fastcc_tail_call_void_nullary
    (block $fake_return_waka123
      (block
        (call $void_nullary)
        (br $fake_return_waka123)
      )
    )
  )
  (func $coldcc_tail_call_void_nullary
    (block $fake_return_waka123
      (block
        (call $void_nullary)
        (br $fake_return_waka123)
      )
    )
  )
)
