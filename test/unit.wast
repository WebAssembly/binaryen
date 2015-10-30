(module
  (memory 16777216)
  (export "big_negative" $big_negative)
  (table $z $big_negative $importedDoubles $z)
  (func $big_negative
    (local $temp f64)
    (block
      (set_local $temp
        (f64.convert_s/i32
          (i32.const -2147483648)
        )
      )
      (set_local $temp
        (f64.const -2147483648)
      )
      (set_local $temp
        (f64.const -21474836480)
      )
      (set_local $temp
        (f64.const 0.039625)
      )
      (set_local $temp
        (f64.const -0.039625)
      )
    )
  )
  (func $importedDoubles
    (local $temp f64)
    (set_local $temp
      (f64.add
        (f64.add
          (f64.add
            (f64.load align=8
              (i32.const 8)
            )
            (f64.load align=8
              (i32.const 16)
            )
          )
          (f64.neg
            (f64.load align=8
              (i32.const 16)
            )
          )
        )
        (f64.neg
          (f64.load align=8
            (i32.const 8)
          )
        )
      )
    )
  )
  (func $doubleCompares (param $x f64) (param $y f64) (result f64)
    (block $topmost
      (if
        (f64.lt
          (get_local $x)
          (get_local $y)
        )
        (break $topmost
          (get_local $x)
        )
      )
      (break $topmost
        (get_local $y)
      )
    )
  )
  (func $z
    (nop)
  )
  (func $w
    (nop)
  )
)
