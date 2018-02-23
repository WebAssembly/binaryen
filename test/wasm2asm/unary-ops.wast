(module
  (func $dummy)

  (func (export "i32.popcnt") (param $0 i32) (result i32)
    (i32.popcnt (get_local $0)))

  (func (export "check_popcnt_i64") (param $0 i64) (param $r i64) (result i32)
    (i64.eq (i64.popcnt (get_local $0)) (get_local $r)))
)

(assert_return (invoke "i32.popcnt" (i32.const 0)) (i32.const 0))
(assert_return (invoke "i32.popcnt" (i32.const 1)) (i32.const 1))
(assert_return (invoke "i32.popcnt" (i32.const 0x7fffffff)) (i32.const 31))
(assert_return (invoke "i32.popcnt" (i32.const 0xffffffff)) (i32.const 32))
