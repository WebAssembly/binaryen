;; Test `if` operator

(module
  ;; Auxiliary definition
  (func $dummy)

  (func (export "empty") (param i32)
    (if (get_local 0) (then))
    (if (get_local 0) (then) (else))
    (if $l (get_local 0) (then))
    (if $l (get_local 0) (then) (else))
  )

  (func (export "singular") (param i32) (result i32)
    (if (get_local 0) (then (nop)))
    (if (get_local 0) (then (nop)) (else (nop)))
    (if (result i32) (get_local 0) (then (i32.const 7)) (else (i32.const 8)))
  )

  (func (export "multi") (param i32) (result i32 i32)
    (if (get_local 0) (then (call $dummy) (call $dummy) (call $dummy)))
    (if (get_local 0) (then) (else (call $dummy) (call $dummy) (call $dummy)))
    (if (result i32) (get_local 0)
      (then (call $dummy) (call $dummy) (i32.const 8) (call $dummy))
      (else (call $dummy) (call $dummy) (i32.const 9) (call $dummy))
    )
    (if (result i32 i64 i32) (get_local 0)
      (then
        (call $dummy) (call $dummy) (i32.const 1) (call $dummy)
        (call $dummy) (call $dummy) (i64.const 2) (call $dummy)
        (call $dummy) (call $dummy) (i32.const 3) (call $dummy)
      )
      (else
        (call $dummy) (call $dummy) (i32.const -1) (call $dummy)
        (call $dummy) (call $dummy) (i64.const -2) (call $dummy)
        (call $dummy) (call $dummy) (i32.const -3) (call $dummy)
      )
    )
    (drop) (drop)
  )

  (func (export "nested") (param i32 i32) (result i32)
    (if (result i32) (get_local 0)
      (then
        (if (get_local 1) (then (call $dummy) (block) (nop)))
        (if (get_local 1) (then) (else (call $dummy) (block) (nop)))
        (if (result i32) (get_local 1)
          (then (call $dummy) (i32.const 9))
          (else (call $dummy) (i32.const 10))
        )
      )
      (else
        (if (get_local 1) (then (call $dummy) (block) (nop)))
        (if (get_local 1) (then) (else (call $dummy) (block) (nop)))
        (if (result i32) (get_local 1)
          (then (call $dummy) (i32.const 10))
          (else (call $dummy) (i32.const 11))
        )
      )
    )
  )

  (func (export "as-unary-operand") (param i32) (result i32)
    (i32.ctz
      (if (result i32) (get_local 0)
        (then (call $dummy) (i32.const 13))
        (else (call $dummy) (i32.const -13))
      )
    )
  )
  (func (export "as-binary-operand") (param i32 i32) (result i32)
    (i32.mul
      (if (result i32) (get_local 0)
        (then (call $dummy) (i32.const 3))
        (else (call $dummy) (i32.const -3))
      )
      (if (result i32) (get_local 1)
        (then (call $dummy) (i32.const 4))
        (else (call $dummy) (i32.const -5))
      )
    )
  )
  (func (export "as-test-operand") (param i32) (result i32)
    (i32.eqz
      (if (result i32) (get_local 0)
        (then (call $dummy) (i32.const 13))
        (else (call $dummy) (i32.const 0))
      )
    )
  )
  (func (export "as-compare-operand") (param i32 i32) (result i32)
    (f32.gt
      (if (result f32) (get_local 0)
        (then (call $dummy) (f32.const 3))
        (else (call $dummy) (f32.const -3))
      )
      (if (result f32) (get_local 1)
        (then (call $dummy) (f32.const 4))
        (else (call $dummy) (f32.const -4))
      )
    )
  )
  (func (export "as-binary-operands") (param i32) (result i32)
    (i32.mul
      (if (result i32 i32) (get_local 0)
        (then (call $dummy) (i32.const 3) (call $dummy) (i32.const 4))
        (else (call $dummy) (i32.const 3) (call $dummy) (i32.const -4))
      )
    )
  )
  (func (export "as-compare-operands") (param i32) (result i32)
    (f32.gt
      (if (result f32 f32) (get_local 0)
        (then (call $dummy) (f32.const 3) (call $dummy) (f32.const 3))
        (else (call $dummy) (f32.const -2) (call $dummy) (f32.const -3))
      )
    )
  )
  (func (export "as-mixed-operands") (param i32) (result i32)
    (if (result i32 i32) (get_local 0)
      (then (call $dummy) (i32.const 3) (call $dummy) (i32.const 4))
      (else (call $dummy) (i32.const -3) (call $dummy) (i32.const -4))
    )
    (i32.const 5)
    (i32.add)
    (i32.mul)
  )

  (func (export "break-bare") (result i32)
    (if (i32.const 1) (then (br 0) (unreachable)))
    (if (i32.const 1) (then (br 0) (unreachable)) (else (unreachable)))
    (if (i32.const 0) (then (unreachable)) (else (br 0) (unreachable)))
    (if (i32.const 1) (then (br_if 0 (i32.const 1)) (unreachable)))
    (if (i32.const 1) (then (br_if 0 (i32.const 1)) (unreachable)) (else (unreachable)))
    (if (i32.const 0) (then (unreachable)) (else (br_if 0 (i32.const 1)) (unreachable)))
    (if (i32.const 1) (then (br_table 0 (i32.const 0)) (unreachable)))
    (if (i32.const 1) (then (br_table 0 (i32.const 0)) (unreachable)) (else (unreachable)))
    (if (i32.const 0) (then (unreachable)) (else (br_table 0 (i32.const 0)) (unreachable)))
    (i32.const 19)
  )

  (func (export "break-value") (param i32) (result i32)
    (if (result i32) (get_local 0)
      (then (br 0 (i32.const 18)) (i32.const 19))
      (else (br 0 (i32.const 21)) (i32.const 20))
    )
  )
  (func (export "break-multi-value") (param i32) (result i32 i32 i64)
    (if (result i32 i32 i64) (get_local 0)
      (then
        (br 0 (i32.const 18) (i32.const -18) (i64.const 18))
        (i32.const 19) (i32.const -19) (i64.const 19)
      )
      (else
        (br 0 (i32.const -18) (i32.const 18) (i64.const -18))
        (i32.const -19) (i32.const 19) (i64.const -19)
      )
    )
  )

  (func (export "param") (param i32) (result i32)
    (i32.const 1)
    (if (param i32) (result i32) (get_local 0)
      (then (i32.const 2) (i32.add))
      (else (i32.const -2) (i32.add))
    )
  )
  (func (export "params") (param i32) (result i32)
    (i32.const 1)
    (i32.const 2)
    (if (param i32 i32) (result i32) (get_local 0)
      (then (i32.add))
      (else (i32.sub))
    )
  )
  (func (export "params-id") (param i32) (result i32)
    (i32.const 1)
    (i32.const 2)
    (if (param i32 i32) (result i32 i32) (get_local 0) (then))
    (i32.add)
  )
  (func (export "param-break") (param i32) (result i32)
    (i32.const 1)
    (if (param i32) (result i32) (get_local 0)
      (then (i32.const 2) (i32.add) (br 0))
      (else (i32.const -2) (i32.add) (br 0))
    )
  )
  (func (export "params-break") (param i32) (result i32)
    (i32.const 1)
    (i32.const 2)
    (if (param i32 i32) (result i32) (get_local 0)
      (then (i32.add) (br 0))
      (else (i32.sub) (br 0))
    )
  )
  (func (export "params-id-break") (param i32) (result i32)
    (i32.const 1)
    (i32.const 2)
    (if (param i32 i32) (result i32 i32) (get_local 0) (then (br 0)))
    (i32.add)
  )

  (func (export "effects") (param i32) (result i32)
    (local i32)
    (if
      (block (result i32) (set_local 1 (i32.const 1)) (get_local 0))
      (then
        (set_local 1 (i32.mul (get_local 1) (i32.const 3)))
        (set_local 1 (i32.sub (get_local 1) (i32.const 5)))
        (set_local 1 (i32.mul (get_local 1) (i32.const 7)))
        (br 0)
        (set_local 1 (i32.mul (get_local 1) (i32.const 100)))
      )
      (else
        (set_local 1 (i32.mul (get_local 1) (i32.const 5)))
        (set_local 1 (i32.sub (get_local 1) (i32.const 7)))
        (set_local 1 (i32.mul (get_local 1) (i32.const 3)))
        (br 0)
        (set_local 1 (i32.mul (get_local 1) (i32.const 1000)))
      )
    )
    (get_local 1)
  )

  ;; Examples

  (func $add64_u_with_carry (export "add64_u_with_carry")
    (param $i i64) (param $j i64) (param $c i32) (result i64 i32)
    (local $k i64)
    (set_local $k
      (i64.add
        (i64.add (get_local $i) (get_local $j))
        (i64.extend_u/i32 (get_local $c))
      )
    )
    (return (get_local $k) (i64.lt_u (get_local $k) (get_local $i)))
  )

  (func $add64_u_saturated (export "add64_u_saturated")
    (param i64 i64) (result i64)
    (call $add64_u_with_carry (get_local 0) (get_local 1) (i32.const 0))
    (if (param i64) (result i64)
      (then (drop) (i64.const -1))
    )
  )

  ;; Block signature syntax

  (type $block-sig-1 (func))
  (type $block-sig-2 (func (result i32)))
  (type $block-sig-3 (func (param $x i32)))
  (type $block-sig-4 (func (param i32 f64 i32) (result i32 f64 i32)))

  (func (export "type-use")
    (if (type $block-sig-1) (i32.const 1) (then))
    (if (type $block-sig-2) (i32.const 1)
      (then (i32.const 0)) (else (i32.const 2))
    )
    (if (type $block-sig-3) (i32.const 1) (then (drop)) (else (drop)))
    (i32.const 0) (f64.const 0) (i32.const 0)
    (if (type $block-sig-4) (i32.const 1) (then))
    (drop) (drop) (drop)
    (if (type $block-sig-2) (result i32) (i32.const 1)
      (then (i32.const 0)) (else (i32.const 2))
    )
    (if (type $block-sig-3) (param i32) (i32.const 1)
      (then (drop)) (else (drop))
    )
    (i32.const 0) (f64.const 0) (i32.const 0)
    (if (type $block-sig-4)
      (param i32) (param f64 i32) (result i32 f64) (result i32)
      (i32.const 1) (then)
    )
    (drop) (drop) (drop)
  )
)

(assert_return (invoke "empty" (i32.const 0)))
(assert_return (invoke "empty" (i32.const 1)))
(assert_return (invoke "empty" (i32.const 100)))
(assert_return (invoke "empty" (i32.const -2)))

(assert_return (invoke "singular" (i32.const 0)) (i32.const 8))
(assert_return (invoke "singular" (i32.const 1)) (i32.const 7))
(assert_return (invoke "singular" (i32.const 10)) (i32.const 7))
(assert_return (invoke "singular" (i32.const -10)) (i32.const 7))

(assert_return (invoke "multi" (i32.const 0)) (i32.const 9) (i32.const -1))
(assert_return (invoke "multi" (i32.const 1)) (i32.const 8) (i32.const 1))
(assert_return (invoke "multi" (i32.const 13)) (i32.const 8) (i32.const 1))
(assert_return (invoke "multi" (i32.const -5)) (i32.const 8) (i32.const 1))

(assert_return (invoke "nested" (i32.const 0) (i32.const 0)) (i32.const 11))
(assert_return (invoke "nested" (i32.const 1) (i32.const 0)) (i32.const 10))
(assert_return (invoke "nested" (i32.const 0) (i32.const 1)) (i32.const 10))
(assert_return (invoke "nested" (i32.const 3) (i32.const 2)) (i32.const 9))
(assert_return (invoke "nested" (i32.const 0) (i32.const -100)) (i32.const 10))
(assert_return (invoke "nested" (i32.const 10) (i32.const 10)) (i32.const 9))
(assert_return (invoke "nested" (i32.const 0) (i32.const -1)) (i32.const 10))
(assert_return (invoke "nested" (i32.const -111) (i32.const -2)) (i32.const 9))

(assert_return (invoke "as-unary-operand" (i32.const 0)) (i32.const 0))
(assert_return (invoke "as-unary-operand" (i32.const 1)) (i32.const 0))
(assert_return (invoke "as-unary-operand" (i32.const -1)) (i32.const 0))

(assert_return (invoke "as-binary-operand" (i32.const 0) (i32.const 0)) (i32.const 15))
(assert_return (invoke "as-binary-operand" (i32.const 0) (i32.const 1)) (i32.const -12))
(assert_return (invoke "as-binary-operand" (i32.const 1) (i32.const 0)) (i32.const -15))
(assert_return (invoke "as-binary-operand" (i32.const 1) (i32.const 1)) (i32.const 12))

(assert_return (invoke "as-test-operand" (i32.const 0)) (i32.const 1))
(assert_return (invoke "as-test-operand" (i32.const 1)) (i32.const 0))

(assert_return (invoke "as-compare-operand" (i32.const 0) (i32.const 0)) (i32.const 1))
(assert_return (invoke "as-compare-operand" (i32.const 0) (i32.const 1)) (i32.const 0))
(assert_return (invoke "as-compare-operand" (i32.const 1) (i32.const 0)) (i32.const 1))
(assert_return (invoke "as-compare-operand" (i32.const 1) (i32.const 1)) (i32.const 0))

(assert_return (invoke "as-binary-operands" (i32.const 0)) (i32.const -12))
(assert_return (invoke "as-binary-operands" (i32.const 1)) (i32.const 12))

(assert_return (invoke "as-compare-operands" (i32.const 0)) (i32.const 1))
(assert_return (invoke "as-compare-operands" (i32.const 1)) (i32.const 0))

(assert_return (invoke "as-mixed-operands" (i32.const 0)) (i32.const -3))
(assert_return (invoke "as-mixed-operands" (i32.const 1)) (i32.const 27))

(assert_return (invoke "break-bare") (i32.const 19))
(assert_return (invoke "break-value" (i32.const 1)) (i32.const 18))
(assert_return (invoke "break-value" (i32.const 0)) (i32.const 21))
(assert_return (invoke "break-multi-value" (i32.const 0))
  (i32.const -18) (i32.const 18) (i64.const -18)
)
(assert_return (invoke "break-multi-value" (i32.const 1))
  (i32.const 18) (i32.const -18) (i64.const 18)
)

(assert_return (invoke "param" (i32.const 0)) (i32.const -1))
(assert_return (invoke "param" (i32.const 1)) (i32.const 3))
(assert_return (invoke "params" (i32.const 0)) (i32.const -1))
(assert_return (invoke "params" (i32.const 1)) (i32.const 3))
(assert_return (invoke "params-id" (i32.const 0)) (i32.const 3))
(assert_return (invoke "params-id" (i32.const 1)) (i32.const 3))
(assert_return (invoke "param-break" (i32.const 0)) (i32.const -1))
(assert_return (invoke "param-break" (i32.const 1)) (i32.const 3))
(assert_return (invoke "params-break" (i32.const 0)) (i32.const -1))
(assert_return (invoke "params-break" (i32.const 1)) (i32.const 3))
(assert_return (invoke "params-id-break" (i32.const 0)) (i32.const 3))
(assert_return (invoke "params-id-break" (i32.const 1)) (i32.const 3))

(assert_return (invoke "effects" (i32.const 1)) (i32.const -14))
(assert_return (invoke "effects" (i32.const 0)) (i32.const -6))

(assert_return
  (invoke "add64_u_with_carry" (i64.const 0) (i64.const 0) (i32.const 0))
  (i64.const 0) (i32.const 0)
)
(assert_return
  (invoke "add64_u_with_carry" (i64.const 100) (i64.const 124) (i32.const 0))
  (i64.const 224) (i32.const 0)
)
(assert_return
  (invoke "add64_u_with_carry" (i64.const -1) (i64.const 0) (i32.const 0))
  (i64.const -1) (i32.const 0)
)
(assert_return
  (invoke "add64_u_with_carry" (i64.const -1) (i64.const 1) (i32.const 0))
  (i64.const 0) (i32.const 1)
)
(assert_return
  (invoke "add64_u_with_carry" (i64.const -1) (i64.const -1) (i32.const 0))
  (i64.const -2) (i32.const 1)
)
(assert_return
  (invoke "add64_u_with_carry" (i64.const -1) (i64.const 0) (i32.const 1))
  (i64.const 0) (i32.const 1)
)
(assert_return
  (invoke "add64_u_with_carry" (i64.const -1) (i64.const 1) (i32.const 1))
  (i64.const 1) (i32.const 1)
)
(assert_return
  (invoke "add64_u_with_carry" (i64.const 0x8000000000000000) (i64.const 0x8000000000000000) (i32.const 0))
  (i64.const 0) (i32.const 1)
)

(assert_return
  (invoke "add64_u_saturated" (i64.const 0) (i64.const 0)) (i64.const 0)
)
(assert_return
  (invoke "add64_u_saturated" (i64.const 1230) (i64.const 23)) (i64.const 1253)
)
(assert_return
  (invoke "add64_u_saturated" (i64.const -1) (i64.const 0)) (i64.const -1)
)
(assert_return
  (invoke "add64_u_saturated" (i64.const -1) (i64.const 1)) (i64.const -1)
)
(assert_return
  (invoke "add64_u_saturated" (i64.const -1) (i64.const -1)) (i64.const -1)
)
(assert_return
  (invoke "add64_u_saturated" (i64.const 0x8000000000000000) (i64.const 0x8000000000000000)) (i64.const -1)
)

(assert_return (invoke "type-use"))

(assert_malformed
  (module quote
    "(type $sig (func (param i32) (result i32)))"
    "(func (i32.const 0)"
    "  (if (type $sig) (result i32) (param i32) (i32.const 1) (then))"
    ")"
  )
  "unexpected token"
)
(assert_malformed
  (module quote
    "(type $sig (func (param i32) (result i32)))"
    "(func (i32.const 0)"
    "  (if (param i32) (type $sig) (result i32) (i32.const 1) (then))"
    ")"
  )
  "unexpected token"
)
(assert_malformed
  (module quote
    "(type $sig (func (param i32) (result i32)))"
    "(func (i32.const 0)"
    "  (if (param i32) (result i32) (type $sig) (i32.const 1) (then))"
    ")"
  )
  "unexpected token"
)
(assert_malformed
  (module quote
    "(type $sig (func (param i32) (result i32)))"
    "(func (i32.const 0)"
    "  (if (result i32) (type $sig) (param i32) (i32.const 1) (then))"
    ")"
  )
  "unexpected token"
)
(assert_malformed
  (module quote
    "(type $sig (func (param i32) (result i32)))"
    "(func (i32.const 0)"
    "  (if (result i32) (param i32) (type $sig) (i32.const 1) (then))"
    ")"
  )
  "unexpected token"
)
(assert_malformed
  (module quote
    "(func (i32.const 0) (if (result i32) (param i32) (i32.const 1) (then)))"
  )
  "unexpected token"
)

(assert_malformed
  (module quote
    "(func (i32.const 0) (i32.const 1)"
    "  (if (param $x i32) (then (drop)) (else (drop)))"
    ")"
  )
  "unexpected token"
)
(assert_malformed
  (module quote
    "(type $sig (func))"
    "(func (i32.const 1)"
    "  (if (type $sig) (result i32) (then (i32.const 0)) (else (i32.const 2)))"
    "  (unreachable)"
    ")"
  )
  "inline function type"
)
(assert_malformed
  (module quote
    "(type $sig (func (param i32) (result i32)))"
    "(func (i32.const 1)"
    "  (if (type $sig) (result i32) (then (i32.const 0)) (else (i32.const 2)))"
    "  (unreachable)"
    ")"
  )
  "inline function type"
)
(assert_malformed
  (module quote
    "(type $sig (func (param i32) (result i32)))"
    "(func (i32.const 0) (i32.const 1)"
    "  (if (type $sig) (param i32) (then (drop)) (else (drop)))"
    "  (unreachable)"
    ")"
  )
  "inline function type"
)
(assert_malformed
  (module quote
    "(type $sig (func (param i32 i32) (result i32)))"
    "(func (i32.const 0) (i32.const 1)"
    "  (if (type $sig) (param i32) (result i32) (then)) (unreachable)"
    ")"
  )
  "inline function type"
)

(assert_invalid
  (module
    (type $sig (func))
    (func (i32.const 1) (if (type $sig) (i32.const 0) (then)))
  )
  "type mismatch"
)

(assert_invalid
  (module (func $type-empty-i32 (result i32) (if (i32.const 0) (then))))
  "type mismatch"
)
(assert_invalid
  (module (func $type-empty-i64 (result i64) (if (i32.const 0) (then))))
  "type mismatch"
)
(assert_invalid
  (module (func $type-empty-f32 (result f32) (if (i32.const 0) (then))))
  "type mismatch"
)
(assert_invalid
  (module (func $type-empty-f64 (result f64) (if (i32.const 0) (then))))
  "type mismatch"
)

(assert_invalid
  (module (func $type-empty-i32 (result i32) (if (i32.const 0) (then) (else))))
  "type mismatch"
)
(assert_invalid
  (module (func $type-empty-i64 (result i64) (if (i32.const 0) (then) (else))))
  "type mismatch"
)
(assert_invalid
  (module (func $type-empty-f32 (result f32) (if (i32.const 0) (then) (else))))
  "type mismatch"
)
(assert_invalid
  (module (func $type-empty-f64 (result f64) (if (i32.const 0) (then) (else))))
  "type mismatch"
)

(assert_invalid
  (module (func $type-then-value-num-vs-void
    (if (i32.const 1) (then (i32.const 1)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-then-value-num-vs-void-else
    (if (i32.const 1) (then (i32.const 1)) (else))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-else-value-num-vs-void
    (if (i32.const 1) (then) (else (i32.const 1)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-both-value-num-vs-void
    (if (i32.const 1) (then (i32.const 1)) (else (i32.const 1)))
  ))
  "type mismatch"
)

(assert_invalid
  (module (func $type-then-value-nums-vs-void
    (if (i32.const 1) (then (i32.const 1) (i32.const 2)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-then-value-nums-vs-void-else
    (if (i32.const 1) (then (i32.const 1) (i32.const 2)) (else))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-else-value-nums-vs-void
    (if (i32.const 1) (then) (else (i32.const 1) (i32.const 2)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-both-value-nums-vs-void
    (if (i32.const 1) (then (i32.const 1) (i32.const 2)) (else (i32.const 2) (i32.const 1)))
  ))
  "type mismatch"
)

(assert_invalid
  (module (func $type-then-value-empty-vs-num (result i32)
    (if (result i32) (i32.const 1) (then) (else (i32.const 0)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-else-value-empty-vs-num (result i32)
    (if (result i32) (i32.const 1) (then (i32.const 0)) (else))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-both-value-empty-vs-num (result i32)
    (if (result i32) (i32.const 1) (then) (else))
  ))
  "type mismatch"
)

(assert_invalid
  (module (func $type-then-value-empty-vs-nums (result i32 i32)
    (if (result i32 i32) (i32.const 1) (then) (else (i32.const 0) (i32.const 2)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-else-value-empty-vs-nums (result i32 i32)
    (if (result i32 i32) (i32.const 1) (then (i32.const 0) (i32.const 1)) (else))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-both-value-empty-vs-nums (result i32 i32)
    (if (result i32 i32) (i32.const 1) (then) (else))
  ))
  "type mismatch"
)

(assert_invalid
  (module (func $type-no-else-vs-num (result i32)
    (if (result i32) (i32.const 1) (then (i32.const 1)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-no-else-vs-nums (result i32 i32)
    (if (result i32 i32) (i32.const 1) (then (i32.const 1) (i32.const 1)))
  ))
  "type mismatch"
)

(assert_invalid
  (module (func $type-then-value-void-vs-num (result i32)
    (if (result i32) (i32.const 1) (then (nop)) (else (i32.const 0)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-else-value-void-vs-num (result i32)
    (if (result i32) (i32.const 1) (then (i32.const 0)) (else (nop)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-both-value-void-vs-num (result i32)
    (if (result i32) (i32.const 1) (then (nop)) (else (nop)))
  ))
  "type mismatch"
)

(assert_invalid
  (module (func $type-then-value-void-vs-nums (result i32 i32)
    (if (result i32 i32) (i32.const 1) (then (nop)) (else (i32.const 0) (i32.const 0)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-else-value-void-vs-nums (result i32 i32)
    (if (result i32 i32) (i32.const 1) (then (i32.const 0) (i32.const 0)) (else (nop)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-both-value-void-vs-nums (result i32 i32)
    (if (result i32 i32) (i32.const 1) (then (nop)) (else (nop)))
  ))
  "type mismatch"
)

(assert_invalid
  (module (func $type-then-value-num-vs-num (result i32)
    (if (result i32) (i32.const 1) (then (i64.const 1)) (else (i32.const 1)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-else-value-num-vs-num (result i32)
    (if (result i32) (i32.const 1) (then (i32.const 1)) (else (i64.const 1)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-both-value-num-vs-num (result i32)
    (if (result i32) (i32.const 1) (then (i64.const 1)) (else (i64.const 1)))
  ))
  "type mismatch"
)

(assert_invalid
  (module (func $type-then-value-num-vs-nums (result i32 i32)
    (if (result i32 i32) (i32.const 1) (then (i32.const 1)) (else (i32.const 1) (i32.const 1)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-else-value-num-vs-nums (result i32 i32)
    (if (result i32 i32) (i32.const 1) (then (i32.const 1) (i32.const 1)) (else (i32.const 1)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-both-value-num-vs-nums (result i32 i32)
    (if (result i32 i32) (i32.const 1) (then (i32.const 1)) (else (i32.const 1)))
  ))
  "type mismatch"
)

(assert_invalid
  (module (func $type-then-value-partial-vs-nums (result i32 i32)
    (i32.const 0)
    (if (result i32 i32) (i32.const 1) (then (i32.const 1)) (else (i32.const 1) (i32.const 1)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-else-value-partial-vs-nums (result i32 i32)
    (i32.const 0)
    (if (result i32 i32) (i32.const 1) (then (i32.const 1) (i32.const 1)) (else (i32.const 1)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-both-value-partial-vs-nums (result i32 i32)
    (i32.const 0)
    (if (result i32 i32) (i32.const 1) (then (i32.const 1)) (else (i32.const 1)))
  ))
  "type mismatch"
)

(assert_invalid
  (module (func $type-then-value-nums-vs-num (result i32)
    (if (result i32) (i32.const 1) (then (i32.const 1) (i32.const 1)) (else (i32.const 1)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-else-value-nums-vs-num (result i32)
    (if (result i32) (i32.const 1) (then (i32.const 1)) (else (i32.const 1) (i32.const 1)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-both-value-nums-vs-num (result i32)
    (if (result i32) (i32.const 1) (then (i32.const 1) (i32.const 1)) (else (i32.const 1) (i32.const 1)))
  ))
  "type mismatch"
)

(assert_invalid
  (module (func $type-both-different-value-num-vs-num (result i32)
    (if (result i32) (i32.const 1) (then (i64.const 1)) (else (f64.const 1)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-both-different-value-nums-vs-nums (result i32 i32)
    (if (result i32 i32) (i32.const 1) (then (i32.const 1) (i32.const 1) (i32.const 1)) (else (i32.const 1)))
  ))
  "type mismatch"
)

(assert_invalid
  (module (func $type-then-value-unreached-select (result i32)
    (if (result i64)
      (i32.const 0)
      (then (select (unreachable) (unreachable) (unreachable)))
      (else (i64.const 0))
    )
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-else-value-unreached-select (result i32)
    (if (result i64)
      (i32.const 1)
      (then (i64.const 0))
      (else (select (unreachable) (unreachable) (unreachable)))
    )
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-else-value-unreached-select (result i32)
    (if (result i64)
      (i32.const 1)
      (then (select (unreachable) (unreachable) (unreachable)))
      (else (select (unreachable) (unreachable) (unreachable)))
    )
  ))
  "type mismatch"
)

(assert_invalid
  (module (func $type-then-break-last-void-vs-num (result i32)
    (if (result i32) (i32.const 1) (then (br 0)) (else (i32.const 1)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-else-break-last-void-vs-num (result i32)
    (if (result i32) (i32.const 1) (then (i32.const 1)) (else (br 0)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-then-break-last-void-vs-nums (result i32 i32)
    (if (result i32 i32) (i32.const 1) (then (br 0)) (else (i32.const 1) (i32.const 1)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-else-break-last-void-vs-nums (result i32 i32)
    (if (result i32 i32) (i32.const 1) (then (i32.const 1) (i32.const 1)) (else (br 0)))
  ))
  "type mismatch"
)

(assert_invalid
  (module (func $type-then-break-empty-vs-num (result i32)
    (if (result i32) (i32.const 1)
      (then (br 0) (i32.const 1))
      (else (i32.const 1))
    )
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-else-break-empty-vs-num (result i32)
    (if (result i32) (i32.const 1)
      (then (i32.const 1))
      (else (br 0) (i32.const 1))
    )
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-then-break-empty-vs-nums (result i32 i32)
    (if (result i32 i32) (i32.const 1)
      (then (br 0) (i32.const 1) (i32.const 1))
      (else (i32.const 1) (i32.const 1))
    )
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-else-break-empty-vs-nums (result i32 i32)
    (if (result i32 i32) (i32.const 1)
      (then (i32.const 1) (i32.const 1))
      (else (br 0) (i32.const 1) (i32.const 1))
    )
  ))
  "type mismatch"
)

(assert_invalid
  (module (func $type-then-break-void-vs-num (result i32)
    (if (result i32) (i32.const 1)
      (then (br 0 (nop)) (i32.const 1))
      (else (i32.const 1))
    )
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-else-break-void-vs-num (result i32)
    (if (result i32) (i32.const 1)
      (then (i32.const 1))
      (else (br 0 (nop)) (i32.const 1))
    )
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-then-break-void-vs-nums (result i32 i32)
    (if (result i32 i32) (i32.const 1)
      (then (br 0 (nop)) (i32.const 1) (i32.const 1))
      (else (i32.const 1) (i32.const 1))
    )
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-else-break-void-vs-nums (result i32 i32)
    (if (result i32 i32) (i32.const 1)
      (then (i32.const 1) (i32.const 1))
      (else (br 0 (nop)) (i32.const 1) (i32.const 1))
    )
  ))
  "type mismatch"
)

(assert_invalid
  (module (func $type-then-break-num-vs-num (result i32)
    (if (result i32) (i32.const 1)
      (then (br 0 (i64.const 1)) (i32.const 1))
      (else (i32.const 1))
    )
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-else-break-num-vs-num (result i32)
    (if (result i32) (i32.const 1)
      (then (i32.const 1))
      (else (br 0 (i64.const 1)) (i32.const 1))
    )
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-then-break-num-vs-nums (result i32 i32)
    (if (result i32 i32) (i32.const 1)
      (then (br 0 (i64.const 1)) (i32.const 1) (i32.const 1))
      (else (i32.const 1) (i32.const 1))
    )
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-else-break-num-vs-nums (result i32 i32)
    (if (result i32 i32) (i32.const 1)
      (then (i32.const 1) (i32.const 1))
      (else (br 0 (i64.const 1)) (i32.const 1) (i32.const 1))
    )
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-then-break-partial-vs-nums (result i32 i32)
    (i32.const 1)
    (if (result i32 i32) (i32.const 1)
      (then (br 0 (i64.const 1)) (i32.const 1))
      (else (i32.const 1))
    )
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-else-break-partial-vs-nums (result i32 i32)
    (i32.const 1)
    (if (result i32 i32) (i32.const 1)
      (then (i32.const 1))
      (else (br 0 (i64.const 1)) (i32.const 1))
    )
  ))
  "type mismatch"
)

(assert_invalid
  (module (func $type-param-void-vs-num
    (if (param i32) (i32.const 1) (then (drop)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-param-void-vs-nums
    (if (param i32 f64) (i32.const 1) (then (drop) (drop)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-param-num-vs-num
    (f32.const 0) (if (param i32) (i32.const 1) (then (drop)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-param-num-vs-nums
    (f32.const 0) (if (param f32 i32) (i32.const 1) (then (drop) (drop)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-param-nested-void-vs-num
    (block (if (param i32) (i32.const 1) (then (drop))))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-param-void-vs-nums
    (block (if (param i32 f64) (i32.const 1) (then (drop) (drop))))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-param-num-vs-num
    (block (f32.const 0) (if (param i32) (i32.const 1) (then (drop))))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-param-num-vs-nums
    (block (f32.const 0) (if (param f32 i32) (i32.const 1) (then (drop) (drop))))
  ))
  "type mismatch"
)

(assert_malformed
  (module quote "(func (param i32) (result i32) if (param $x i32) end)")
  "unexpected token"
)
(assert_malformed
  (module quote "(func (param i32) (result i32) (if (param $x i32) (then)))")
  "unexpected token"
)

(assert_malformed
  (module quote "(func if end $l)")
  "mismatching label"
)
(assert_malformed
  (module quote "(func if $a end $l)")
  "mismatching label"
)
(assert_malformed
  (module quote "(func if else $l end)")
  "mismatching label"
)
(assert_malformed
  (module quote "(func if $a else $l end)")
  "mismatching label"
)
(assert_malformed
  (module quote "(func if else end $l)")
  "mismatching label"
)
(assert_malformed
  (module quote "(func if else $l end $l)")
  "mismatching label"
)
(assert_malformed
  (module quote "(func if else $l1 end $l2)")
  "mismatching label"
)
(assert_malformed
  (module quote "(func if $a else end $l)")
  "mismatching label"
)
(assert_malformed
  (module quote "(func if $a else $a end $l)")
  "mismatching label"
)
(assert_malformed
  (module quote "(func if $a else $l end $l)")
  "mismatching label"
)
