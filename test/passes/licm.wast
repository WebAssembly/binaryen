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
)

