(module
  (func $compare (export "compare") (param $x eqref) (param $y eqref) (result i32)
    (ref.eq
      (local.get $x)
      (local.get $y)
    )
  )
)

;; All nulls compare equal, regardless of their type.
(assert_return (invoke "compare" (ref.null none) (ref.null eq)) (i32.const 1))
