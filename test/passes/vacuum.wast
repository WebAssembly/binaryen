(module
  (memory 256 256)
  (func $b
    (i32.const 50)
    (nop)
    (i32.const 51)
    (nop)
    (nop)
    (i32.const 52)
    (block $waka1
      (i32.const 53)
      (br $waka1)
      (i32.const 54)
    )
    (block $waka2
      (nop)
      (br $waka2)
      (i32.const 56)
    )
    (block $waka3
      (br_table $waka3 $waka3 $waka3
        (i32.const 57)
      )
      (i32.const 58)
    )
    (if
      (i32.const 100)
      (nop)
      (i32.const 101)
    )
    (if
      (i32.const 102)
      (i32.const 103)
      (nop)
    )
    (if
      (i32.const 104)
      (nop)
      (nop)
    )
  )
)

