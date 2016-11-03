(module
  (import "env" "memory" (memory $0 1))
  (table 0 anyfunc)
  (data (i32.const 4) "\10\04\00\00")
  (export "ldi32" (func $ldi32))
  (export "ldi64" (func $ldi64))
  (export "ldf32" (func $ldf32))
  (export "ldf64" (func $ldf64))
  (func $ldi32 (param $0 i32) (result i32)
    (return
      (i32.load
        (get_local $0)
      )
    )
  )
  (func $ldi64 (param $0 i32) (result i64)
    (return
      (i64.load
        (get_local $0)
      )
    )
  )
  (func $ldf32 (param $0 i32) (result f32)
    (return
      (f32.load
        (get_local $0)
      )
    )
  )
  (func $ldf64 (param $0 i32) (result f64)
    (return
      (f64.load
        (get_local $0)
      )
    )
  )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [] }
