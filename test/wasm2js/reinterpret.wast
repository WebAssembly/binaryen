(module
  (func $dummy)

  (func (export "i32_roundtrip") (param $0 i32) (result i32)
    (i32.eq (i32.reinterpret/f32 (f32.reinterpret/i32 (get_local $0))) (get_local $0)))
  (func (export "i64_roundtrip") (param $0 i64) (result i32)
    (i64.eq (i64.reinterpret/f64 (f64.reinterpret/i64 (get_local $0))) (get_local $0)))
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
