(module
  (memory 256 256)
  (func $ifs (param $x i32)
    (local $y f32)
    (block
      (if
        (i32.const 0)
        (i32.const 1)
      )
      (if_else
        (i32.const 0)
        (i32.const 1)
        (i32.const 2)
      )
      (if_else
        (i32.const 4)
        (i32.const 5)
        (i32.const 6)
      )
      (i32.eq
        (if_else
          (i32.const 4)
          (i32.const 5)
          (i32.const 6)
        )
        (i32.const 177)
      )
    )
  )
)
