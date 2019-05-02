(module
  (event $e0 (attr 0) (param i32))

  (func $exnref_test (param $0 exnref) (result exnref)
    (local.get $0)
  )

  (func $eh_test (local $exn exnref)
    (try
      (throw $e0 (i32.const 0))
      (catch
        ;; Multi-value is not available yet, so block can't take a value from
        ;; stack. So this uses locals for now.
        (local.set $exn (exnref.pop))
        (drop
          (block $l0 (result i32)
            (br_on_exn $l0 $e0 (local.get $exn))
            (rethrow (exnref.pop))
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

    ;; Try-catch empty bodies test
    ;; This fails to validate now presumably due to a v8 bug:
    ;; https://bugs.chromium.org/p/v8/issues/detail?id=9584
    ;; TODO Enable this test later
    ;; (try
    ;;   (catch
    ;;   )
    ;; )
  )
)
