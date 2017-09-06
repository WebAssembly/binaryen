(module
  (export "x" (func $x))
  (func $x (param $x i32) (result i32)
    (if (i32.eq (get_local $x) (i32.const 98658746))
      (unreachable) ;; this can be removed destructively, since we do not sent this param
    )
    (i32.const 100)
  )
)

