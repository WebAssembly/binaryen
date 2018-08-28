(module
  (func $loop1
    (loop $loop
      (drop (i32.const 10))
    )
  )
  (func $loop2
    (loop $loop
      (drop (i32.const 10))
      (drop (i32.const 20))
    )
  )
  (func $loop3
    (loop $loop
      (drop (i32.const 10))
      (call $loop2)
      (drop (i32.const 20))
    )
  )
  (func $loop4
    (loop $loop
      (drop (i32.load (i32.const 1)))
    )
  )
)

