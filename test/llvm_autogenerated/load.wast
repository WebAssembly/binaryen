(module
  (memory 0)
  (export "ldi32" $ldi32)
  (export "ldi64" $ldi64)
  (export "ldf32" $ldf32)
  (export "ldf64" $ldf64)
  (func $ldi32 (param $$0 i32) (result i32)
    (return
      (i32.load align=4
        (get_local $$0)
      )
    )
  )
  (func $ldi64 (param $$0 i32) (result i64)
    (return
      (i64.load align=8
        (get_local $$0)
      )
    )
  )
  (func $ldf32 (param $$0 i32) (result f32)
    (return
      (f32.load align=4
        (get_local $$0)
      )
    )
  )
  (func $ldf64 (param $$0 i32) (result f64)
    (return
      (f64.load align=8
        (get_local $$0)
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 4 }
