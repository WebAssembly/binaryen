(module
  (func $basic (param $x i32) (param $y f64)
    (local $a f32)
    (local $b i64)
    (set_local $x (i32.const 0))
    (set_local $y (f64.const 0))
    (set_local $a (f32.const 0))
    (set_local $b (i64.const 0))
  )
  (func $later-param-use (param $x i32)
    (set_local $x (i32.const 0))
    (set_local $x (i32.const 0))
  )
  (func $diff-value (param $x i32)
    (local $a i32)
    (set_local $x (i32.const 0))
    (set_local $x (i32.const 1))
    (set_local $x (i32.const 1))
    (set_local $a (i32.const 1))
    (set_local $a (i32.const 1))
    (set_local $a (i32.const 0))
  )
  (func $unreach
    (local $a i32)
    (block $x
      (set_local $a (i32.const 0))
      (set_local $a (i32.const 1))
      (set_local $a (i32.const 1))
      (br $x)
      (set_local $a (i32.const 1)) ;; ignore all these
      (set_local $a (i32.const 2))
      (set_local $a (i32.const 2))
    )
  )
  (func $loop
    (local $a i32)
    (local $b i32)
    (loop $x
      (set_local $a (i32.const 0))
      (set_local $a (i32.const 1))
      (br_if $x (i32.const 1))
    )
    (block $y
      (set_local $b (i32.const 0))
      (set_local $b (i32.const 1))
      (br $y)
    )
    (set_local $b (i32.const 1))
  )
  (func $if
    (local $x i32)
    (if (tee_local $x (i32.const 0))
      (set_local $x (i32.const 1))
      (set_local $x (i32.const 1))
    )
    (set_local $x (i32.const 1))
  )
  (func $if2
    (local $x i32)
    (if (tee_local $x (i32.const 1))
      (set_local $x (i32.const 1))
      (set_local $x (i32.const 1))
    )
    (set_local $x (i32.const 1))
  )
  (func $if3
    (local $x i32)
    (if (tee_local $x (i32.const 1))
      (set_local $x (i32.const 1))
      (set_local $x (i32.const 2))
    )
    (set_local $x (i32.const 1))
  )
)

