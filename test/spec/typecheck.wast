;; TODO: move all tests in this file to appropriate operator-specific files.

(assert_invalid
  (module (func $type-unary-operand-missing
    (i32.eqz) (drop)
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-unary-operand-missing-in-block
    (i32.const 0)
    (block (i32.eqz) (drop))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-unary-operand-missing-in-loop
   (i32.const 0)
   (loop (i32.eqz) (drop))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-unary-operand-missing-in-if
    (i32.const 0) (i32.const 0)
    (if (then (i32.eqz) (drop)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-unary-operand-missing-in-else
    (i32.const 0) (i32.const 0)
    (if i32 (then (i32.const 0)) (else (i32.eqz))) (drop)
  ))
  "type mismatch"
)

(assert_invalid
  (module (func $type-binary-1st-operand-missing
    (i32.add) (drop)
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-binary-2nd-operand-missing
    (i32.const 0) (i32.add) (drop)
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-binary-1st-operand-missing-in-block
    (i32.const 0) (i32.const 0)
    (block (i32.add) (drop))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-binary-2nd-operand-missing-in-block
    (i32.const 0)
    (block (i32.const 0) (i32.add) (drop))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-binary-1st-operand-missing-in-loop
    (i32.const 0) (i32.const 0)
    (loop (i32.add) (drop))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-binary-2nd-operand-missing-in-loop
    (i32.const 0)
    (loop (i32.const 0) (i32.add) (drop))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-binary-1st-operand-missing-in-if
    (i32.const 0) (i32.const 0) (i32.const 0)
    (if (i32.add) (drop))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-binary-2nd-operand-missing-in-if
    (i32.const 0) (i32.const 0)
    (if (i32.const 0) (i32.add) (drop))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-binary-1st-operand-missing-in-else
    (i32.const 0) (i32.const 0) (i32.const 0)
    (if i32 (then (i32.const 0)) (else (i32.add) (i32.const 0)))
    (drop) (drop)
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-binary-2nd-operand-missing-in-else
    (i32.const 0) (i32.const 0)
    (if i32 (then (i32.const 0)) (else (i32.add)))
    (drop)
  ))
  "type mismatch"
)

(assert_invalid
  (module (func $type-if-operand-missing
    (if (then))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-if-operand-missing-in-block
    (i32.const 0)
    (block (if (then)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-if-operand-missing-in-loop
    (i32.const 0)
    (loop (if (then)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-if-operand-missing-in-if
    (i32.const 0) (i32.const 0)
    (if (then (if (then))))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-if-operand-missing-in-else
    (i32.const 0) (i32.const 0)
    (if i32 (then (i32.const 0)) (else (if (then)) (i32.const 0)))
    (drop)
  ))
  "type mismatch"
)

(assert_invalid
  (module (func $type-br-operand-missing
    (block i32 (br 0))
    (i32.eqz) (drop)
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-br-operand-missing-in-block
    (i32.const 0)
    (block i32 (br 0))
    (i32.eqz) (drop)
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-br-operand-missing-in-loop
    (i32.const 0)
    (loop i32 (br 0))
    (i32.eqz) (drop)
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-br-operand-missing-in-if
    (block
      (i32.const 0) (i32.const 0)
      (if i32 (then (br 0)))
    )
    (i32.eqz) (drop)
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-br-operand-missing-in-else
    (block
      (i32.const 0) (i32.const 0)
      (if i32 (then (i32.const 0)) (else (br 0)))
    )
    (i32.eqz) (drop)
  ))
  "type mismatch"
)

(assert_invalid
  (module (func $type-return-operand-missing (result i32)
    (return)
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-return-operand-missing-in-block (result i32)
    (i32.const 0)
    (block (return))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-return-operand-missing-in-loop (result i32)
    (i32.const 0)
    (loop (return))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-return-operand-missing-in-if (result i32)
    (i32.const 0) (i32.const 0)
    (if (then (return)))
  ))
  "type mismatch"
)
(assert_invalid
  (module (func $type-return-operand-missing-in-else (result i32)
    (i32.const 0) (i32.const 0)
    (if i32 (then (i32.const 0)) (else (return))) (drop)
  ))
  "type mismatch"
)

;; TODO(stack): more of the above

;; if condition
(assert_invalid (module (func (if (f32.const 0) (nop) (nop)))) "type mismatch")

;; br_if condition
(assert_invalid (module (func (block (br_if 0 (f32.const 0))))) "type mismatch")

;; br_table key
(assert_invalid
  (module (func (block (br_table 0 (f32.const 0)))))
  "type mismatch")

;; call params
(assert_invalid (module (func (param i32)) (func (call 0 (f32.const 0)))) "type mismatch")
(assert_invalid
  (module
    (type (func (param i32)))
    (func (type 0))
    (table 0 funcref)
    (func
      (call_indirect (type 0) (i32.const 0) (f32.const 0))))
  "type mismatch")

;; call_indirect (type index)
(assert_invalid
  (module
    (type (func))
    (func (type 0))
    (table 0 funcref)
    (func (call_indirect (type 0) (f32.const 0))))
  "type mismatch")

;; return
(assert_invalid (module (func (result i32) (return (f32.const 0)))) "type mismatch")

;; local.set
(assert_invalid (module (func (local i32) (local.set 0 (f32.const 0)))) "type mismatch")

;; load index
(assert_invalid (module (memory 1) (func (i32.load (f32.const 0)))) "type mismatch")
(assert_invalid (module (memory 1) (func (i32.load8_s (f32.const 0)))) "type mismatch")
(assert_invalid (module (memory 1) (func (i32.load8_u (f32.const 0)))) "type mismatch")
(assert_invalid (module (memory 1) (func (i32.load16_s (f32.const 0)))) "type mismatch")
(assert_invalid (module (memory 1) (func (i32.load16_u (f32.const 0)))) "type mismatch")
(assert_invalid (module (memory 1) (func (i64.load (f32.const 0)))) "type mismatch")
(assert_invalid (module (memory 1) (func (i64.load8_s (f32.const 0)))) "type mismatch")
(assert_invalid (module (memory 1) (func (i64.load8_u (f32.const 0)))) "type mismatch")
(assert_invalid (module (memory 1) (func (i64.load16_s (f32.const 0)))) "type mismatch")
(assert_invalid (module (memory 1) (func (i64.load16_u (f32.const 0)))) "type mismatch")
(assert_invalid (module (memory 1) (func (i64.load32_s (f32.const 0)))) "type mismatch")
(assert_invalid (module (memory 1) (func (i64.load32_u (f32.const 0)))) "type mismatch")
(assert_invalid (module (memory 1) (func (f32.load (f32.const 0)))) "type mismatch")
(assert_invalid (module (memory 1) (func (f64.load (f32.const 0)))) "type mismatch")

;; store index
(assert_invalid (module (memory 1) (func (i32.store (f32.const 0) (i32.const 0)))) "type mismatch")
(assert_invalid (module (memory 1) (func (i32.store8 (f32.const 0) (i32.const 0)))) "type mismatch")
(assert_invalid (module (memory 1) (func (i32.store16 (f32.const 0) (i32.const 0)))) "type mismatch")
(assert_invalid (module (memory 1) (func (i64.store (f32.const 0) (i32.const 0)))) "type mismatch")
(assert_invalid (module (memory 1) (func (i64.store8 (f32.const 0) (i64.const 0)))) "type mismatch")
(assert_invalid (module (memory 1) (func (i64.store16 (f32.const 0) (i64.const 0)))) "type mismatch")
(assert_invalid (module (memory 1) (func (i64.store32 (f32.const 0) (i64.const 0)))) "type mismatch")
(assert_invalid (module (memory 1) (func (f32.store (f32.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (memory 1) (func (f64.store (f32.const 0) (f64.const 0)))) "type mismatch")

;; store value
(assert_invalid (module (memory 1) (func (i32.store (i32.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (memory 1) (func (i32.store8 (i32.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (memory 1) (func (i32.store16 (i32.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (memory 1) (func (i64.store (i32.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (memory 1) (func (i64.store8 (i32.const 0) (f64.const 0)))) "type mismatch")
(assert_invalid (module (memory 1) (func (i64.store16 (i32.const 0) (f64.const 0)))) "type mismatch")
(assert_invalid (module (memory 1) (func (i64.store32 (i32.const 0) (f64.const 0)))) "type mismatch")
(assert_invalid (module (memory 1) (func (f32.store (i32.const 0) (i32.const 0)))) "type mismatch")
(assert_invalid (module (memory 1) (func (f64.store (i32.const 0) (i64.const 0)))) "type mismatch")

;; binary
(assert_invalid (module (func (i32.add (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i32.and (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i32.div_s (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i32.div_u (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i32.mul (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i32.or (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i32.rem_s (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i32.rem_u (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i32.rotl (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i32.rotr (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i32.shl (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i32.shr_s (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i32.shr_u (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i32.sub (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i32.xor (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.add (i32.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.and (i32.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.div_s (i32.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.div_u (i32.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.mul (i32.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.or (i32.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.rem_s (i32.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.rem_u (i32.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.rotl (i32.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.rotr (i32.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.shl (i32.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.shr_s (i32.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.shr_u (i32.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.sub (i32.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.xor (i32.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (f32.add (i64.const 0) (f64.const 0)))) "type mismatch")
(assert_invalid (module (func (f32.copysign (i64.const 0) (f64.const 0)))) "type mismatch")
(assert_invalid (module (func (f32.div (i64.const 0) (f64.const 0)))) "type mismatch")
(assert_invalid (module (func (f32.max (i64.const 0) (f64.const 0)))) "type mismatch")
(assert_invalid (module (func (f32.min (i64.const 0) (f64.const 0)))) "type mismatch")
(assert_invalid (module (func (f32.mul (i64.const 0) (f64.const 0)))) "type mismatch")
(assert_invalid (module (func (f32.sub (i64.const 0) (f64.const 0)))) "type mismatch")
(assert_invalid (module (func (f64.add (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (f64.copysign (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (f64.div (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (f64.max (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (f64.min (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (f64.mul (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (f64.sub (i64.const 0) (f32.const 0)))) "type mismatch")

;; unary
(assert_invalid (module (func (i32.eqz (i64.const 0)))) "type mismatch")
(assert_invalid (module (func (i32.clz (i64.const 0)))) "type mismatch")
(assert_invalid (module (func (i32.ctz (i64.const 0)))) "type mismatch")
(assert_invalid (module (func (i32.popcnt (i64.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.eqz (i32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.clz (i32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.ctz (i32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.popcnt (i32.const 0)))) "type mismatch")
(assert_invalid (module (func (f32.abs (i64.const 0)))) "type mismatch")
(assert_invalid (module (func (f32.ceil (i64.const 0)))) "type mismatch")
(assert_invalid (module (func (f32.floor (i64.const 0)))) "type mismatch")
(assert_invalid (module (func (f32.nearest (i64.const 0)))) "type mismatch")
(assert_invalid (module (func (f32.neg (i64.const 0)))) "type mismatch")
(assert_invalid (module (func (f32.sqrt (i64.const 0)))) "type mismatch")
(assert_invalid (module (func (f32.trunc (i64.const 0)))) "type mismatch")
(assert_invalid (module (func (f64.abs (i64.const 0)))) "type mismatch")
(assert_invalid (module (func (f64.ceil (i64.const 0)))) "type mismatch")
(assert_invalid (module (func (f64.floor (i64.const 0)))) "type mismatch")
(assert_invalid (module (func (f64.nearest (i64.const 0)))) "type mismatch")
(assert_invalid (module (func (f64.neg (i64.const 0)))) "type mismatch")
(assert_invalid (module (func (f64.sqrt (i64.const 0)))) "type mismatch")
(assert_invalid (module (func (f64.trunc (i64.const 0)))) "type mismatch")

;; compare
(assert_invalid (module (func (i32.eq (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i32.ge_s (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i32.ge_u (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i32.gt_s (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i32.gt_u (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i32.le_s (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i32.le_u (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i32.lt_s (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i32.lt_u (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i32.ne (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.eq (i32.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.ge_s (i32.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.ge_u (i32.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.gt_s (i32.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.gt_u (i32.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.le_s (i32.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.le_u (i32.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.lt_s (i32.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.lt_u (i32.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.ne (i32.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (f32.eq (i64.const 0) (f64.const 0)))) "type mismatch")
(assert_invalid (module (func (f32.ge (i64.const 0) (f64.const 0)))) "type mismatch")
(assert_invalid (module (func (f32.gt (i64.const 0) (f64.const 0)))) "type mismatch")
(assert_invalid (module (func (f32.le (i64.const 0) (f64.const 0)))) "type mismatch")
(assert_invalid (module (func (f32.lt (i64.const 0) (f64.const 0)))) "type mismatch")
(assert_invalid (module (func (f32.ne (i64.const 0) (f64.const 0)))) "type mismatch")
(assert_invalid (module (func (f64.eq (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (f64.ge (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (f64.gt (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (f64.le (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (f64.lt (i64.const 0) (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (f64.ne (i64.const 0) (f32.const 0)))) "type mismatch")

;; convert
(assert_invalid (module (func (i32.wrap_i64 (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i32.trunc_f32_s (i64.const 0)))) "type mismatch")
(assert_invalid (module (func (i32.trunc_f32_u (i64.const 0)))) "type mismatch")
(assert_invalid (module (func (i32.trunc_f64_s (i64.const 0)))) "type mismatch")
(assert_invalid (module (func (i32.trunc_f64_u (i64.const 0)))) "type mismatch")
(assert_invalid (module (func (i32.reinterpret_f32 (i64.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.extend_i32_s (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.extend_i32_u (f32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.trunc_f32_s (i32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.trunc_f32_u (i32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.trunc_f64_s (i32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.trunc_f64_u (i32.const 0)))) "type mismatch")
(assert_invalid (module (func (i64.reinterpret_f64 (i32.const 0)))) "type mismatch")
(assert_invalid (module (func (f32.convert_i32_s (i64.const 0)))) "type mismatch")
(assert_invalid (module (func (f32.convert_i32_u (i64.const 0)))) "type mismatch")
(assert_invalid (module (func (f32.convert_i64_s (i32.const 0)))) "type mismatch")
(assert_invalid (module (func (f32.convert_i64_u (i32.const 0)))) "type mismatch")
(assert_invalid (module (func (f32.demote_f64 (i32.const 0)))) "type mismatch")
(assert_invalid (module (func (f32.reinterpret_i32 (i64.const 0)))) "type mismatch")
(assert_invalid (module (func (f64.convert_i32_s (i64.const 0)))) "type mismatch")
(assert_invalid (module (func (f64.convert_i32_u (i64.const 0)))) "type mismatch")
(assert_invalid (module (func (f64.convert_i64_s (i32.const 0)))) "type mismatch")
(assert_invalid (module (func (f64.convert_i64_u (i32.const 0)))) "type mismatch")
(assert_invalid (module (func (f64.promote_f32 (i32.const 0)))) "type mismatch")
(assert_invalid (module (func (f64.reinterpret_i64 (i32.const 0)))) "type mismatch")

;; grow_memory
(assert_invalid (module (memory 1) (func (grow_memory (f32.const 0)))) "type mismatch")
