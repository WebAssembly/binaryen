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
  )
)

