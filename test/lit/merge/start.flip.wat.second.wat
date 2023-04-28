(module
  (func $start
    ;; Not a start function, but the name overlaps so it will get deduplicated.
    (drop
      (i32.const 1)
    )
  )
)
