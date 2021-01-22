(module
  (event $e-i32 (attr 0) (param i32))
  (event $e-i64 (attr 0) (param i64))
  (event $e-i32-i64 (attr 0) (param i32 i64))

  (func $foo)
  (func $bar)

  (func $eh_test (local $x (i32 i64))
    ;; Simple try-catch
    (try
      (do
        (throw $e-i32 (i32.const 0))
      )
      (catch $e-i32
        (drop (pop i32))
      )
    )

    ;; try-catch with multivalue event
    (try
      (do
        (throw $e-i32-i64 (i32.const 0) (i64.const 0))
      )
      (catch $e-i32-i64
        (local.set $x (pop i32 i64))
        (drop
          (tuple.extract 0
            (local.get $x)
          )
        )
      )
    )

    ;; Try with a block label
    (try $l1
      (do
        (br $l1)
      )
      (catch $e-i32
        (drop (pop i32))
        (br $l1)
      )
    )

    ;; Empty try body
    (try
      (do)
      (catch $e-i32
        (drop (pop i32))
      )
    )

    ;; Multiple instructions within try and catch bodies
    (try
      (do
        (call $foo)
        (call $bar)
      )
      (catch $e-i32
        (drop (pop i32))
        (call $foo)
        (call $bar)
      )
    )

    ;; Multiple catch clauses
    (try
      (do
        (throw $e-i32 (i32.const 0))
      )
      (catch $e-i32
        (drop (pop i32))
      )
      (catch $e-i64
        (drop (pop i64))
      )
    )

    ;; Single catch-all clause
    (try
      (do
        (throw $e-i32 (i32.const 0))
      )
      (catch_all)
    )

    ;; catch and catch-all clauses together
    (try
      (do
        (throw $e-i32 (i32.const 0))
      )
      (catch $e-i32
        (drop (pop i32))
      )
      (catch $e-i64
        (drop (pop i64))
      )
      (catch_all
        (call $foo)
        (call $bar)
      )
    )

    ;; rethrow
    (try
      (do
        (throw $e-i32 (i32.const 0))
      )
      (catch $e-i32
        (drop (pop i32))
        (rethrow 0)
      )
    )
  )
)
