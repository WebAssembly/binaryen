(module
 (global $f (mut i64) (i64.const 0x12345678ABCDEFAF))
 (func $call (param i64))
 (func $exp (export "exp")
  (call $call (global.get $f))
  (global.set $f (i64.const 0x1122334455667788))
 )
)
