(module
  (func $loop1
    (loop $loop
      (drop (i32.const 10))
      (br_if $loop (i32.const 1))
    )
  )
  (func $loop2
    (loop $loop
      (drop (i32.const 10))
      (drop (i32.const 20))
      (br_if $loop (i32.const 1))
    )
  )
  (func $loop3
    (loop $loop
      (drop (i32.const 10))
      (call $loop2)
      (drop (i32.const 20))
      (br_if $loop (i32.const 1))
    )
  )
  (func $loop4
    (loop $loop
      (drop (i32.load (i32.const 1)))
      (br_if $loop (i32.const 1))
    )
  )
  (func $loop5
    (loop $loop
      (i32.store (i32.const 1) (i32.const 2))
      (br_if $loop (i32.const 1))
    )
  )
  (func $loop6
    (loop $loop ;; even two stores work, when we look at them as a whole in their block (and no br in the block!)
      (i32.store (i32.const 1) (i32.const 2))
      (i32.store (i32.const 2) (i32.const 3))
    )
  )
  (func $loop7
    (loop $loop
      (i32.store (i32.const 1) (i32.const 2))
      (i32.store (i32.const 2) (i32.const 3))
      (br_if $loop (i32.const 1))
    )
  )
  (func $loop8
    (loop $loop
      (i32.store (i32.const 1) (i32.const 2)) ;; but one is ok
      (br_if $loop (i32.const 1))
    )
  )
  (func $loop9
    (loop $loop
      (drop (i32.load (i32.const 1)))
      (i32.store (i32.const 1) (i32.const 2)) ;; but one is ok
      (br_if $loop (i32.const 1))
    )
  )
  (func $loop10
    (loop $loop
      (drop (i32.load (i32.const 1)))
      (drop (i32.load (i32.const 2)))
      (br_if $loop (i32.const 1))
    )
  )
)

