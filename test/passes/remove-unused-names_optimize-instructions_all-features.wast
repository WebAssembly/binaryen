(module
  (func $dummy)
  (event $e (attr 0) (param i32))

  (func $getFallthrough ;; unit tests for Properties::getFallthrough
    (local $x0 i32)
    (local $x1 i32)
    (local $x2 i32)
    (local $x3 i32)
    (local $x4 i32)

    ;; try - try body does not throw, can
    (local.set $x0
      (try (result i32)
        (do
          (i32.const 1)
        )
        (catch_all
          (i32.const 3)
        )
      )
    )
    (drop (i32.and (local.get $x0) (i32.const 7)))

    ;; try - try body may throw, can't
    (local.set $x1
      (try (result i32)
        (do
          (call $dummy)
          (i32.const 1)
        )
        (catch_all
          (i32.const 3)
        )
      )
    )
    (drop (i32.and (local.get $x1) (i32.const 7)))

    ;; nested try - inner try may throw and may not be caught by inner catch,
    ;; can't
    (local.set $x2
      (try (result i32)
        (do
          (try
            (do
              (throw $e (i32.const 0))
            )
            (catch $e
              (drop (pop i32))
            )
          )
          (i32.const 1)
        )
        (catch $e
          (drop (pop i32))
          (i32.const 3)
        )
      )
    )
    (drop (i32.and (local.get $x2) (i32.const 7)))

    ;; nested try - inner try may throw but will be caught by inner catch_all,
    ;; can
    (local.set $x3
      (try (result i32)
        (do
          (try
            (do
              (throw $e (i32.const 0))
            )
            (catch_all)
          )
          (i32.const 1)
        )
        (catch_all
          (i32.const 3)
        )
      )
    )
    (drop (i32.and (local.get $x3) (i32.const 7)))

    ;; nested try - inner catch_all may throw, can't
    (local.set $x4
      (try (result i32)
        (do
          (try
            (do)
            (catch_all
              (throw $e (i32.const 0))
            )
          )
          (i32.const 1)
        )
        (catch_all
          (i32.const 3)
        )
      )
    )
    (drop (i32.and (local.get $x4) (i32.const 7)))
  )
)
