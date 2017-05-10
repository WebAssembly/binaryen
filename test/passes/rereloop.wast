(module
  (func $trivial
    (nop)
  )
  (func $trivial2
    (call $trivial)
    (call $trivial)
  )
  (func $return-void
    (return)
  )
  (func $return-val (result i32)
    (return (i32.const 1))
  )
  (func $ifs (param $x i32) (result i32)
    (if
      (get_local $x)
      (return (i32.const 2))
      (return (i32.const 3))
    )
    (if
      (get_local $x)
      (return (i32.const 4))
    )
    (return (i32.const 5))
  )
)

