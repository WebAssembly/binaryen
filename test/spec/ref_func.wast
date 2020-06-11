(module
  (func (export "f") (param $x i32) (result i32) (local.get $x))
)
(module
  (func $f (import "M" "f") (param i32) (result i32))
  (func $g (param $x i32) (result i32) (i32.add (local.get $x) (i32.const 1)))

  (global externref (ref.func $f))
  (global externref (ref.func $g))
  (global funcref (ref.func $f))
  (global funcref (ref.func $g))
  (global $v (mut funcref) (ref.func $f))

  (func (export "is_null-f") (result i32)
    (ref.is_null (ref.func $f))
  )
  (func (export "is_null-g") (result i32)
    (ref.is_null (ref.func $g))
  )
  (func (export "is_null-v") (result i32)
    (ref.is_null (global.get $v))
  )

  (func (export "set-f") (global.set $v (ref.func $f)))
  (func (export "set-g") (global.set $v (ref.func $g)))

  (table $t 1 funcref)
)

(assert_return (invoke "is_null-f") (i32.const 0))
(assert_return (invoke "is_null-g") (i32.const 0))
(assert_return (invoke "is_null-v") (i32.const 0))

(invoke "set-g")
(invoke "set-f")

(assert_invalid
  (module
    (func $f (import "M" "f") (param i32) (result i32))
    (func $g (import "M" "g") (param i32) (result i32))
    (global funcref (ref.func 7))
  )
  "unknown function 7"
)
