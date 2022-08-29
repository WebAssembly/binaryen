(module
  (func $dummy)

  (func (export "i32_roundtrip") (param $0 i32) (result i32)
    (i32.eq (i32.reinterpret_f32 (f32.reinterpret_i32 (local.get $0))) (local.get $0)))
  (func (export "i64_roundtrip") (param $0 i64) (result i32)
    (i64.eq (i64.reinterpret_f64 (f64.reinterpret_i64 (local.get $0))) (local.get $0)))
)

(assert_return (invoke "i32_roundtrip" (i32.const 0))
               (i32.const 1))
(assert_return (invoke "i32_roundtrip" (i32.const 1))
               (i32.const 1))
(assert_return (invoke "i32_roundtrip" (i32.const 100))
               (i32.const 1))
(assert_return (invoke "i32_roundtrip" (i32.const 10000))
               (i32.const 1))

(assert_return (invoke "i64_roundtrip" (i32.const 0) (i32.const 0))
               (i32.const 1))
(assert_return (invoke "i64_roundtrip" (i32.const 1) (i32.const 0))
               (i32.const 1))
(assert_return (invoke "i64_roundtrip" (i32.const 0) (i32.const 1))
               (i32.const 1))
