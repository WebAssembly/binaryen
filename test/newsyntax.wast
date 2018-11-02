(module
  (import "env" "table" (table 9 9 anyfunc))
  (func "call_indirect"
    (drop
      (call_indirect (param i32) (param f64) (result i32) (i32.const 10) (f64.const 20) (i32.const 30))
    )
    (call_indirect (i32.const 1))
  )
)

