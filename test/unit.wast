(module
  (memory 16777216)
  (export "big_negative" $big_negative)
  (func $big_negative
    (local $temp f64)
    (block
      (set_local $temp
        (i32.const -2147483648)
      )
      (set_local $temp
        (f64.const -2147483648)
      )
      (set_local $temp
        (f64.const -21474836480)
      )
    )
  )
)

