(module
  (func $a (param $x i32)
  )
  (func $b
    (call $a (i32.const 1))
  )
  (func $a1 (param $x i32)
  )
  (func $b1
    (call $a1 (i32.const 2))
  )
  (func $b2
    (call $a1 (i32.const 2))
  )
)

