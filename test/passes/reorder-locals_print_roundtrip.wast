(module
  (func $a
    (local $x i32)
    (local $y f64)
    ;; x appears twice
    (drop (local.get $x))
    (drop (local.get $x))
    (drop (local.get $y))
  )
  (func $b
    (local $x i32)
    (local $y f64)
    ;; y appears twice, so it will be reordered to be first, and that should be
    ;; preserved in the binary format
    (drop (local.get $x))
    (drop (local.get $y))
    (drop (local.get $y))
  )
)
