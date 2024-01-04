(module
  (func $contrast ;; check for tee and structure sinking
    (local $x i32)
    (local $y i32)
    (local $z i32)
    (local $a i32)
    (local $b i32)
    (local.set $x (i32.const 1))
    (if (local.get $x) (then (nop)))
    (if (local.get $x) (then (nop)))
    (local.set $y (if (result i32) (i32.const 2) (then (i32.const 3) )(else (i32.const 4))))
    (drop (local.get $y))
    (local.set $z (block (result i32) (i32.const 5)))
    (drop (local.get $z))
    (if (i32.const 6)
      (then
        (local.set $a (i32.const 7))
      )
      (else
        (local.set $a (i32.const 8))
      )
    )
    (drop (local.get $a))
    (block $val
      (if (i32.const 10)
        (then
          (block
            (local.set $b (i32.const 11))
            (br $val)
          )
        )
      )
      (local.set $b (i32.const 12))
    )
    (drop (local.get $b))
  )
)

