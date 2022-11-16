(module
  (type $t (func (result i32)))

  (func $nn (param $r (ref $t)) (result i32)
    (call_ref (ref.as_non_null (local.get $r)))
  )
  (func $n (param $r (ref null $t)) (result i32)
    (call_ref (ref.as_non_null (local.get $r)))
  )

  (elem func $f)
  (func $f (result i32) (i32.const 7))

  (func (export "nullable-null") (result i32) (call $n (ref.null $t)))
  (func (export "nonnullable-f") (result i32) (call $nn (ref.func $f)))
  (func (export "nullable-f") (result i32) (call $n (ref.func $f)))
)

(assert_trap (invoke "nullable-null") "null reference")
(assert_return (invoke "nonnullable-f") (i32.const 7))
(assert_return (invoke "nullable-f") (i32.const 7))

(module
  (type $t (func))
  (func (param $r (ref $t)) (drop (ref.as_non_null (local.get $r))))
  (func (param $r (ref func)) (drop (ref.as_non_null (local.get $r))))
  (func (param $r (ref extern)) (drop (ref.as_non_null (local.get $r))))
)
