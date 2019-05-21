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

