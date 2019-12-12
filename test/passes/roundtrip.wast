(module
  (func "foo"
    ;; binaryen skips unreachable code while reading the binary format
    (unreachable)
    (nop)
    (nop)
    (nop)
    (nop)
    (nop)
  )
)
