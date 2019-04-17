(module
  (import "env" "func" (func $import (result i64)))
  (func $defined (result i64)
    (i64.add (i64.const 1) (i64.const 2))
  )
)
(module
 (global $f (mut i64) (i64.const 0x12345678ABCDEFAF))
 (global $g (mut i64) (global.get $f))
 (func $call (param i64))
 (func "exp"
  (call $call (global.get $f))
  (global.set $f (i64.const 0x1122334455667788))
 )
)
