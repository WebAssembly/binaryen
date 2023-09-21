(module
  (type $f (func (result i32)))

  (table $t 10 funcref)

  (func $0 (result i32)
    (i32.const 0)
  )

  (func $1 (result i32)
    (i32.const 1)
  )

  (func $2 (result i32)
    (i32.const 2)
  )

  (func $3 (result i32)
    (i32.const 3)
  )

  (func $4 (result i32)
    (i32.const 4)
  )

  (func (export "fill-0") (param $i i32) (param $n i32)
    (table.fill $t (local.get $i) (ref.func $0) (local.get $n))
  )

  (func (export "fill-1") (param $i i32) (param $n i32)
    (table.fill $t (local.get $i) (ref.func $1) (local.get $n))
  )

  (func (export "fill-2") (param $i i32) (param $n i32)
    (table.fill $t (local.get $i) (ref.func $2) (local.get $n))
  )

  (func (export "fill-3") (param $i i32) (param $n i32)
    (table.fill $t (local.get $i) (ref.func $3) (local.get $n))
  )

  (func (export "fill-4") (param $i i32) (param $n i32)
    (table.fill $t (local.get $i) (ref.func $4) (local.get $n))
  )

  (func (export "fill-null") (param $i i32) (param $n i32)
    (table.fill $t (local.get $i) (ref.null func) (local.get $n))
  )

  (func (export "get-null") (param $i i32) (result funcref)
    (table.get $t (local.get $i))
  )

  (func (export "get") (param $i i32) (result i32)
    (call_indirect $t (type $f) (local.get $i))
  )
)

(assert_return (invoke "get-null" (i32.const 1)) (ref.null func))
(assert_return (invoke "get-null" (i32.const 2)) (ref.null func))
(assert_return (invoke "get-null" (i32.const 3)) (ref.null func))
(assert_return (invoke "get-null" (i32.const 4)) (ref.null func))
(assert_return (invoke "get-null" (i32.const 5)) (ref.null func))

(assert_return (invoke "fill-1" (i32.const 2) (i32.const 3)))
(assert_return (invoke "get-null" (i32.const 1)) (ref.null func))
(assert_return (invoke "get" (i32.const 2)) (i32.const 1))
(assert_return (invoke "get" (i32.const 3)) (i32.const 1))
(assert_return (invoke "get" (i32.const 4)) (i32.const 1))
(assert_return (invoke "get-null" (i32.const 5)) (ref.null func))

(assert_return (invoke "fill-2" (i32.const 4) (i32.const 2)))
(assert_return (invoke "get" (i32.const 3)) (i32.const 1))
(assert_return (invoke "get" (i32.const 4)) (i32.const 2))
(assert_return (invoke "get" (i32.const 5)) (i32.const 2))
(assert_return (invoke "get-null" (i32.const 6)) (ref.null func))

(assert_return (invoke "fill-3" (i32.const 4) (i32.const 0)))
(assert_return (invoke "get" (i32.const 3)) (i32.const 1))
(assert_return (invoke "get" (i32.const 4)) (i32.const 2))
(assert_return (invoke "get" (i32.const 5)) (i32.const 2))

(assert_return (invoke "fill-4" (i32.const 8) (i32.const 2)))
(assert_return (invoke "get-null" (i32.const 7)) (ref.null func))
(assert_return (invoke "get" (i32.const 8)) (i32.const 4))
(assert_return (invoke "get" (i32.const 9)) (i32.const 4))

(assert_return (invoke "fill-null" (i32.const 9) (i32.const 1)))
(assert_return (invoke "get" (i32.const 8)) (i32.const 4))
(assert_return (invoke "get-null" (i32.const 9)) (ref.null func))

(assert_return (invoke "fill-1" (i32.const 10) (i32.const 0)))
(assert_return (invoke "get-null" (i32.const 9)) (ref.null func))

(assert_trap
  (invoke "fill-2" (i32.const 8) (i32.const 3))
  "out of bounds table access"
)
(assert_return (invoke "get-null" (i32.const 7)) (ref.null func))
(assert_return (invoke "get" (i32.const 8)) (i32.const 4))
(assert_return (invoke "get-null" (i32.const 9)) (ref.null func))

(assert_trap
  (invoke "fill" (i32.const 11) (ref.null extern) (i32.const 0))
  "out of bounds table access"
)

(assert_trap
  (invoke "fill" (i32.const 11) (ref.null extern) (i32.const 10))
  "out of bounds table access"
)


;; Type errors

(assert_invalid
  (module
    (table $t 10 externref)
    (func $type-index-value-length-empty-vs-i32-i32
      (table.fill $t)
    )
  )
  "type mismatch"
)
(assert_invalid
  (module
    (table $t 10 externref)
    (func $type-index-empty-vs-i32
      (table.fill $t (ref.null extern) (i32.const 1))
    )
  )
  "type mismatch"
)
(assert_invalid
  (module
    (table $t 10 externref)
    (func $type-value-empty-vs
      (table.fill $t (i32.const 1) (i32.const 1))
    )
  )
  "type mismatch"
)
(assert_invalid
  (module
    (table $t 10 externref)
    (func $type-length-empty-vs-i32
      (table.fill $t (i32.const 1) (ref.null extern))
    )
  )
  "type mismatch"
)
(assert_invalid
  (module
    (table $t 0 externref)
    (func $type-index-f32-vs-i32
      (table.fill $t (f32.const 1) (ref.null extern) (i32.const 1))
    )
  )
  "type mismatch"
)
(assert_invalid
  (module
    (table $t 0 funcref)
    (func $type-value-vs-funcref (param $r externref)
      (table.fill $t (i32.const 1) (local.get $r) (i32.const 1))
    )
  )
  "type mismatch"
)
(assert_invalid
  (module
    (table $t 0 externref)
    (func $type-length-f32-vs-i32
      (table.fill $t (i32.const 1) (ref.null extern) (f32.const 1))
    )
  )
  "type mismatch"
)

(assert_invalid
  (module
    (table $t1 1 externref)
    (table $t2 1 funcref)
    (func $type-value-externref-vs-funcref-multi (param $r externref)
      (table.fill $t2 (i32.const 0) (local.get $r) (i32.const 1))
    )
  )
  "type mismatch"
)

(assert_invalid
  (module
    (table $t 1 externref)
    (func $type-result-empty-vs-num (result i32)
      (table.fill $t (i32.const 0) (ref.null extern) (i32.const 1))
    )
  )
  "type mismatch"
)
