;; Test `call_indirect` operator

(module
  ;; Auxiliary definitions
  (type $proc (func))
  (type $out-i32 (func (result i32)))
  (type $out-i64 (func (result i64)))
  (type $out-f32 (func (result f32)))
  (type $out-f64 (func (result f64)))
  (type $over-i32 (func (param i32) (result i32)))
  (type $over-i64 (func (param i64) (result i64)))
  (type $over-f32 (func (param f32) (result f32)))
  (type $over-f64 (func (param f64) (result f64)))
  (type $f32-i32 (func (param f32 i32) (result i32)))
  (type $i32-i64 (func (param i32 i64) (result i64)))
  (type $f64-f32 (func (param f64 f32) (result f32)))
  (type $i64-f64 (func (param i64 f64) (result f64)))
  (type $over-i32-duplicate (func (param i32) (result i32)))
  (type $over-i64-duplicate (func (param i64) (result i64)))
  (type $over-f32-duplicate (func (param f32) (result f32)))
  (type $over-f64-duplicate (func (param f64) (result f64)))

  (func $const-i32 (type $out-i32) (i32.const 0x132))
  (func $const-i64 (type $out-i64) (i64.const 0x164))
  (func $const-f32 (type $out-f32) (f32.const 0xf32))
  (func $const-f64 (type $out-f64) (f64.const 0xf64))

  (func $id-i32 (type $over-i32) (local.get 0))
  (func $id-i64 (type $over-i64) (local.get 0))
  (func $id-f32 (type $over-f32) (local.get 0))
  (func $id-f64 (type $over-f64) (local.get 0))

  (func $i32-i64 (type $i32-i64) (local.get 1))
  (func $i64-f64 (type $i64-f64) (local.get 1))
  (func $f32-i32 (type $f32-i32) (local.get 1))
  (func $f64-f32 (type $f64-f32) (local.get 1))

  (func $over-i32-duplicate (type $over-i32-duplicate) (local.get 0))
  (func $over-i64-duplicate (type $over-i64-duplicate) (local.get 0))
  (func $over-f32-duplicate (type $over-f32-duplicate) (local.get 0))
  (func $over-f64-duplicate (type $over-f64-duplicate) (local.get 0))

  (table funcref
    (elem
      $const-i32 $const-i64 $const-f32 $const-f64
      $id-i32 $id-i64 $id-f32 $id-f64
      $f32-i32 $i32-i64 $f64-f32 $i64-f64
      $fac $fib $even $odd
      $runaway $mutual-runaway1 $mutual-runaway2
      $over-i32-duplicate $over-i64-duplicate
      $over-f32-duplicate $over-f64-duplicate
    )
  )

  ;; Typing

  (func (export "type-i32") (result i32) (call_indirect (type $out-i32) (i32.const 0)))
  (func (export "type-i64") (result i64) (call_indirect (type $out-i64) (i32.const 1)))
  (func (export "type-f32") (result f32) (call_indirect (type $out-f32) (i32.const 2)))
  (func (export "type-f64") (result f64) (call_indirect (type $out-f64) (i32.const 3)))

  (func (export "type-index") (result i64)
    (call_indirect (type $over-i64) (i64.const 100) (i32.const 5))
  )

  (func (export "type-first-i32") (result i32)
    (call_indirect (type $over-i32) (i32.const 32) (i32.const 4))
  )
  (func (export "type-first-i64") (result i64)
    (call_indirect (type $over-i64) (i64.const 64) (i32.const 5))
  )
  (func (export "type-first-f32") (result f32)
    (call_indirect (type $over-f32) (f32.const 1.32) (i32.const 6))
  )
  (func (export "type-first-f64") (result f64)
    (call_indirect (type $over-f64) (f64.const 1.64) (i32.const 7))
  )

  (func (export "type-second-i32") (result i32)
    (call_indirect (type $f32-i32) (f32.const 32.1) (i32.const 32) (i32.const 8))
  )
  (func (export "type-second-i64") (result i64)
    (call_indirect (type $i32-i64) (i32.const 32) (i64.const 64) (i32.const 9))
  )
  (func (export "type-second-f32") (result f32)
    (call_indirect (type $f64-f32) (f64.const 64) (f32.const 32) (i32.const 10))
  )
  (func (export "type-second-f64") (result f64)
    (call_indirect (type $i64-f64) (i64.const 64) (f64.const 64.1) (i32.const 11))
  )

  ;; Dispatch

  (func (export "dispatch") (param i32 i64) (result i64)
    (call_indirect (type $over-i64) (local.get 1) (local.get 0))
  )

  (func (export "dispatch-structural") (param i32) (result i64)
    (call_indirect (type $over-i64-duplicate) (i64.const 9) (local.get 0))
  )

  ;; Recursion

  (func $fac (export "fac") (type $over-i64)
    (if i64 (i64.eqz (local.get 0))
      (then
        (i64.const 1)
      )
      (else
        (i64.mul
          (local.get 0)
          (call_indirect (type $over-i64)
            (i64.sub (local.get 0) (i64.const 1))
            (i32.const 12)
          )
        )
      )
    )
  )

  (func $fib (export "fib") (type $over-i64)
    (if i64 (i64.le_u (local.get 0) (i64.const 1))
      (then
        (i64.const 1)
      )
      (else
        (i64.add
          (call_indirect (type $over-i64)
            (i64.sub (local.get 0) (i64.const 2))
            (i32.const 13)
          )
          (call_indirect (type $over-i64)
            (i64.sub (local.get 0) (i64.const 1))
            (i32.const 13)
          )
        )
      )
    )
  )

  (func $even (export "even") (param i32) (result i32)
    (if i32 (i32.eqz (local.get 0))
      (then
        (i32.const 44)
      )
      (else
        (call_indirect (type $over-i32)
          (i32.sub (local.get 0) (i32.const 1))
          (i32.const 15)
        )
      )
    )
  )
  (func $odd (export "odd") (param i32) (result i32)
    (if i32 (i32.eqz (local.get 0))
      (then
        (i32.const 99)
      )
      (else
        (call_indirect (type $over-i32)
          (i32.sub (local.get 0) (i32.const 1))
          (i32.const 14)
        )
      )
    )
  )

  ;; Stack exhaustion

  ;; Implementations are required to have every call consume some abstract
  ;; resource towards exhausting some abstract finite limit, such that
  ;; infinitely recursive test cases reliably trap in finite time. This is
  ;; because otherwise applications could come to depend on it on those
  ;; implementations and be incompatible with implementations that don't do
  ;; it (or don't do it under the same circumstances).

  (func $runaway (export "runaway") (call_indirect (type $proc) (i32.const 16)))

  (func $mutual-runaway1 (export "mutual-runaway") (call_indirect (type $proc) (i32.const 18)))
  (func $mutual-runaway2 (call_indirect (type $proc) (i32.const 17)))
)

(assert_return (invoke "type-i32") (i32.const 0x132))
(assert_return (invoke "type-i64") (i64.const 0x164))
(assert_return (invoke "type-f32") (f32.const 0xf32))
(assert_return (invoke "type-f64") (f64.const 0xf64))

(assert_return (invoke "type-index") (i64.const 100))

(assert_return (invoke "type-first-i32") (i32.const 32))
(assert_return (invoke "type-first-i64") (i64.const 64))
(assert_return (invoke "type-first-f32") (f32.const 1.32))
(assert_return (invoke "type-first-f64") (f64.const 1.64))

(assert_return (invoke "type-second-i32") (i32.const 32))
(assert_return (invoke "type-second-i64") (i64.const 64))
(assert_return (invoke "type-second-f32") (f32.const 32))
(assert_return (invoke "type-second-f64") (f64.const 64.1))

(assert_return (invoke "dispatch" (i32.const 5) (i64.const 2)) (i64.const 2))
(assert_return (invoke "dispatch" (i32.const 5) (i64.const 5)) (i64.const 5))
(assert_return (invoke "dispatch" (i32.const 12) (i64.const 5)) (i64.const 120))
(assert_return (invoke "dispatch" (i32.const 13) (i64.const 5)) (i64.const 8))
(assert_return (invoke "dispatch" (i32.const 20) (i64.const 2)) (i64.const 2))
(assert_trap (invoke "dispatch" (i32.const 0) (i64.const 2)) "indirect call signature mismatch")
(assert_trap (invoke "dispatch" (i32.const 15) (i64.const 2)) "indirect call signature mismatch")
(assert_trap (invoke "dispatch" (i32.const 23) (i64.const 2)) "undefined element")
(assert_trap (invoke "dispatch" (i32.const -1) (i64.const 2)) "undefined element")
(assert_trap (invoke "dispatch" (i32.const 1213432423) (i64.const 2)) "undefined element")

(assert_return (invoke "dispatch-structural" (i32.const 5)) (i64.const 9))
(assert_return (invoke "dispatch-structural" (i32.const 5)) (i64.const 9))
(assert_return (invoke "dispatch-structural" (i32.const 12)) (i64.const 362880))
(assert_return (invoke "dispatch-structural" (i32.const 20)) (i64.const 9))
(assert_trap (invoke "dispatch-structural" (i32.const 11)) "indirect call signature mismatch")
(assert_trap (invoke "dispatch-structural" (i32.const 22)) "indirect call signature mismatch")

(assert_return (invoke "fac" (i64.const 0)) (i64.const 1))
(assert_return (invoke "fac" (i64.const 1)) (i64.const 1))
(assert_return (invoke "fac" (i64.const 5)) (i64.const 120))
(assert_return (invoke "fac" (i64.const 25)) (i64.const 7034535277573963776))

(assert_return (invoke "fib" (i64.const 0)) (i64.const 1))
(assert_return (invoke "fib" (i64.const 1)) (i64.const 1))
(assert_return (invoke "fib" (i64.const 2)) (i64.const 2))
(assert_return (invoke "fib" (i64.const 5)) (i64.const 8))
(assert_return (invoke "fib" (i64.const 20)) (i64.const 10946))

(assert_return (invoke "even" (i32.const 0)) (i32.const 44))
(assert_return (invoke "even" (i32.const 1)) (i32.const 99))
(assert_return (invoke "even" (i32.const 10)) (i32.const 44))
(assert_return (invoke "even" (i32.const 7)) (i32.const 99))
(assert_return (invoke "odd" (i32.const 0)) (i32.const 99))
(assert_return (invoke "odd" (i32.const 1)) (i32.const 44))
(assert_return (invoke "odd" (i32.const 20)) (i32.const 99))
(assert_return (invoke "odd" (i32.const 7)) (i32.const 44))

(assert_trap (invoke "runaway") "call stack exhausted")
(assert_trap (invoke "mutual-runaway") "call stack exhausted")


;; Invalid typing

(assert_invalid
  (module
    (type (func))
    (func $no-table (call_indirect (type 0) (i32.const 0)))
  )
  "unknown table"
)

(assert_invalid
  (module
    (type (func))
    (table 0 funcref)
    (func $type-void-vs-num (i32.eqz (call_indirect (type 0) (i32.const 0))))
  )
  "type mismatch"
)
(assert_invalid
  (module
    (type (func (result i64)))
    (table 0 funcref)
    (func $type-num-vs-num (i32.eqz (call_indirect (type 0) (i32.const 0))))
  )
  "type mismatch"
)

(assert_invalid
  (module
    (type (func (param i32)))
    (table 0 funcref)
    (func $arity-0-vs-1 (call_indirect (type 0) (i32.const 0)))
  )
  "type mismatch"
)
(assert_invalid
  (module
    (type (func (param f64 i32)))
    (table 0 funcref)
    (func $arity-0-vs-2 (call_indirect (type 0) (i32.const 0)))
  )
  "type mismatch"
)
(assert_invalid
  (module
    (type (func))
    (table 0 funcref)
    (func $arity-1-vs-0 (call_indirect (type 0) (i32.const 1) (i32.const 0)))
  )
  "type mismatch"
)
(assert_invalid
  (module
    (type (func))
    (table 0 funcref)
    (func $arity-2-vs-0
      (call_indirect (type 0) (f64.const 2) (i32.const 1) (i32.const 0))
    )
  )
  "type mismatch"
)

(assert_invalid
  (module
    (type (func (param i32)))
    (table 0 funcref)
    (func $type-func-void-vs-i32 (call_indirect (type 0) (i32.const 1) (nop)))
  )
  "type mismatch"
)
(assert_invalid
  (module
    (type (func (param i32)))
    (table 0 funcref)
    (func $type-func-num-vs-i32 (call_indirect (type 0) (i32.const 0) (i64.const 1)))
  )
  "type mismatch"
)

(assert_invalid
  (module
    (type (func (param i32 i32)))
    (table 0 funcref)
    (func $type-first-void-vs-num
      (call_indirect (type 0) (nop) (i32.const 1) (i32.const 0))
    )
  )
  "type mismatch"
)
(assert_invalid
  (module
    (type (func (param i32 i32)))
    (table 0 funcref)
    (func $type-second-void-vs-num
      (call_indirect (type 0) (i32.const 1) (nop) (i32.const 0))
    )
  )
  "type mismatch"
)
(assert_invalid
  (module
    (type (func (param i32 f64)))
    (table 0 funcref)
    (func $type-first-num-vs-num
      (call_indirect (type 0) (f64.const 1) (i32.const 1) (i32.const 0))
    )
  )
  "type mismatch"
)
(assert_invalid
  (module
    (type (func (param f64 i32)))
    (table 0 funcref)
    (func $type-second-num-vs-num
      (call_indirect (type 0) (i32.const 1) (f64.const 1) (i32.const 0))
    )
  )
  "type mismatch"
)


;; Unbound type

(assert_invalid
  (module
    (table 0 funcref)
    (func $unbound-type (call_indirect (type 1) (i32.const 0)))
  )
  "unknown type"
)
(assert_invalid
  (module
    (table 0 funcref)
    (func $large-type (call_indirect (type 1012321300) (i32.const 0)))
  )
  "unknown type"
)
