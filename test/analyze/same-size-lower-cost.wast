(module
  (func $func (param $x i32)
    ;; x << 1 is the same as x * 2. there is no size difference, but the cost
    ;; benefit should be enough for us to report it.
    (drop
      (i32.shl
        (local.get $x)
        (i32.const 1)
      )
    )
    (drop
      (i32.mul
        (local.get $x)
        (i32.const 2)
      )
    )
  )
)

