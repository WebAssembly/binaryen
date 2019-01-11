;; Test `block` operator

(module
  ;; Auxiliary definition
  (func $dummy)

  (func (export "empty")
    (block)
    (block $l)
  )

  (func (export "singular") (result i32)
    (block (nop))
    (block i32 (i32.const 7))
  )

  (func (export "multi") (result i32)
    (block (call $dummy) (call $dummy) (call $dummy) (call $dummy))
    (block i32 (call $dummy) (call $dummy) (call $dummy) (i32.const 8))
  )

  (func (export "nested") (result i32)
    (block i32
      (block (call $dummy) (block) (nop))
      (block i32 (call $dummy) (i32.const 9))
    )
  )

  (func (export "deep") (result i32)
    (block i32 (block i32 (block i32 (block i32 (block i32 (block i32
      (block i32 (block i32 (block i32 (block i32 (block i32 (block i32
        (block i32 (block i32 (block i32 (block i32 (block i32 (block i32
          (block i32 (block i32 (block i32 (block i32 (block i32 (block i32
            (block i32 (block i32 (block i32 (block i32 (block i32 (block i32
              (block i32 (block i32 (block i32 (block i32 (block i32 (block i32
                (block i32 (block i32 (call $dummy) (i32.const 150)))
              ))))))
            ))))))
          ))))))
        ))))))
      ))))))
    ))))))
  )

  (func (export "as-unary-operand") (result i32)
    (i32.ctz (block i32 (call $dummy) (i32.const 13)))
  )
  (func (export "as-binary-operand") (result i32)
    (i32.mul
      (block i32 (call $dummy) (i32.const 3))
      (block i32 (call $dummy) (i32.const 4))
    )
  )
  (func (export "as-test-operand") (result i32)
    (i32.eqz (block i32 (call $dummy) (i32.const 13)))
  )
  (func (export "as-compare-operand") (result i32)
    (f32.gt
      (block f32 (call $dummy) (f32.const 3))
      (block f32 (call $dummy) (f32.const 3))
    )
  )

  (func (export "break-bare") (result i32)
    (block (br 0) (unreachable))
    (block (br_if 0 (i32.const 1)) (unreachable))
    (block (br_table 0 (i32.const 0)) (unreachable))
    (block (br_table 0 0 0 (i32.const 1)) (unreachable))
    (i32.const 19)
  )
  (func (export "break-value") (result i32)
    (block i32 (br 0 (i32.const 18)) (i32.const 19))
  )
  (func (export "break-repeated") (result i32)
    (block i32
      (br 0 (i32.const 18))
      (br 0 (i32.const 19))
      (drop (br_if 0 (i32.const 20) (i32.const 0)))
      (drop (br_if 0 (i32.const 20) (i32.const 1)))
      (br 0 (i32.const 21))
      (br_table 0 (i32.const 22) (i32.const 4))
      (br_table 0 0 0 (i32.const 23) (i32.const 1))
      (i32.const 21)
    )
  )
  (func (export "break-inner") (result i32)
    (local i32)
    (local.set 0 (i32.const 0))
    (local.set 0 (i32.add (local.get 0) (block i32 (block i32 (br 1 (i32.const 0x1))))))
    (local.set 0 (i32.add (local.get 0) (block i32 (block (br 0)) (i32.const 0x2))))
    (local.set 0
      (i32.add (local.get 0) (block i32 (i32.ctz (br 0 (i32.const 0x4)))))
    )
    (local.set 0
      (i32.add (local.get 0) (block i32 (i32.ctz (block i32 (br 1 (i32.const 0x8))))))
    )
    (local.get 0)
  )

  (func (export "effects") (result i32)
    (local i32)
    (block
      (local.set 0 (i32.const 1))
      (local.set 0 (i32.mul (local.get 0) (i32.const 3)))
      (local.set 0 (i32.sub (local.get 0) (i32.const 5)))
      (local.set 0 (i32.mul (local.get 0) (i32.const 7)))
      (br 0)
      (local.set 0 (i32.mul (local.get 0) (i32.const 100)))
    )
    (i32.eq (local.get 0) (i32.const -14))
  )
)

(assert_return (invoke "empty"))
(assert_return (invoke "singular") (i32.const 7))
(assert_return (invoke "multi") (i32.const 8))
(assert_return (invoke "nested") (i32.const 9))
(assert_return (invoke "deep") (i32.const 150))

(assert_return (invoke "as-unary-operand") (i32.const 0))
(assert_return (invoke "as-binary-operand") (i32.const 12))
(assert_return (invoke "as-test-operand") (i32.const 0))
(assert_return (invoke "as-compare-operand") (i32.const 0))

(assert_return (invoke "break-bare") (i32.const 19))
(assert_return (invoke "break-value") (i32.const 18))
(assert_return (invoke "break-repeated") (i32.const 18))
(assert_return (invoke "break-inner") (i32.const 0xf))

(assert_return (invoke "effects") (i32.const 1))

(assert_invalid
  (module (func $type-empty-i32 (result i32) (block)))
  "type mismatch"
)
(assert_invalid
  (module (func $type-empty-i64 (result i64) (block)))
  "type mismatch"
)
(assert_invalid
  (module (func $type-empty-f32 (result f32) (block)))
  "type mismatch"
)
(assert_invalid
  (module (func $type-empty-f64 (result f64) (block)))
  "type mismatch"
)

(assert_invalid
  (module (func $type-value-num-vs-void
    (block (i32.const 1))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-value-void-vs-num (result i32)
    (block (nop))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-value-num-vs-num (result i32)
    (block (f32.const 0))
  ))
  "type mismatch"
)

(; TODO(stack): soft failure
(assert_invalid
  (module (func $type-value-num-vs-void-after-break
    (block (br 0) (i32.const 1))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-value-void-vs-num-after-break (result i32)
    (block (i32.const 1) (br 0) (nop))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-value-num-vs-num-after-break (result i32)
    (block (i32.const 1) (br 0) (f32.const 0))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-break-second-void-vs-num (result i32)
    (block i32 (br 0 (i32.const 1)) (br 0 (nop)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-break-second-num-vs-num (result i32)
    (block i32 (br 0 (i32.const 1)) (br 0 (f64.const 1)))
  ))
  "type mismatch"
)
;)

(assert_invalid
  (module (func $type-break-last-void-vs-num (result i32)
    (block i32 (br 0))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-break-void-vs-num (result i32)
    (block i32 (br 0) (i32.const 1))
  ))
  "type mismatch"
)

(assert_invalid
  (module (func $type-break-void-vs-num (result i32)
    (block (br 0 (nop)) (i32.const 1))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-break-num-vs-num (result i32)
    (block (br 0 (i64.const 1)) (i32.const 1))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-break-first-void-vs-num (result i32)
    (block (br 0 (nop)) (br 0 (i32.const 1)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-break-first-num-vs-num (result i32)
    (block (br 0 (i64.const 1)) (br 0 (i32.const 1)))
  ))
  "type mismatch"
)

(assert_invalid
  (module (func $type-break-nested-num-vs-void
    (block i32 (block i32 (br 1 (i32.const 1))) (br 0))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-break-nested-empty-vs-num (result i32)
    (block (block (br 1)) (br 0 (i32.const 1)))
  ))
  "type mismatch"
)

(assert_invalid
  (module (func $type-break-nested-void-vs-num (result i32)
    (block (block (br 1 (nop))) (br 0 (i32.const 1)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-break-nested-num-vs-num (result i32)
    (block (block (br 1 (i64.const 1))) (br 0 (i32.const 1)))
  ))
  "type mismatch"
)

(assert_invalid
  (module (func $type-break-operand-empty-vs-num (result i32)
    (i32.ctz (block (br 0)))
  ))
  "type mismatch"
)

(assert_invalid
  (module (func $type-break-operand-void-vs-num (result i32)
    (i64.ctz (block (br 0 (nop))))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-break-operand-num-vs-num (result i32)
    (i64.ctz (block (br 0 (i64.const 9))))
  ))
  "type mismatch"
)

