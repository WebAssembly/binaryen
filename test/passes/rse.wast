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
  (func $copy
    (local $x i32)
    (local $y i32)
    (set_local $x (i32.const 1))
    (set_local $y (get_local $x))
    (set_local $y (i32.const 1))
    (set_local $x (i32.const 2))
    (if (i32.const 1) (nop) (nop)) ;; control flow
    (set_local $y (get_local $x))
    (set_local $y (i32.const 2))
    (if (i32.const 1) (nop) (nop)) ;; control flow
    (set_local $y (i32.const 2))
    ;; flip
    (set_local $x (i32.const 3))
    (set_local $y (i32.const 3))
    (set_local $y (get_local $x)) ;; do this last
  )
  (func $param-unique
    (param $x i32)
    (local $a i32)
    (set_local $a (get_local $x))
    (set_local $a (get_local $x))
    (set_local $x (i32.eqz (i32.const 9999)))
    (set_local $a (get_local $x))
    (set_local $a (get_local $x))
  )
  (func $set-unique
    (local $x i32)
    (local $y i32)
    (set_local $x (i32.eqz (i32.const 123)))
    (set_local $y (get_local $x))
    (set_local $y (get_local $x))
    (set_local $x (i32.eqz (i32.const 456)))
    (set_local $y (get_local $x))
    (set_local $y (get_local $x))
    (set_local $x (i32.eqz (i32.const 789)))
    (if (i32.const 1) (nop) (nop)) ;; control flow
    (set_local $y (get_local $x))
    (set_local $y (get_local $x))
    (set_local $x (i32.eqz (i32.const 1000)))
    (set_local $y (get_local $x))
    (if (i32.const 1) (nop) (nop)) ;; control flow
    (set_local $y (get_local $x))
  )
  (func $identical_complex (param $x i32)
    (local $y i32)
    (set_local $y (get_local $x))
    (set_local $y (get_local $x))
    (set_local $y (get_local $x))
    (set_local $x (get_local $x))
    (set_local $y (get_local $y))
    (set_local $x (get_local $y))
  )
  (func $merge
    (local $x i32)
    (if (i32.const 1)
      (set_local $x (i32.const 1))
      (set_local $x (i32.const 1))
    )
    (set_local $x (i32.const 1))
    (set_local $x (i32.const 2))
    (loop $loop
      (set_local $x (i32.const 2))
      (set_local $x (i32.const 3))
      (set_local $x (i32.const 2))
      (br_if $loop (i32.const 2))
    )
    (set_local $x (i32.const 2))
  )
  (func $one-arm
   (param $1 i32)
   (param $3 i32)
   (set_local $1
    (get_local $3)
   )
   (if
    (i32.const 1)
    (nop)
    (set_local $3
     (get_local $1)
    )
   )
  )
  (func $one-arm2
   (param $1 i32)
   (param $3 i32)
   (set_local $1
    (get_local $3)
   )
   (if
    (i32.const 1)
    (set_local $3
     (get_local $1)
    )
   )
  )
  (func $many-merges
   (local $0 i32)
   (local $1 i32)
   (block $block
    (br_if $block
     (i32.const 0)
    )
    (loop $loop
     (set_local $1
      (get_local $0)
     )
     (set_local $0
      (i32.const 99)
     )
     (br_if $loop
      (i32.const 1)
     )
    )
   )
   (set_local $0 ;; make them equal
    (get_local $1)
   )
   (if
    (i32.const 0)
    (set_local $1 ;; we can drop this
     (get_local $0)
    )
   )
  )
)

