(module
  (memory 0)
  (func $f (param $i1 i32) (param $i2 i64)
    (if
      (i32.eqz
        (get_local $i1)
      )
      (i32.const 10)
    )
    (if
      (i32.eqz
        (get_local $i1)
      )
      (i32.const 11)
      (i32.const 12)
    )
    (if
      (i64.eqz
        (get_local $i2)
      )
      (i32.const 11)
      (i32.const 12)
    )
  )
)

