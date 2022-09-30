(module
  (func "test1" (param $x i32)
    ;; The presence of params stops us from evalling this function, at least
    ;; not with --ignore-external-input (see ignore-external-input.wast)
    (nop)
  )
)
