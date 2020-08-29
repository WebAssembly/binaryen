(module
  (event $e0 (attr 0) (param i32))
  (event $e1 (attr 0) (param externref))

  (func $exnref_test (param $0 exnref) (result exnref)
    (local.get $0)
  )

  (func $foo)
  (func $bar)

  (func $eh_test (local $exn exnref)
    (try
      (do
        (throw $e0 (i32.const 0))
      )
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
      (do
        (br $l1)
      )
      (catch
        (br $l1)
      )
    )

    ;; Empty try body
    (try
      (do)
      (catch
        (drop (exnref.pop))
      )
    )

    ;; Multiple instructions within try and catch bodies
    (try
      (do
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

  ;; Test subtype relationship
  ;; TODO: This test used to test nullref <: exnref, but with nullref removed
  ;; there are no testable subtypes of exnref anymore. Left in place fwiw.
  (func $subtype_test
    (try
      (do)
      (catch
        (drop (exnref.pop))
        (drop
          (block $l0 (result i32)
            (rethrow
              (br_on_exn $l0 $e0 (ref.null exn)) ;; was nullref
            )
          )
        )
      )
    )

    (throw $e1 (ref.null exn)) ;; was nullref
  )
)
