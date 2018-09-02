;; Test that traps are preserved even in instructions which might otherwise
;; be dead-code-eliminated. These functions all perform an operation and
;; discard its return value.

(module
  (func (export "no_dce.i32.div_s") (param $x i32) (param $y i32) (result i32)
    (i32.div_s (get_local $x) (get_local $y)))
  (func (export "no_dce.i32.div_u") (param $x i32) (param $y i32) (result i32)
    (i32.div_u (get_local $x) (get_local $y)))
  (func (export "no_dce.i64.div_s") (param $x i64) (param $y i64) (result i64)
    (i64.div_s (get_local $x) (get_local $y)))
  (func (export "no_dce.i64.div_u") (param $x i64) (param $y i64) (result i64)
    (i64.div_u (get_local $x) (get_local $y)))
)

(assert_trap (invoke "no_dce.i32.div_s" (i32.const 1) (i32.const 0)) "integer divide by zero")
(assert_trap (invoke "no_dce.i32.div_u" (i32.const 1) (i32.const 0)) "integer divide by zero")
(assert_trap (invoke "no_dce.i64.div_s" (i64.const 1) (i64.const 0)) "integer divide by zero")
(assert_trap (invoke "no_dce.i64.div_u" (i64.const 1) (i64.const 0)) "integer divide by zero")

(module
  (func (export "no_dce.i32.rem_s") (param $x i32) (param $y i32) (result i32)
    (i32.rem_s (get_local $x) (get_local $y)))
  (func (export "no_dce.i32.rem_u") (param $x i32) (param $y i32) (result i32)
    (i32.rem_u (get_local $x) (get_local $y)))
  (func (export "no_dce.i64.rem_s") (param $x i64) (param $y i64) (result i64)
    (i64.rem_s (get_local $x) (get_local $y)))
  (func (export "no_dce.i64.rem_u") (param $x i64) (param $y i64) (result i64)
    (i64.rem_u (get_local $x) (get_local $y)))
)

(assert_trap (invoke "no_dce.i32.rem_s" (i32.const 1) (i32.const 0)) "integer divide by zero")
(assert_trap (invoke "no_dce.i32.rem_u" (i32.const 1) (i32.const 0)) "integer divide by zero")
(assert_trap (invoke "no_dce.i64.rem_s" (i64.const 1) (i64.const 0)) "integer divide by zero")
(assert_trap (invoke "no_dce.i64.rem_u" (i64.const 1) (i64.const 0)) "integer divide by zero")

(module
  (func (export "no_dce.i32.trunc_s_f32") (param $x f32) (result i32) (i32.trunc_s/f32 (get_local $x)))
  (func (export "no_dce.i32.trunc_u_f32") (param $x f32) (result i32) (i32.trunc_u/f32 (get_local $x)))
  (func (export "no_dce.i32.trunc_s_f64") (param $x f64) (result i32) (i32.trunc_s/f64 (get_local $x)))
  (func (export "no_dce.i32.trunc_u_f64") (param $x f64) (result i32) (i32.trunc_u/f64 (get_local $x)))
  (func (export "no_dce.i64.trunc_s_f32") (param $x f32) (result i64) (i64.trunc_s/f32 (get_local $x)))
  (func (export "no_dce.i64.trunc_u_f32") (param $x f32) (result i64) (i64.trunc_u/f32 (get_local $x)))
  (func (export "no_dce.i64.trunc_s_f64") (param $x f64) (result i64) (i64.trunc_s/f64 (get_local $x)))
  (func (export "no_dce.i64.trunc_u_f64") (param $x f64) (result i64) (i64.trunc_u/f64 (get_local $x)))
)

(assert_trap (invoke "no_dce.i32.trunc_s_f32" (f32.const nan)) "invalid conversion to integer")
(assert_trap (invoke "no_dce.i32.trunc_u_f32" (f32.const nan)) "invalid conversion to integer")
(assert_trap (invoke "no_dce.i32.trunc_s_f64" (f64.const nan)) "invalid conversion to integer")
(assert_trap (invoke "no_dce.i32.trunc_u_f64" (f64.const nan)) "invalid conversion to integer")
(assert_trap (invoke "no_dce.i64.trunc_s_f32" (f32.const nan)) "invalid conversion to integer")
(assert_trap (invoke "no_dce.i64.trunc_u_f32" (f32.const nan)) "invalid conversion to integer")
(assert_trap (invoke "no_dce.i64.trunc_s_f64" (f64.const nan)) "invalid conversion to integer")
(assert_trap (invoke "no_dce.i64.trunc_u_f64" (f64.const nan)) "invalid conversion to integer")

(module
    (memory 1)

    (func (export "no_dce.i32.load") (param $i i32) (result i32) (i32.load (get_local $i)))
    (func (export "no_dce.i64.load") (param $i i32) (result i64) (i64.load (get_local $i)))
    (func (export "no_dce.f32.load") (param $i i32) (result f32) (f32.load (get_local $i)))
    (func (export "no_dce.f64.load") (param $i i32) (result f64) (f64.load (get_local $i)))
)

(assert_trap (invoke "no_dce.i32.load" (i32.const 65536)) "out of bounds memory access")
(assert_trap (invoke "no_dce.i64.load" (i32.const 65536)) "out of bounds memory access")
(assert_trap (invoke "no_dce.f32.load" (i32.const 65536)) "out of bounds memory access")
(assert_trap (invoke "no_dce.f64.load" (i32.const 65536)) "out of bounds memory access")
