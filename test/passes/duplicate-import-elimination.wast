(module
  (import "env" "waka" (func $foo))
  (import "env" "waka" (func $bar))
  (table 2 2 funcref)
  (elem (i32.const 0) $foo $bar)
  (start $bar)
  (func "baz"
    (call $foo)
    (call $bar)
  )
)

