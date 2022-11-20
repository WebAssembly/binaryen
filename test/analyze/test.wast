(module
  (func $func (param $x i32) (param $y i32)
    ;; shifting twice by 1 is the same as once by 2
    (drop
      (i32.shl
        (i32.shl
          (local.get $x)
          (i32.const 1)
        )
        (i32.const 1)
      )
    )
    (drop
      (i32.shl
        (local.get $y) ;; note how the better pattern has a different local; we abstract over them
        (i32.const 2)
      )
    )
  )
)

