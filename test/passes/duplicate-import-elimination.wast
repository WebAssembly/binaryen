(module
  (import "env" "waka" (func $foo))
  (import "env" "waka" (func $bar))
  (import "env" "waka" (func $wrong (param i32)))
  (table 2 2 funcref)
  (elem (i32.const 0) $foo $bar)
  (start $bar)
  (func "baz"
    (call $foo)
    (call $bar)
    (call $wrong (i32.const 1))
  )
)

