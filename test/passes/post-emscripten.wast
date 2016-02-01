(module
  (memory 16777216 16777216)
  (func $b0 (param $x i32)
    (i32.load
      (i32.add
        (get_local $x)
        (i32.const 1)
      )
    )
    (i32.load
      (i32.add
        (get_local $x)
        (i32.const 8)
      )
    )
    (i32.load
      (i32.add
        (get_local $x)
        (i32.const 1023)
      )
    )
    (i32.load
      (i32.add
        (get_local $x)
        (i32.const 1024)
      )
    )
    (i32.load
      (i32.add
        (get_local $x)
        (i32.const 2048)
      )
    )
    (i32.load
      (i32.add
        (i32.const 4)
        (get_local $x)
      )
    )
  )
)

