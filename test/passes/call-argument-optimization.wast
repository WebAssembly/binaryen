(module
  (func $a (param $x i32)
  )
  (func $b
    (call $a (i32.const 1))
  )
  (func $a1 (param $x i32)
    (unreachable)
  )
  (func $b1
    (call $a1 (i32.const 2))
  )
  (func $b11
    (call $a1 (i32.const 2))
  )
  (func $a2 (param $x i32)
    (drop (get_local $x))
  )
  (func $b2
    (call $a2 (i32.const 3))
  )
  (func $b22
    (call $a2 (i32.const 4))
  )
)

