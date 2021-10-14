(module
  (import "env" "imported_tag" (tag $t0))
  (tag $t1)
  (export "test" (func $test))

  (func $test
    (try
      (do
        (throw $t0)
      )
      (catch $t1)
    )
  )
)
