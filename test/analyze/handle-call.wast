(module
  (import "a" "b" (func $foo (result i32)))

  (func $func
    ;; Shifting twice by 1 is the same as once by 2, similar to test.wast, but
    ;; now we have calls. We abstract over them, and can still find the
    ;; optimization here.
    (drop
      (i32.shl
        (i32.shl
          (call $foo)
          (i32.const 1)
        )
        (i32.const 1)
      )
    )
    (drop
      (i32.shl
        (call $foo)
        (i32.const 2)
      )
    )
  )
)

