(module
  (memory 16777216 16777216)
  (func $ifs
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
    )
  )
)
