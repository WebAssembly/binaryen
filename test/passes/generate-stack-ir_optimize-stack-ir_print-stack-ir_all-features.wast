(module
  (event $e0 (attr 0) (param i32))

  (func $eh (local $exn exnref)
    (try
      (do
        (throw $e0 (i32.const 0))
      )
      (catch
        (local.set $exn (pop exnref))
        (drop
          (block $l0 (result i32)
            (rethrow
              (br_on_exn $l0 $e0 (local.get $exn))
            )
          )
        )
      )
    )
  )
)
