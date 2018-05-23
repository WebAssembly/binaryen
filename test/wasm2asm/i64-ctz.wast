(module
 (export "a" (func $popcnt64))
 (export "b" (func $ctz64))
 (func $popcnt64 (param $0 i64) (result i64)
   (i64.popcnt (get_local $0)))
 (func $ctz64 (param $0 i64) (result i64)
   (i64.ctz (get_local $0)))
 )
