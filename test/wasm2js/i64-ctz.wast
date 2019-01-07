(module
 (export "a" (func $popcnt64))
 (export "b" (func $ctz64))
 (func $popcnt64 (param $0 i64) (result i64)
   (i64.popcnt (local.get $0)))
 (func $ctz64 (param $0 i64) (result i64)
   (i64.ctz (local.get $0)))
 )
