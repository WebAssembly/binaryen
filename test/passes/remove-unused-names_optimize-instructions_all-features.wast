(module
  (func $dummy)
  (event $e (attr 0) (param i32))

  (func $getFallthrough ;; unit tests for Properties::getFallthrough
    (local $x0 i32)
    (local $x1 i32)
    (local $x2 i32)
    (local $x3 i32)

    ;; try - try body does not throw, can
    (local.set $x0
      (try (result i32)
        (i32.const 1)
        (catch
          (drop (exnref.pop))
          (i32.const 3)
        )
      )
    )
    (drop (i32.and (local.get $x0) (i32.const 7)))

    ;; try - try body may throw, can't
    (local.set $x1
      (try (result i32)
        (block (result i32)
          (call $dummy)
          (i32.const 1)
        )
        (catch
          (drop (exnref.pop))
          (i32.const 3)
        )
      )
    )
    (drop (i32.and (local.get $x1) (i32.const 7)))

    ;; nested try - inner try may throw but will be caught by inner catch, can
    (local.set $x2
      (try (result i32)
        (block (result i32)
          (try
            (throw $e (i32.const 0))
            (catch
              (drop (exnref.pop))
            )
          )
          (i32.const 1)
        )
        (catch
          (drop (exnref.pop))
          (i32.const 3)
        )
      )
    )
    (drop (i32.and (local.get $x2) (i32.const 7)))

    ;; nested try - inner catch may throw, can't
    (local.set $x3
      (try (result i32)
        (block (result i32)
          (try
            (catch
              (drop (exnref.pop))
              (throw $e (i32.const 0))
            )
          )
          (i32.const 1)
        )
        (catch
          (drop (exnref.pop))
          (i32.const 3)
        )
      )
    )
    (drop (i32.and (local.get $x3) (i32.const 7)))
  )
)
