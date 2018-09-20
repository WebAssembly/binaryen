(module
  (import "env" "func" (func $import (result i64)))
  (func $defined (result i64)
    (i64.add (i64.const 1) (i64.const 2))
  )
)

