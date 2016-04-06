(module
  (memory 1)
  (export "memory" memory)
  (export "immediate_f32" $immediate_f32)
  (export "immediate_f64" $immediate_f64)
  (func $immediate_f32 (result f32)
    (return
      (f32.const 2.5)
    )
  )
  (func $immediate_f64 (result f64)
    (return
      (f64.const 2.5)
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 4, "initializers": [] }
