(module
  (memory 0 4294967295)
  (type $FUNCSIG_v (func))
  (type $FUNCSIG_i (func))
  (import $i32_nullary "env" "i32_nullary")
  (import $i64_nullary "env" "i64_nullary")
  (import $float_nullary "env" "float_nullary")
  (import $double_nullary "env" "double_nullary")
  (import $void_nullary "env" "void_nullary")
  (import $i32_unary "env" "i32_unary")
  (import $i32_binary "env" "i32_binary")
  (export "call_i32_nullary" $call_i32_nullary)
  (export "call_i64_nullary" $call_i64_nullary)
  (export "call_float_nullary" $call_float_nullary)
  (export "call_double_nullary" $call_double_nullary)
  (export "call_void_nullary" $call_void_nullary)
  (export "call_i32_unary" $call_i32_unary)
  (export "call_i32_binary" $call_i32_binary)
  (export "call_indirect_void" $call_indirect_void)
  (export "call_indirect_i32" $call_indirect_i32)
  (export "tail_call_void_nullary" $tail_call_void_nullary)
  (export "fastcc_tail_call_void_nullary" $fastcc_tail_call_void_nullary)
  (export "coldcc_tail_call_void_nullary" $coldcc_tail_call_void_nullary)
  (func $call_i32_nullary (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (call_import $i32_nullary)
        )
      )
    )
  )
  (func $call_i64_nullary (result i64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (call_import $i64_nullary)
        )
      )
    )
  )
  (func $call_float_nullary (result f32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (call_import $float_nullary)
        )
      )
    )
  )
  (func $call_double_nullary (result f64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (call_import $double_nullary)
        )
      )
    )
  )
  (func $call_void_nullary
    (block $fake_return_waka123
      (block
        (call_import $void_nullary)
        (br $fake_return_waka123)
      )
    )
  )
  (func $call_i32_unary (param $$0 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (call_import $i32_unary
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
          (call_import $i32_binary
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
        (call_indirect $FUNCSIG_v
          (get_local $$0)
        )
        (br $fake_return_waka123)
      )
    )
  )
  (func $call_indirect_i32 (param $$0 i32) (result i32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (call_indirect $FUNCSIG_i
            (get_local $$0)
          )
        )
      )
    )
  )
  (func $tail_call_void_nullary
    (block $fake_return_waka123
      (block
        (call_import $void_nullary)
        (br $fake_return_waka123)
      )
    )
  )
  (func $fastcc_tail_call_void_nullary
    (block $fake_return_waka123
      (block
        (call_import $void_nullary)
        (br $fake_return_waka123)
      )
    )
  )
  (func $coldcc_tail_call_void_nullary
    (block $fake_return_waka123
      (block
        (call_import $void_nullary)
        (br $fake_return_waka123)
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 0 }
