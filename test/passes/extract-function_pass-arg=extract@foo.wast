(module
  (func $foo
    (call $bar)
  )
  (func $bar
    (call $foo)
  )
  (func $other
    (drop (i32.const 1))
  )
)
(module
  ;; Use another function in the table.
  (table $t 10 funcref)
  (elem $0 (table $t1) (i32.const 0) func $other)
  (func $foo
  )
  (func $other
    (drop (i32.const 1))
  )
)
