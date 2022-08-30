(module
  (func $func (param $x i32) (param $y i32) (param $z i32)
    ;; We should not find anything to optimize about this, as the output can be
    ;; either $x or $y, which can be different.
    (drop
      (select
        (local.get $x)
        (local.get $y)
        (local.get $z)
      )
    )
  )
)

