(module
 (global $f (mut i64) (i64.const 0x12345678ABCDEFAF))
 (global $g (mut i64) (global.get $f))
 (func "exp"
  (drop (global.get $f))
  (global.set $f (i64.const 0x1122334455667788))
 )
)
