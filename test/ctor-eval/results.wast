(module
  (func "test1" (result i32)
    ;; The presence of a result stops us from evalling this function (at least
    ;; for now).
    (i32.const 42)
  )
)
