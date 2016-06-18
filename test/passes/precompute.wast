(module
  (func $x (param $x i32)
    (i32.add (i32.const 1) (i32.const 2)) ;; precomputable
    (i32.add (i32.const 1) (get_local $x))
    (i32.add (i32.const 1) (i32.add (i32.const 2) (i32.const 3))) ;; cascade
    (i32.sub (i32.const 1) (i32.const 2))
    (i32.sub
      (i32.add
        (i32.const 0)
        (i32.const 4)
      )
      (i32.const 1)
    )
    (loop $in ;; infinite loop
      (br $in)
    )
  )
)

