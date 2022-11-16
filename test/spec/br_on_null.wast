(module
  (type $t (func (result i32)))

  (func $nn (param $r (ref $t)) (result i32)
    (block $l
      (return (call_ref $t (br_on_null $l (local.get $r))))
    )
    (i32.const -1)
  )
  (func $n (param $r (ref null $t)) (result i32)
    (block $l
      (return (call_ref $t (br_on_null $l (local.get $r))))
    )
    (i32.const -1)
  )

  (func $f (result i32) (i32.const 7))

  (func (export "nullable-null") (result i32) (call $n (ref.null $t)))
  (func (export "nonnullable-f") (result i32) (call $nn (ref.func $f)))
  (func (export "nullable-f") (result i32) (call $n (ref.func $f)))

  (func (export "unreachable") (result i32)
    (block $l
      (return (call_ref $t (br_on_null $l (unreachable))))
    )
    (i32.const -1)
  )
)

(assert_trap (invoke "unreachable") "unreachable")

(assert_return (invoke "nullable-null") (i32.const -1))
(assert_return (invoke "nonnullable-f") (i32.const 7))
(assert_return (invoke "nullable-f") (i32.const 7))

(module
  (type $t (func))
  (func (param $r (ref $t)) (drop (br_on_null 0 (local.get $r))))
  (func (param $r (ref func)) (drop (br_on_null 0 (local.get $r))))
  (func (param $r (ref extern)) (drop (br_on_null 0 (local.get $r))))
)

(assert_invalid
  ;; the same module as the first one in this file, but with a type added to
  ;; the block
  (module
    (type $t (func (result i32)))

    (func $nn (param $r (ref $t)) (result i32)
      (block $l (ref null $t) ;; br_on_null sends no value; a br to here is bad
        (return (call_ref $t (br_on_null $l (local.get $r))))
      )
      (i32.const -1)
    )
  )
  "bad break type"
)
