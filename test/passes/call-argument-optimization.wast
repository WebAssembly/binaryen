(module
  (func $a (param $x i32)
  )
  (func $b
    (call $a (i32.const 1))
  )
)

