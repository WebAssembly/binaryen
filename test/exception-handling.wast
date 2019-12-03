(module
  (event $e0 (attr 0) (param i32))

  (func $exnref_test (param $0 exnref) (result exnref)
    (local.get $0)
  )

  (func $foo)
  (func $bar)

  (func $eh_test (local $exn exnref)
    (try
      (throw $e0 (i32.const 0))
      (catch
        ;; Multi-value is not available yet, so block can't take a value from
        ;; stack. So this uses locals for now.
        (local.set $exn (exnref.pop))
        (drop
          (block $l0 (result i32)
            (rethrow
              (br_on_exn $l0 $e0 (local.get $exn))
            )
          )
        )
      )
    )

    ;; Try with a block label
    (try $l1
      (br $l1)
      (catch
        (br $l1)
      )
    )

    ;; Empty try body
    (try
      (catch
        (drop (exnref.pop))
      )
    )

    ;; Multiple instructions within try and catch bodies
    (try
      (block
        (call $foo)
        (call $bar)
      )
      (catch
        (drop (exnref.pop))
        (call $foo)
        (call $bar)
      )
    )
  )
)
