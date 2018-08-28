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
  (func $loop5
    (loop $loop
      (i32.store (i32.const 1) (i32.const 2))
    )
  )
  (func $loop6
    (loop $loop ;; even two stores work, when we look at them as a whole in their block
      (i32.store (i32.const 1) (i32.const 2))
      (i32.store (i32.const 2) (i32.const 3))
    )
  )
)

