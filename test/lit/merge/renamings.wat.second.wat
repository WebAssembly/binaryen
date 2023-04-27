(module
  (tag $foo (param f32))

  (tag $other (param f64))

  (global $other i32 (i32.const 3))

  (global $bar i32 (i32.const 4))

  (func $foo
    (drop
      (i32.const 3)
    )
  )

  (func $other
    (drop
      (i32.const 4)
    )
  )

  (func $uses.second
    ;; Tags.
    (try
      (do)
      (catch $foo
        (drop
          (pop f32)
        )
      )
    )
    (try
      (do)
      (catch $other
        (drop
          (pop f64)
        )
      )
    )

    ;; Globals
    (drop
      (global.get $other)
    )
    (drop
      (global.get $bar)
    )

    ;; Functions.
    (call $foo)
    (call $other)
  )
)
