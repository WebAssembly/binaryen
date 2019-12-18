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

(module
 (memory 1 1)
 (table 0 funcref)
)
