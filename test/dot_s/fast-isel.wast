(module
  (memory 0 4294967295)
  (export "immediate_f32" $immediate_f32)
  (export "immediate_f64" $immediate_f64)
  (func $immediate_f32 (result f32)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f32.const 2.5)
        )
      )
    )
  )
  (func $immediate_f64 (result f64)
    (block $fake_return_waka123
      (block
        (br $fake_return_waka123
          (f64.const 2.5)
        )
      )
    )
  )
)
