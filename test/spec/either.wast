(module
  (func $a (export "a") (result i32)
    (i32.const 1)
  )
)

(assert_return (invoke "a") (either (i32.const 0) (i32.const 1)))
