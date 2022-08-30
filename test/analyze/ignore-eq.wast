(module
  (func $func (param $x i32) (param $y i32)
    ;; We should see that this is not equal to 0, and the only way to see that
    ;; is to test tit with $x == 123456 specifically.
    (drop
      (i32.eq
        (local.get $x)
        (i32.const 123456)
      )
    )
    (drop
      (i32.const 0)
    )
  )
)

