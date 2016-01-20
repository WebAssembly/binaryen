(module
  (memory 16777216 16777216)
  (export "add" $add)
  (func $add (param $x i32) (param $y i32) (result i32)
    (set_local $x
      (i32.const 1)
    )
    (set_local $y
      (i32.const 2)
    )
    (if_else
      (i32.const 0)
      (set_local $y
        (i32.const 3)
      )
      (get_local $y)
    )
    (i32.add
      (get_local $x)
      (get_local $y)
    )
    (set_local $x
      (i32.const 3)
    )

    (if
      (get_local $x)
      (block $b0
        (get_local $x)
        (set_local $x
          (i32.const 4)
        )
        (get_local $x)
      )
    )
    (get_local $x)

    (if
      (set_local $x
        (i32.const 5)
      )
      (get_local $x)
    )
    (get_local $x)
  )
)