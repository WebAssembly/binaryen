(module
  (func $f1 (export "externref") (param $x externref) (result i32)
    (ref.is_null (local.get $x))
  )
  (func $f2 (export "funcref") (param $x funcref) (result i32)
    (ref.is_null (local.get $x))
  )
)

(assert_return (invoke "externref" (ref.null extern)) (i32.const 1))
(assert_return (invoke "funcref" (ref.null func)) (i32.const 1))
