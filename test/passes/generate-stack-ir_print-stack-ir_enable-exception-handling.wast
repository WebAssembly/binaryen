(module
  (event $e0 (attr 0) (param i32))

  (func $eh (local $exn exnref)
    (try
      (throw $e0 (i32.const 0))
      (catch
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
  )
)
