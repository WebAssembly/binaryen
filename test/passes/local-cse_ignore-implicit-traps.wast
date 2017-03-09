(module
  (memory 100 100)
  (func $loads
    (drop
      (i32.load (i32.const 10))
    )
    (drop
      (i32.load (i32.const 10))
    )
    (drop
      (i32.load offset=5 (i32.const 10))
    )
    (drop
      (i32.load (i32.const 11))
    )
    (drop
      (i32.load (i32.const 10))
    )
  )
)
