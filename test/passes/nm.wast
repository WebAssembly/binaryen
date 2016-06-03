(module
  (func $a
    (nop)
  )
  (func $b
    (loop
      (nop)
      (i32.const 1000)
    )
  )
  (func $c
    (block $top
      (nop)
      (i32.const 1000)
      (i32.add
        (i32.add
          (i32.const 1001)
          (i32.const 1002)
        )
        (i32.add
          (i32.const 1003)
          (i32.const 1004)
        )
      )
      (br $top)
    )
  )
)

