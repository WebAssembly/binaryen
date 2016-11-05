(module
  (func $contrast ;; check for tee and structure sinking
    (local $x i32)
    (local $y i32)
    (local $z i32)
    (set_local $x (i32.const 1))
    (if (get_local $x) (nop))
    (if (get_local $x) (nop))
    (set_local $y (if i32 (i32.const 2) (i32.const 3) (i32.const 4)))
    (drop (get_local $y))
    (set_local $z (block i32 (i32.const 5)))
    (drop (get_local $z))
  )
)

