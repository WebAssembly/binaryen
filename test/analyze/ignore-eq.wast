(module
  (func $func (param $x i32) (param $y i32)
    ;; We should see that this is not equal to 0, and the only way to see that
    ;; is to test it with $x == 123456 specifically.
    (drop
      (i32.eq
        (local.get $x)
        (i32.const 123456)
      )
    )
    ;; Add another eq expression with a different constant. We should not be
    ;; confused by this either; nothing is optimizable here.
    (drop
      (i32.eq
        (local.get $x)
        (i32.const 42)
      )
    )
    (drop
      (i32.const 0)
    )
  )
)

